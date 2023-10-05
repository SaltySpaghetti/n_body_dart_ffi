import 'dart:ffi' as ffi;

import 'package:ffi_c_plugin/ffi_c_plugin_bindings_generated.dart';
import 'package:flutter/material.dart';

class NBodyPainterC extends CustomPainter {
  final ffi.Pointer<Particle> particles;
  final int particlesAmount;

  NBodyPainterC({
    required this.particles,
    required this.particlesAmount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.yellow;

    for (var i = 0; i < particlesAmount; i++) {
      canvas.drawCircle(
        Offset(particles[i].pos_x, particles[i].pos_y),
        particles[i].mass / 1500,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
