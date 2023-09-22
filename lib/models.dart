import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:n_body_dart_ffi/constants.dart';

enum Method {
  dart,
  dartNative,
  ffi,
}

class Particle {
  double mass;
  double posX;
  double posY;
  double velocityX;
  double velocityY;
  double force;

  Particle({
    required this.mass,
    required this.posX,
    required this.posY,
    required this.velocityX,
    required this.velocityY,
    required this.force,
  });
}

abstract class SimulationManager<T> {
  final int particlesAmount;
  final Size canvasSize;
  late T _particles;

  SimulationManager({required this.particlesAmount, required this.canvasSize});

  void init() {}
  void updateParticles() {}
  T get particles => _particles;
}

class NBodySimulationManagerDart extends SimulationManager<List<Particle>> {
  NBodySimulationManagerDart({
    required super.particlesAmount,
    required super.canvasSize,
  });

  double range(double min, double max) {
    return min + (Random().nextDouble() * (max - min));
  }

  @override
  void init() {
    _particles = List.generate(
      particlesAmount,
      (index) {
        double radiusX = canvasSize.width / 2;
        double radiusY = canvasSize.height / 2;
        double circleRadius = min(radiusX, radiusY);
        double randRadius = range(0, circleRadius);
        double angle = range(-pi, pi);

        /// position
        double px = radiusX + cos(angle) * randRadius;
        double py = radiusY + sin(angle) * randRadius;

        /// spin
        double sx = cos(angle - pi / 2) * (randRadius) * 10;
        double sy = sin(angle - pi / 2) * (randRadius) * 10;

        return Particle(
          mass: range(Constants.minMass, Constants.maxMass),
          posX: px,
          posY: py,
          velocityX: sx,
          velocityY: sy,
          force: 0.0,
        );
      },
    );
  }

  @override
  void updateParticles() {
    double distX = 0;
    double distY = 0;
    double dist = 0;
    double fI = 0;
    double fJ = 0;

    List<double> accelX = List.generate(particlesAmount, (index) => 0.0);
    List<double> accelY = List.generate(particlesAmount, (index) => 0.0);

    for (int i = 0; i < particlesAmount; ++i) {
      particles[i].force = 0.0;
      for (int j = i + 1; j < particlesAmount; ++j) {
        distX = particles[i].posX - particles[j].posX;
        distY = particles[i].posY - particles[j].posY;
        dist = sqrt(distX * distX + distY * distY);

        fI = particles[j].mass / (dist * dist);
        fJ = particles[i].mass / (dist * dist);

        accelX[i] -= distX * fI;
        accelY[i] -= distY * fI;

        accelX[j] += distX * fJ;
        accelY[j] += distY * fJ;

        particles[i].force += fJ;
        particles[j].force += fI;
      }

      particles[i].force /= particlesAmount * 10;
    }

    for (int i = 0; i < particlesAmount; ++i) {
      particles[i].velocityX += accelX[i] * Constants.deltaT;
      particles[i].velocityY += accelY[i] * Constants.deltaT;

      particles[i].posX += particles[i].velocityX * Constants.deltaT;
      particles[i].posY += particles[i].velocityY * Constants.deltaT;
    }
  }
}

class NBodySimulationManagerDartNative extends SimulationManager<Float64List> {
  NBodySimulationManagerDartNative({
    required super.particlesAmount,
    required super.canvasSize,
  });
}

class NBodySimulationManagerFFI extends SimulationManager {
  NBodySimulationManagerFFI({
    required super.particlesAmount,
    required super.canvasSize,
  });
}
