import 'dart:async';
import 'dart:io';

import 'package:audio_chat/src/audio_state.dart';
import 'package:audio_chat/src/globals.dart';
import 'package:audio_chat/src/widgets/flow_shader.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:record/record.dart';

class RecordButton extends StatefulWidget {
  const RecordButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final AnimationController controller;

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  static const double size = 55;

  final double lockerHeight = 200;
  double timerWidth = 0;

  late Animation<double> buttonScaleAnimation;
  late Animation<double> timerAnimation;
  late Animation<double> lockerAnimation;

  DateTime? startTime;
  Timer? timer;
  String recordDuration = "00:00";
  late Record record;

  @override
  void initState() {
    super.initState();
    buttonScaleAnimation = Tween<double>(begin: 1, end: 2).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticInOut),
      ),
    );
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    timerWidth =
        MediaQuery.of(context).size.width - 2 * Globals.defaultPadding - 4;
    timerAnimation =
        Tween<double>(begin: timerWidth + Globals.defaultPadding, end: 0)
            .animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.4, 1, curve: Curves.easeIn),
      ),
    );
    lockerAnimation =
        Tween<double>(begin: lockerHeight + Globals.defaultPadding, end: 0)
            .animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticInOut),
      ),
    );
  }

  @override
  void dispose() {
    record.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        lockSlider(),
        timerSlider(context),
        audioButton(),
      ],
    );
  }

  Widget lockSlider() {
    return Positioned(
      bottom: -lockerAnimation.value,
      child: Container(
        height: lockerHeight,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Globals.borderRadius),
          color: Colors.black,
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const FaIcon(FontAwesomeIcons.lock, size: 20),
            const SizedBox(height: 8),
            FlowShader(
              direction: Axis.vertical,
              child: Column(
                children: const [
                  Icon(Icons.keyboard_arrow_up),
                  Icon(Icons.keyboard_arrow_up),
                  Icon(Icons.keyboard_arrow_up),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget timerSlider(BuildContext context) {
    return Positioned(
      right: -timerAnimation.value,
      child: Container(
        height: size,
        width: timerWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Globals.borderRadius),
          color: Colors.black,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(recordDuration),
              FlowShader(
                child: const Text("Slide to cancel"),
                duration: const Duration(seconds: 3),
                flowColors: const [Colors.white, Colors.grey],
              ),
              const SizedBox(width: size),
            ],
          ),
        ),
      ),
    );
  }

  Widget audioButton() {
    return GestureDetector(
      child: Transform.scale(
        scale: buttonScaleAnimation.value,
        child: Container(
          child: const Icon(Icons.mic),
          height: size,
          width: size,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      onLongPressDown: (_) {
        debugPrint("onLongPressDown");
        widget.controller.forward();
      },
      onLongPressEnd: (details) async {
        debugPrint("onLongPressEnd");
        widget.controller.reverse();
        debugPrint(details.localPosition.toString());
        startTime = null;
        recordDuration = "00:00";
        timer?.cancel();
        if (isCancelled(details.localPosition)) {
          debugPrint("Cancelled recording");
          var filePath = await record.stop();
          debugPrint(filePath);
          File(filePath!).delete();
          debugPrint("Deleted $filePath");
        } else if (isLocked(details.localPosition)) {
          debugPrint("Locked recording");
        } else {
          var filePath = await Record().stop();
          AudioState.files.add(filePath!);
          Globals.audioListKey.currentState!
              .insertItem(AudioState.files.length - 1);
          debugPrint(filePath);
        }
      },
      onLongPressCancel: () {
        debugPrint("onLongPressCancel");
        widget.controller.reverse();
      },
      onLongPress: () async {
        debugPrint("onLongPress");
        if (await Record().hasPermission()) {
          record = Record();
          await record.start(
            path: Globals.documentPath +
                "audio_${DateTime.now().millisecondsSinceEpoch}.m4a",
            encoder: AudioEncoder.AAC,
            bitRate: 128000,
            samplingRate: 44100,
          );
          startTime = DateTime.now();
          timer = Timer.periodic(const Duration(seconds: 1), (timer) {
            final minDur = DateTime.now().difference(startTime!).inMinutes;
            final secDur = DateTime.now().difference(startTime!).inSeconds % 60;
            String min = minDur < 10 ? "0$minDur" : minDur.toString();
            String sec = secDur < 10 ? "0$secDur" : secDur.toString();
            setState(() {
              recordDuration = "$min:$sec";
            });
          });
        }
      },
    );
  }

  bool isLocked(Offset offset) {
    return (offset.dy < -85 && offset.dy > -135);
  }

  bool isCancelled(Offset offset) {
    return (offset.dx < -200);
  }
}
