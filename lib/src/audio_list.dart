import 'dart:io';

import 'package:audio_chat/src/globals.dart';
import 'package:audio_chat/src/widgets/audio_bubble.dart';
import 'package:flutter/material.dart';

class AudioList extends StatefulWidget {
  const AudioList({Key? key}) : super(key: key);

  @override
  State<AudioList> createState() => _AudioListState();
}

class _AudioListState extends State<AudioList> {
  List<FileSystemEntity> data = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FileSystemEntity>>(
      key: const ValueKey("futureBuilder"),
      future: fetchAudioFiles(),
      initialData: data,
      builder: (context, AsyncSnapshot<List<FileSystemEntity>> snapshot) {
        if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          data = snapshot.data!;
          return ListView.builder(
            key: const ValueKey("ListBuilder"),
            reverse: true,
            padding: const EdgeInsets.symmetric(vertical: 15),
            itemCount: snapshot.data?.length,
            itemBuilder: (BuildContext context, int index) {
              return AudioBubble(
                filepath: snapshot.data![index].path,
                key: ValueKey(snapshot.data![index].path),
              );
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
