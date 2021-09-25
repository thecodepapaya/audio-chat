import 'package:audio_chat/src/globals.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioBubble extends StatefulWidget {
  const AudioBubble({Key? key, required this.filepath}) : super(key: key);

  final String filepath;

  @override
  State<AudioBubble> createState() => _AudioBubbleState();
}

class _AudioBubbleState extends State<AudioBubble>
    with SingleTickerProviderStateMixin {
  final player = AudioPlayer();
  Duration? duration;
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.ease),
    );
    controller.addListener(() {
      // if (controller.isCompleted) {
      //   controller.reset();
      //   player.seek(Duration.zero);
      // }
      debugPrint("${player.currentIndex}");
      debugPrint("${player.duration!.inMilliseconds}");
      debugPrint("${player.position.inMilliseconds}");
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    duration = await player.setFilePath(widget.filepath);
    debugPrint("File Duration: ${duration!.inMilliseconds}");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(width: MediaQuery.of(context).size.width * 0.4),
          Expanded(
            child: Container(
              height: 45,
              padding: const EdgeInsets.only(left: 12, right: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Globals.borderRadius),
                color: Colors.black,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (controller.status == AnimationStatus.dismissed) {
                        controller.forward();
                        player.play();
                      } else if (controller.status ==
                          AnimationStatus.completed) {
                        controller.reset();
                        player.seek(Duration.zero);
                      } else if (controller.status == AnimationStatus.forward) {
                        player.pause();
                        controller.reverse();
                      }
                    },
                    child: AnimatedIcon(
                      icon: AnimatedIcons.play_pause,
                      progress: animation,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: player.position.inMilliseconds /
                          (duration?.inMilliseconds ?? 1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
