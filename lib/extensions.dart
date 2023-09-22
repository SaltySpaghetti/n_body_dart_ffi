import 'dart:math';

extension RandomExtension on Random {
  double nextDoubleInRange(double min, double max) {
    return min + (nextDouble() * (max - min));
  }
}
