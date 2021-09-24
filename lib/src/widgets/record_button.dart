import 'package:flutter/material.dart';

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
  double size = 50;
  double scale = 1.0;

  late Animation buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    buttonScaleAnimation = Tween<double>(begin: 1, end: 1.7).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.0, 0.2, curve: Curves.ease),
      ),
    );
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
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
          onLongPressEnd: (_) {
            debugPrint("onLongPressEnd");
            widget.controller.reverse();
          },
          onLongPressCancel: () {
            debugPrint("onLongPressCancel");
            widget.controller.reverse();
          },
          onLongPress: () {
            debugPrint("onLongPress");
          },
        ),
      ],
    );
  }
}
