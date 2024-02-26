import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Controls extends StatelessWidget {
  const Controls({super.key, required this.audioPlayer});
  final AudioPlayer audioPlayer;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.skip_previous_rounded),
          onPressed: audioPlayer.seekToPrevious,
          iconSize: 50,
          color: Colors.white,
        ),
        StreamBuilder<PlayerState>(
          stream: audioPlayer.playerStateStream,
          builder: (BuildContext context, AsyncSnapshot<PlayerState> snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            // debugPrint(playing.toString());
            if (!(playing ?? false)) {
              return IconButton(
                onPressed: audioPlayer.play,
                icon: const Icon(Icons.play_circle),
                iconSize: 70,
                color: Colors.white,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(Icons.pause_rounded),
                onPressed: audioPlayer.pause,
                color: Colors.white,
                iconSize: 50,
              );
            }
            return const Icon(
              Icons.play_circle,
              size: 70,
              color: Colors.white,
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.skip_next_rounded),
          onPressed: audioPlayer.seekToNext,
          iconSize: 50,
          color: Colors.white,
        ),
      ],
    );
  }
}
