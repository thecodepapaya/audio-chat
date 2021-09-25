import 'package:audio_chat/src/globals.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioBubble extends StatefulWidget {
  const AudioBubble({Key? key, required this.filepath}) : super(key: key);

  final String filepath;

  @override
  State<AudioBubble> createState() => _AudioBubbleState();
}

class _AudioBubbleState extends State<AudioBubble> {
  final player = AudioPlayer();
  Duration? duration;

  @override
  void initState() {
    super.initState();
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
                  StreamBuilder<PlayerState>(
                    stream: player.playerStateStream,
                    builder: (context, snapshot) {
                      final playerState = snapshot.data;
                      final processingState = playerState?.processingState;
                      final playing = playerState?.playing;
                      if (processingState == ProcessingState.loading ||
                          processingState == ProcessingState.buffering) {
                        return GestureDetector(
                          child: const Icon(Icons.play_arrow),
                          onTap: player.play,
                        );
                      } else if (playing != true) {
                        return GestureDetector(
                          child: const Icon(Icons.play_arrow),
                          onTap: player.play,
                        );
                      } else if (processingState != ProcessingState.completed) {
                        return GestureDetector(
                          child: const Icon(Icons.pause),
                          onTap: player.pause,
                        );
                      } else {
                        return GestureDetector(
                          child: const Icon(Icons.replay),
                          onTap: () {
                            player.seek(Duration.zero);
                          },
                        );
                      }
                    },
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
