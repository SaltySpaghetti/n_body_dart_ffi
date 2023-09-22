import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:n_body_dart_ffi/constants.dart';
import 'package:n_body_dart_ffi/ffi_binder.dart';
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
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
        child: NBodyDrawer(
          method: method,
          particlesAmount: particlesAmount,
          canvasSize: screenSize,
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        FFIBinder().nativeBinding.init(
              particlesAmount,
              screenSize.width,
              screenSize.height,
              Constants.minMass,
              Constants.maxMass,
            );
        setState(() {
          method = method == Method.dart ? Method.dartNative : Method.dart;
        });
      }),
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
                    widget.method.toString(),
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

class NBodyPainterDart extends CustomPainter {
  final List<ParticleDart> particles;

  NBodyPainterDart({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.yellow;
    for (final particle in particles) {
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
