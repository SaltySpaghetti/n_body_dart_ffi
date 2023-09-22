import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:n_body_dart_ffi/models.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var particlesAmount = 2000;
  var method = Method.dart;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: screenSize.height / 3 * 2 - 32,
                width: screenSize.width,
                child: Container(
                  color: Colors.purple,
                  child: NBodyDrawer(
                    method: method,
                    particlesAmount: particlesAmount,
                    canvasSize: Size(
                      screenSize.width - 32,
                      screenSize.height / 3 * 2 - 32,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                height: screenSize.height / 3 - 16,
                width: screenSize.width,
                child: Container(color: Colors.blue),
              )
            ],
          ),
        ),
      ),
    );
  }
}

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
  late Ticker? ticker;

  late SimulationManager simulationManager;

  @override
  void initState() {
    super.initState();

    ticker = Ticker(tick);
    ticker?.start();
  }

  void tick(Duration elapsed) {
    setState(() {
      simulationManager.updateParticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.method) {
      case Method.dart:
        simulationManager = NBodySimulationManagerDart(
          particlesAmount: widget.particlesAmount,
          canvasSize: widget.canvasSize,
        )..init();
        painter = NBodyPainterDart(particles: simulationManager.particles);
      case Method.dartNative:
        var simulationManager = NBodySimulationManagerDartNative(
          particlesAmount: widget.particlesAmount,
          canvasSize: widget.canvasSize,
        );
      case Method.ffi:
        var simulationManager = NBodySimulationManagerFFI(
          particlesAmount: widget.particlesAmount,
          canvasSize: widget.canvasSize,
        );
    }

    return ClipRect(
      child: CustomPaint(painter: painter),
    );
  }

  @override
  void dispose() {
    ticker?.dispose();
    super.dispose();
  }
}

class NBodyPainterDart extends CustomPainter {
  final List<Particle> particles;

  NBodyPainterDart({required this.particles});

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
