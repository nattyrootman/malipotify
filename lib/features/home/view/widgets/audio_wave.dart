import 'dart:typed_data';

import 'package:flutter/material.dart';
//import 'package:just_audio/just_audio.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:myapp/core/utilities/themes/app_colors.dart';
import 'package:myapp/core/utilities/audiowave_form_painter.dart';

class AudioWave extends StatefulWidget {
  final Uint8List audioBytes;
  const AudioWave({super.key, required this.audioBytes});

  @override
  State<AudioWave> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AudioWave> {

  AudioPlayer player = AudioPlayer();

  Duration duration = Duration(seconds: 0);
  Duration position = Duration(seconds: 0);
  final AudioPlayer _audioPlayer = AudioPlayer();

  double progress = 0.0;
  List<double> samples = [];
  bool isPlaying = false;
  @override
  void initState() {
    super.initState();
    initilaizeAudioPlayer();
  }

  initilaizeAudioPlayer() async {
   await _audioPlayer.play(BytesSource(widget.audioBytes));
    setState(() {
      isPlaying = !isPlaying;
    });
    getPositionAndDuration();
  }

  getPositionAndDuration() {
    player.getCurrentPosition().then((onValue) {
      setState(() {
        position = onValue!;

        player.getDuration().then((b) {
          progress = position.inMilliseconds / b!.inMilliseconds;
        });
      });
    });

    player.getDuration().then((onValue) {
      setState(() {
        duration = onValue!;
      });
    });
  }

  String formt(Duration d) {
    String twoDigit(int n) => n.toString().padLeft(2, '0');
    final minute = twoDigit(d.inMinutes.remainder(60));
    final second = twoDigit(d.inSeconds.remainder(60));

    return '$minute:$second';
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
   
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          //alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.purpleAccent),
            borderRadius: BorderRadius.circular(10),

            gradient: AppColors.line1,
          ),

          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(formt(position)),
              IconButton(
                iconSize: 20,
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 20,
                ),
                onPressed: () {},
              ),

              CustomPaint(
                // ignore: sort_child_properties_last
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 5),
                  ),

                  child: Slider(
                    min: 0.0,
                    max: duration.inSeconds.toDouble(),
                    activeColor: Colors.blue,
                    inactiveColor: Colors.grey,
                    value: position.inSeconds.toDouble().clamp(
                      0.0,
                      duration.inSeconds.toDouble(),
                    ),
                    onChanged: (value) {},
                  ),
                ),

                painter: AudioWaveformPainter(
                  samples: samples,
                  progress: progress,
                ),
                size: Size(MediaQuery.of(context).size.width * 0.6, 25),
              ),
            ],
          ),
        ),

        SizedBox(height: 20),
      ],
    );
  }
}
