import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';

import '../controller/audio_controllers.dart';
import '../models/position_audio_model.dart';

class AudiPlayerWidget extends StatefulWidget {
  const AudiPlayerWidget({super.key});

  @override
  State<AudiPlayerWidget> createState() => _AudiPlayerWidgetState();
}

class _AudiPlayerWidgetState extends State<AudiPlayerWidget> {
  late AudioPlayer _audioPlayer;

  final _playlist = ConcatenatingAudioSource(children: [
    AudioSource.asset(
      'assets/audio_for_papa/1Shree Ram Raksha Stotra.mp3',
      tag: const MediaItem(
        id: '1',
        title: '1RamRaksha',
      ),
    ),
    AudioSource.asset(
      'assets/audio_for_papa/2Kalbhairavashtak.mp3',
      tag: const MediaItem(
        id: '2',
        title: '2Kalbhairavashtak',
      ),
    ),
    AudioSource.asset(
      'assets/audio_for_papa/3Bhajans_by_Jagjit_Singh.mp3',
      tag: const MediaItem(
        id: '3',
        title: '3Bhajans_by_Jagjit_Singh',
      ),
    ),
//  "https://ve31.aadika.xyz/download/-_axSlApc98/mp3/128/1707657932/b6def78cd8dae345b6fcc1f606c9345c1271ce4874de986c9d26169436ac1436/1?f=x2mate.com",
//       "https://ve34.aadika.xyz/download/_CQDgICh-dk/mp3/128/1707658137/dca0e6aa4506d5dcde25e9215fd228600afb64e2bf4491be936f764f86fcad21/1?f=x2mate.com",
//       "https://ve61.aadika.xyz/download/QTAoyGByWok/mp3/128/1707658289/4f7c3651561fe4c50dc5a1229da1d012f774e74753f59ecc749e9083176f0417/1?f=x2mate.com"

    // AudioSource.uri(
    //   Uri.parse(
    //       'https://ve31.aadika.xyz/download/-_axSlApc98/mp3/128/1707657932/b6def78cd8dae345b6fcc1f606c9345c1271ce4874de986c9d26169436ac1436/1?f=x2mate.com'),
    //   tag: MediaItem(
    //     id: "1",
    //     title: "Unknown",
    //     artist: "Unknown",
    //     artUri: Uri.parse(""),
    //   ),
    // ),

    // AudioSource.uri(
    //   Uri.parse(
    //       'https://ve34.aadika.xyz/download/_CQDgICh-dk/mp3/128/1707658137/dca0e6aa4506d5dcde25e9215fd228600afb64e2bf4491be936f764f86fcad21/1?f=x2mate.com'),
    //   tag: MediaItem(
    //     id: "1",
    //     title: "Unknown",
    //     artist: "Unknown",
    //     artUri: Uri.parse(""),
    //   ),
    // ),
    // AudioSource.uri(
    //   Uri.parse(
    //       'https://ve61.aadika.xyz/download/QTAoyGByWok/mp3/128/1707658289/4f7c3651561fe4c50dc5a1229da1d012f774e74753f59ecc749e9083176f0417/1?f=x2mate.com'),
    //   tag: MediaItem(
    //     id: "1",
    //     title: "Unknown",
    //     artist: "Unknown",
    //     artUri: Uri.parse(""),
    //   ),
    // ),
  ]);
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
        title: const Text(
          'Good Morning, Pappa!',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            // fontFamily: "Consolas",
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black45, Colors.orangeAccent],
          ),
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
                    // https://socialstatusdp.com/wp-content/uploads/2023/02/Lord-Rama-HD-Image-Digital-Painting-By-Chandra-Sekhar-Poudyal-1024x1024.jpg
                    ? CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl:
                            "https://socialstatusdp.com/wp-content/uploads/2023/02/Lord-Rama-HD-Image-Digital-Painting-By-Chandra-Sekhar-Poudyal-1024x1024.jpg",
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
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
            StreamBuilder<PositionData>(
              stream: positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return ProgressBar(
                  progress: positionData?.position ?? Duration.zero,
                  buffered: positionData?.bufferedPosition ?? Duration.zero,
                  total: positionData?.duration ?? Duration.zero,
                  onSeek: _audioPlayer.seek,
                );
                // return Text("${positionData?.position ?? Duration.zero}");
              },
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
    await _audioPlayer.setAudioSource(_playlist);
    // await _audioPlayer.dynamicSetAll([
    //   "https://ve31.aadika.xyz/download/-_axSlApc98/mp3/128/1707657932/b6def78cd8dae345b6fcc1f606c9345c1271ce4874de986c9d26169436ac1436/1?f=x2mate.com",
    //   "https://ve34.aadika.xyz/download/_CQDgICh-dk/mp3/128/1707658137/dca0e6aa4506d5dcde25e9215fd228600afb64e2bf4491be936f764f86fcad21/1?f=x2mate.com",
    //   "https://ve61.aadika.xyz/download/QTAoyGByWok/mp3/128/1707658289/4f7c3651561fe4c50dc5a1229da1d012f774e74753f59ecc749e9083176f0417/1?f=x2mate.com"
    // ]);
  }
}
