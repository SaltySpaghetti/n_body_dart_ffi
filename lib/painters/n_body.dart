import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:n_body_dart_ffi/models.dart';
import 'package:n_body_dart_ffi/painters/dart_native_painter.dart';
import 'package:n_body_dart_ffi/painters/dart_painter.dart';

class NBodyDrawer extends StatefulWidget {
  final Method method;
  final int particlesAmount;
  final Size canvasSize;

  const NBodyDrawer({
    super.key,
    required this.particlesAmount,
    required this.canvasSize,
    required this.method,
  });

  @override
  State<NBodyDrawer> createState() => _NBodyDrawerState();
}

class _NBodyDrawerState extends State<NBodyDrawer>
    with TickerProviderStateMixin {
  late CustomPainter painter;
  late Ticker ticker;
  late Stopwatch stopwatch;
  var frames = 0;
  var previousSecond = 0;
  var lastSecondFrames = 0;

  late SimulationManager simulationManager;

  @override
  void didUpdateWidget(covariant NBodyDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.method != widget.method) {
      init();
    }
  }

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
      case Method.ffi:
        simulationManager = NBodySimulationManagerFFI(
          particlesAmount: widget.particlesAmount,
          canvasSize: widget.canvasSize,
        );
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
                    widget.method.methodName(),
                    style: const TextStyle(fontSize: 25),
                  ),
                  Text(
                    "FPS: $lastSecondFrames",
                    style: const TextStyle(fontSize: 25),
                  ),
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
