import 'dart:ffi' as ffi;

import 'package:ffi_c_plugin/ffi_c_plugin_bindings_generated.dart';
import 'package:ffi_rust_plugin/ffi_rust_plugin_bindings_generated.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:n_body_dart_ffi/models.dart';
import 'package:n_body_dart_ffi/painters/c_painter.dart';
import 'package:n_body_dart_ffi/painters/dart_native_painter.dart';
import 'package:n_body_dart_ffi/painters/dart_painter.dart';
import 'package:n_body_dart_ffi/painters/rust_painter.dart';

class NBodyDrawer extends StatefulWidget {
  final Size canvasSize;
  final Method method;
  final int particlesAmount;

  const NBodyDrawer({
    required this.canvasSize,
    required this.method,
    required this.particlesAmount,
    super.key,
  });

  @override
  State<NBodyDrawer> createState() => _NBodyDrawerState();
}

class _NBodyDrawerState extends State<NBodyDrawer>
    with TickerProviderStateMixin {
  late CustomPainter painter;
  late Ticker ticker;

  late SimulationManager simulationManager;

  @override
  void initState() {
    super.initState();

    init();
  }

  void init() {
    switch (widget.method) {
      case Method.dart:
        simulationManager = NBodySimulationManagerDart(
          particlesAmount: widget.particlesAmount,
          canvasSize: widget.canvasSize,
        )..init();
        painter = NBodyPainterDart(
          particles: simulationManager.particles as List<ParticleDart>,
        );
      case Method.dartNative:
        simulationManager = NBodySimulationManagerDartNative(
          particlesAmount: widget.particlesAmount,
          canvasSize: widget.canvasSize,
        )..init();
        painter = NBodyPainterDartNative(
          particles: simulationManager.particles as List<ParticleDartNative>,
        );
      case Method.rust:
        simulationManager = NBodySimulationManagerRust(
          particlesAmount: widget.particlesAmount,
          canvasSize: widget.canvasSize,
        )..init();
        painter = NBodyPainterRust(
          particles: simulationManager.particles
              as ffi.Pointer<ffi.Pointer<ParticleRust>>,
          particlesAmount: widget.particlesAmount,
        );
      case Method.c:
        simulationManager = NBodySimulationManagerC(
          particlesAmount: widget.particlesAmount,
          canvasSize: widget.canvasSize,
        )..init();
        painter = NBodyPainterC(
          particles: simulationManager.particles as ffi.Pointer<Particle>,
          particlesAmount: widget.particlesAmount,
        );

      case Method.python:
      // TODO: Handle this case.
    }

    ticker = Ticker(tick);
    ticker.start();
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  void tick(Duration elapsed) {
    if (context.mounted) {
      setState(() {
        simulationManager.updateParticles();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRect(
          key: UniqueKey(),
          child: CustomPaint(
            painter: painter,
            size: MediaQuery.sizeOf(context),
          ),
        ),
      ],
    );
  }
}
