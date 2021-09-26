import 'package:audio_chat/src/audio_list.dart';
import 'package:audio_chat/src/globals.dart';
import 'package:audio_chat/src/widgets/chat_box.dart';
import 'package:audio_chat/src/widgets/record_button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const route = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Audio Chat"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Globals.defaultPadding),
        child: Column(
          children: [
            const Expanded(child: AudioList()),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                ChatBox(controller: controller),
                const SizedBox(width: 4),
                RecordButton(controller: controller),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
