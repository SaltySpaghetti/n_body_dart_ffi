import 'dart:ffi' as ffi;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:n_body_dart_ffi/flutter_ffi_gen.dart';
import 'package:n_body_dart_ffi/models.dart';
import 'package:n_body_dart_ffi/painters/c_painter.dart';
import 'package:n_body_dart_ffi/painters/dart_native_painter.dart';
import 'package:n_body_dart_ffi/painters/dart_painter.dart';
import 'package:n_body_dart_ffi/painters/rust_painter.dart';

class NBodyDrawer extends StatefulWidget {
  final Size canvasSize;

  const NBodyDrawer({
    required this.canvasSize,
    super.key,
  });

  @override
  State<NBodyDrawer> createState() => _NBodyDrawerState();
}

class _NBodyDrawerState extends State<NBodyDrawer>
    with TickerProviderStateMixin {
  var method = Method.c;
  var particlesAmount = 3000;

  late CustomPainter painter;
  late Ticker ticker;
  late Stopwatch stopwatch;

  var frames = 0;
  var previousSecond = 0;
  var lastSecondFrames = 0;
  final languageIcons = [
    Icon(MdiIcons.languageRust),
    Icon(MdiIcons.languageC),
    Icon(MdiIcons.languagePython),
    Icon(MdiIcons.sackPercent),
  ];

  late List<bool> selectedLanguage;
  late SimulationManager simulationManager;

  @override
  void initState() {
    super.initState();
    selectedLanguage = [
      true,
      ...List.generate(languageIcons.length - 1, (index) => false)
    ];
    init();
  }

  void init() {
    switch (method) {
      case Method.dart:
        simulationManager = NBodySimulationManagerDart(
          particlesAmount: particlesAmount,
          canvasSize: widget.canvasSize,
        )..init();
        painter = NBodyPainterDart(
          particles: simulationManager.particles as List<ParticleDart>,
        );
      case Method.dartNative:
        simulationManager = NBodySimulationManagerDartNative(
          particlesAmount: particlesAmount,
          canvasSize: widget.canvasSize,
        )..init();
        painter = NBodyPainterDartNative(
          particles: simulationManager.particles as List<ParticleDartNative>,
        );
      case Method.rust:
        simulationManager = NBodySimulationManagerRust(
          particlesAmount: particlesAmount,
          canvasSize: widget.canvasSize,
        )..init();
        painter = NBodyPainterRust(
          particles:
              simulationManager.particles as ffi.Pointer<ffi.Pointer<Particle>>,
        );
      case Method.c:
        simulationManager = NBodySimulationManagerC(
          particlesAmount: particlesAmount,
          canvasSize: widget.canvasSize,
        )..init();
        painter = NBodyPainterC(
          particles:
              simulationManager.particles as ffi.Pointer<Particle>,
        );
        
      case Method.python:
        // TODO: Handle this case.
    }

    ticker = Ticker(tick);
    ticker.start();
    stopwatch = Stopwatch();
    stopwatch.start();
  }

  void tick(Duration elapsed) {
    if (stopwatch.elapsedMilliseconds > 1000) {
      lastSecondFrames = frames;
      stopwatch.reset();
      frames = 1;
    }

    setState(() {
      simulationManager.updateParticles();
      previousSecond = elapsed.inSeconds;
      frames++;
    });
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
        Positioned(
          left: 16,
          bottom: 16,
          child: IntrinsicHeight(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 24,
              ),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 46, 46, 46),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.methodName(),
                    style: const TextStyle(fontSize: 25),
                  ),
                  Text(
                    "FPS: $lastSecondFrames",
                    style: const TextStyle(fontSize: 25),
                  ),
                  const SizedBox(height: 16.0),
                  ToggleButtons(
                    borderRadius: BorderRadius.circular(8),
                    isSelected: selectedLanguage,
                    children: languageIcons,
                    onPressed: (index) {
                      setState(() {
                        selectedLanguage = List.generate(
                            languageIcons.length, (index) => false);
                        selectedLanguage[index] = true;
                      });
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }
}
