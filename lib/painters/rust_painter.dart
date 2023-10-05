import 'dart:ffi' as ffi;

import 'package:ffi_rust_plugin/ffi_rust_plugin_bindings_generated.dart';
import 'package:flutter/material.dart';

class NBodyPainterRust extends CustomPainter {
  final ffi.Pointer<ffi.Pointer<ParticleRust>> particles;
  final int particlesAmount;

  NBodyPainterRust({
    required this.particles,
    required this.particlesAmount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.yellow;

    for (var i = 0; i < particlesAmount; i++) {
      canvas.drawCircle(
        Offset(particles.value[i].pos_x, particles.value[i].pos_y),
        particles.value[i].mass / 1500,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
