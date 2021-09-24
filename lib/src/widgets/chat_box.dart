import 'package:audio_chat/src/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ChatBox extends StatefulWidget {
  const ChatBox({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final AnimationController controller;

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  late Animation animation;

  @override
  void initState() {
    super.initState();
    animation = ColorTween(begin: Colors.red, end: Colors.blue).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(
          0.4,
          1,
          curve: Curves.ease,
        ),
      ),
    );
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Globals.borderRadius),
          color: Colors.black,
          // color: animation.value,
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            maxLines: null,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
