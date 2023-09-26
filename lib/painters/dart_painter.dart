import 'package:flutter/material.dart';
import 'package:n_body_dart_ffi/models.dart';

class NBodyPainterDart extends CustomPainter {
  final List<ParticleDart> particles;

  NBodyPainterDart({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final particle in particles) {
      paint.color = particle.color;

      canvas.drawCircle(
        Offset(particle.pos.x, particle.pos.y),
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
