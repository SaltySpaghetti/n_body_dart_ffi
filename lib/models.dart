import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:n_body_dart_ffi/constants.dart';
import 'package:n_body_dart_ffi/extensions.dart';
import 'package:vector_math/vector_math_64.dart';

enum Method {
  dart,
  dartNative,
  ffi,
}

class ParticleDart {
  double mass;
  Vector2 pos;
  Vector2 velocity;
  double force;

  ParticleDart({
    required this.mass,
    required this.pos,
    required this.velocity,
    required this.force,
  });
}

class ParticleDartNative {
  double mass;
  double posX;
  double posY;
  double velocityX;
  double velocityY;
  double force;

  ParticleDartNative({
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
  late List<T> _particles;

  SimulationManager({required this.particlesAmount, required this.canvasSize});

  void init() {}
  void updateParticles() {}
  List<T> get particles => _particles;
}

class NBodySimulationManagerDart extends SimulationManager<ParticleDart> {
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

        double positionX = radiusX + cos(angle) * randRadius;
        double positionY = radiusY + sin(angle) * randRadius;

        double velocityX = cos(angle - pi / 2) * (randRadius) * 10;
        double velocityY = sin(angle - pi / 2) * (randRadius) * 10;

        return ParticleDart(
          mass: range(Constants.minMass, Constants.maxMass),
          pos: Vector2(positionX, positionY),
          velocity: Vector2(velocityX, velocityY),
          force: 0.0,
        );
      },
    );
  }

  @override
  void updateParticles() {
    Vector2 tmpDist = Vector2.zero();
    double dist = 0;
    double iForce = 0;
    double jForce = 0;

    List<double> accelX = List.generate(particlesAmount, (index) => 0.0);
    List<double> accelY = List.generate(particlesAmount, (index) => 0.0);

    for (int i = 0; i < particlesAmount; ++i) {
      particles[i].force = 0.0;
      for (int j = i + 1; j < particlesAmount; ++j) {
        tmpDist.x = particles[i].pos.x - particles[j].pos.x;
        tmpDist.y = particles[i].pos.y - particles[j].pos.y;
        dist = sqrt(tmpDist.x * tmpDist.x + tmpDist.y * tmpDist.y);

        iForce = particles[j].mass / (dist * dist);
        jForce = particles[i].mass / (dist * dist);

        accelX[i] -= tmpDist.x * iForce;
        accelY[i] -= tmpDist.y * iForce;

        accelX[j] += tmpDist.x * jForce;
        accelY[j] += tmpDist.y * jForce;

        particles[i].force += jForce;
        particles[j].force += iForce;
      }

      particles[i].force /= particlesAmount * 10;
    }

    for (int i = 0; i < particlesAmount; ++i) {
      particles[i].velocity += Vector2(
        accelX[i] * Constants.deltaT,
        accelY[i] * Constants.deltaT,
      );

      particles[i].pos += Vector2(
        particles[i].velocity.x * Constants.deltaT,
        particles[i].velocity.y * Constants.deltaT,
      );
    }
  }
}

class NBodySimulationManagerDartNative
    extends SimulationManager<ParticleDartNative> {
  NBodySimulationManagerDartNative({
    required super.particlesAmount,
    required super.canvasSize,
  });

  @override
  void init() {
    _particles = List.generate(
      particlesAmount,
      (index) {
        double radiusX = canvasSize.width / 2;
        double radiusY = canvasSize.height / 2;
        double circleRadius = min(radiusX, radiusY);
        double randRadius = Random().nextDoubleInRange(0, circleRadius);
        double angle = Random().nextDoubleInRange(-pi, pi);

        double positionX = radiusX + cos(angle) * randRadius;
        double positionY = radiusY + sin(angle) * randRadius;

        double velocityX = cos(angle - pi / 2) * (randRadius) * 10;
        double velocityY = sin(angle - pi / 2) * (randRadius) * 10;

        return ParticleDartNative(
          posX: positionX,
          posY: positionY,
          velocityX: velocityX,
          velocityY: velocityY,
          force: 0.0,
          mass: Random().nextDoubleInRange(
            Constants.minMass,
            Constants.maxMass,
          ),
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

    var accelX = Float64List(particlesAmount);
    var accelY = Float64List(particlesAmount);

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

class NBodySimulationManagerFFI extends SimulationManager {
  NBodySimulationManagerFFI({
    required super.particlesAmount,
    required super.canvasSize,
  });
}
