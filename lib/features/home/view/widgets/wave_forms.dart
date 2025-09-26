 import 'package:audioplayers/audioplayers.dart';
import 'dart:typed_data';

import 'package:flutter/material.dart';
//import 'package:just_audio/just_audio.dart';
import 'package:myapp/core/utilities/themes/app_colors.dart';
import 'package:myapp/core/utilities/audiowave_form_painter.dart';

// ignore: must_be_immutable
class AudioWavePlayer extends StatelessWidget {
//final String audioPath;
  final Uint8List audioPath;
  final AudioPlayer player;
  final List<double> samples;
  final double progress;
  final Duration duration;
  final Duration position;
  final String textFormat;
  final VoidCallback onPlay;
  final Function(double) onSeek;
   final double currrentValue;
   final bool isPlaying;

  const AudioWavePlayer({
    super.key,
    required this.audioPath,
    required this.player,
 
    this.duration = Duration.zero,
    this.position = Duration.zero,
    required this.samples,
    this.progress = 0.0,
    this.textFormat = 'mm:ss',
    required this.onPlay,
    required this.onSeek,
    this.currrentValue=0.0,
    this.isPlaying=false
  });

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
              Text(textFormat),
              IconButton(
                iconSize: 20,
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 20,
                ),
                onPressed: onPlay,
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
                    value: position.inSeconds.toDouble().clamp(0.0, duration.inSeconds.toDouble()),
                    onChanged: onSeek,
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
