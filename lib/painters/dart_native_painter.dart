
import 'package:flutter/material.dart';
import 'package:n_body_dart_ffi/models.dart';

class NBodyPainterDartNative extends CustomPainter {
  final List<ParticleDartNative> particles;

  NBodyPainterDartNative({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.yellow;
    for (final particle in particles) {
      canvas.drawCircle(
        Offset(particle.posX, particle.posY),
        particle.mass / 1500,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
