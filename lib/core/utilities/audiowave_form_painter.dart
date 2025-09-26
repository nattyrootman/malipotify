import 'package:flutter/material.dart';

class AudioWaveformPainter extends CustomPainter {
  final List<double> samples; // valeurs audio normalisées
  final double progress; // entre 0 et 1 pour lecture

  AudioWaveformPainter({required this.samples, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint bgPaint = Paint()..color = Colors.grey.shade400;
    final Paint fgPaint = Paint()..color = Colors.blue;
    final Paint liveColor = Paint()..color = Colors.purpleAccent;

    final int sampleCount = samples.length;
    final double barWidth = size.width / sampleCount;

    for (int i = 0; i < sampleCount; i++) {
      double value = samples[i] * size.height;
      double dx = i * barWidth;

      Paint paint = (i / sampleCount) < progress ? fgPaint : bgPaint;

      canvas.drawLine(
        Offset(dx, size.height / 2 - value / 2),
        Offset(dx, size.height / 2 + value / 2),
        paint
          ..strokeWidth = barWidth * 0.6
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
