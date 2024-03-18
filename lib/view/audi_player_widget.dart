import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:morning_vibes/common/extensions/greetings_for_date.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/services.dart';

import '../common/constants_app.dart';
import '../controller/audio_controllers.dart';
import '../models/position_audio_model.dart';

class AudiPlayerWidget extends StatefulWidget {
  const AudiPlayerWidget({super.key});

  @override
  State<AudiPlayerWidget> createState() => _AudiPlayerWidgetState();
}

class _AudiPlayerWidgetState extends State<AudiPlayerWidget>
    with WidgetsBindingObserver {
  late AudioPlayer _audioPlayer;
  final String _greeting = DateTime.now().getGreetingFromHour();
  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, bufferedPositionStream, duration) => PositionData(
            position, bufferedPositionStream, duration ?? Duration.zero),
      );
  @override
  void initState() {
    _audioPlayer = AudioPlayer();
    _init();
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const String assetImage = "";
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _greeting,
          style: const TextStyle(
            // fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            // fontFamily: "Consolas",
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
        // centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors: [Colors.black45, Colors.orangeAccent],
          // ),
          color: Colors.black,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(2, 4),
                    blurRadius: 4,
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: assetImage.isEmpty
                    // ? CachedNetworkImage(
                    //     fit: BoxFit.cover,
                    //     imageUrl: ConstantsApp.defaultImageUrl,
                    //     placeholder: (context, url) =>
                    //         const CircularProgressIndicator(),
                    //     errorWidget: (context, url, error) =>
                    //         const Icon(Icons.error),
                    //   )
                    ? ExtendedImage.network(
                        ConstantsApp.defaultImageUrl,
                        fit: BoxFit.cover,
                        cache: true,
                        // border: Border.all(color: Colors.red, width: 1.0),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                      )
                    : Image.asset(
                        assetImage,
                        height: 300,
                        width: 300,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            // const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<PositionData>(
                stream: positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  return ProgressBar(
                    progress: positionData?.position ?? Duration.zero,
                    buffered: positionData?.bufferedPosition ?? Duration.zero,
                    total: positionData?.duration ?? Duration.zero,
                    onSeek: _audioPlayer.seek,
                    barHeight: 3,
                    baseBarColor: Colors.white24,
                    barCapShape: BarCapShape.round,
                    bufferedBarColor: Colors.black38,
                    progressBarColor: Colors.white,
                    thumbColor: Colors.white,
                    thumbRadius: 4,
                    timeLabelPadding: 15,
                    timeLabelTextStyle: const TextStyle(
                      // fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  );
                  // return Text("${positionData?.position ?? Duration.zero}");
                },
              ),
            ),
            // const SizedBox(height: 20),
            Controls(
              audioPlayer: _audioPlayer,
            ),
          ],
        ),
      ),
    );
  }

  Future _init() async {
    await _audioPlayer.setLoopMode(LoopMode.all);
    // await _audioPlayer.setAudioSource();
  }
}
