import 'package:audio_chat/src/widgets/record_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ChatBox extends StatelessWidget {
  const ChatBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.black,
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
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
