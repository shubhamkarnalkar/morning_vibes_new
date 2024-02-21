// import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App!!',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.amber,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const AudiPlayerWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}

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
          iconSize: 60,
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
                icon: const Icon(Icons.play_arrow_rounded),
                iconSize: 80,
                color: Colors.white,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(Icons.pause_rounded),
                onPressed: audioPlayer.pause,
                color: Colors.white,
                iconSize: 80,
              );
            }
            return const Icon(
              Icons.play_arrow_rounded,
              size: 80,
              color: Colors.white,
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.skip_next_rounded),
          onPressed: audioPlayer.seekToNext,
          iconSize: 60,
          color: Colors.white,
        ),
      ],
    );
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  const PositionData(this.position, this.bufferedPosition, this.duration);
}
