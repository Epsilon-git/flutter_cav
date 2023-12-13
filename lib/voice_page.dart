import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class VoicePage extends StatefulWidget {
  const VoicePage({super.key});

  @override
  State<VoicePage> createState() => _VoicePageState();
}

class _VoicePageState extends State<VoicePage> {
  bool showPlayer = false;

  late AudioRecorder audioRecord;
  late AudioPlayer audioPlayer;
  String recordPath = '';
  bool isRecording = false;

  Future<void> startRecording() async {
    if (await audioRecord.hasPermission()) {
      await audioRecord.start(const RecordConfig(), path: await getVoicePath());

      ///
      setState(() => isRecording = true);
    }
  }

  Future<String> getVoicePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return path.join(
      dir.path,
      'audio_${DateTime.now().millisecondsSinceEpoch}.wav',
    );
  }

  Future<void> stopRecording() async {
    recordPath = await audioRecord.stop() ?? '';

    setState(() {
      isRecording = false;
      showPlayer = true;
    });
  }

  Future<void> playSound() async {
    Source urlSource = UrlSource(recordPath);

    await audioPlayer.play(urlSource);

    setState(() {
      showPlayer = false;
    });
  }

  Future<void> stopSound() async {
    await audioPlayer.stop();
  }

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    audioRecord = AudioRecorder();

    //
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!showPlayer) ...{
          !isRecording
              ? IconButton(
                  onPressed: startRecording,
                  iconSize: 48,
                  icon: const Icon(Icons.mic),
                )
              : IconButton(
                  onPressed: stopRecording,
                  iconSize: 48,
                  icon: const Icon(Icons.stop_rounded),
                ),
        } else ...{
          IconButton(
            onPressed: playSound,
            iconSize: 48,
            icon: const Icon(Icons.play_arrow_rounded),
          ),
        }
      ],
    );
  }

  @override
  void dispose() {
    audioRecord.dispose();
    audioPlayer.dispose();

    //
    super.dispose();
  }
}
