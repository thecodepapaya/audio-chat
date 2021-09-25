import 'dart:io';

import 'package:audio_chat/src/globals.dart';
import 'package:audio_chat/src/widgets/audio_bubble.dart';
import 'package:flutter/material.dart';

class AudioList extends StatelessWidget {
  const AudioList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FileSystemEntity>>(
      future: fetchAudioFiles(),
      builder: (context, AsyncSnapshot<List<FileSystemEntity>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            reverse: true,
            padding: const EdgeInsets.symmetric(vertical: 15),
            itemCount: snapshot.data?.length,
            itemBuilder: (BuildContext context, int index) {
              return AudioBubble(filepath: snapshot.data![index].path);
            },
          );
        } else {
          return const Center(
            child: Text("No Audio files"),
          );
        }
      },
    );
  }

  Future<List<FileSystemEntity>> fetchAudioFiles() async {
    String dirPath = Globals.documentPath;
    List<FileSystemEntity> file = Directory(dirPath).listSync();
    file.removeWhere((element) => !element.path.endsWith("m4a"));
    file = file.reversed.toList();
    return file;
  }
}
