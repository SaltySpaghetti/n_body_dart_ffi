import 'dart:ffi' as ffi;

import 'package:flutter/material.dart';
import 'package:n_body_dart_ffi/flutter_ffi_gen.dart';

class NBodyPainterFFI extends CustomPainter {
  final ffi.Pointer<ffi.Pointer<Particle>> particles;

  NBodyPainterFFI({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.yellow;
    // for (var i = 0; i < 10; i++) {
    //   var x = particles.value[i].pos_x;
    //   print('$x');
    // }

    for (var i=0; i<3000; i++) {
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
