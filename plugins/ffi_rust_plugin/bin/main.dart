import 'dart:ffi';

import 'package:ffi_rust_plugin/ffi_rust_plugin.dart';

void main() {
  final p = initRust(
    3000,
    100,
    100,
    1000,
    6000,
    nullptr,
  );
  final stopwatch = Stopwatch();
  stopwatch.start();
  for (int i = 0; i < 1000; i++) {
    updateParticlesRust(p);
    if (i % 100 == 0) {
      print('$i : ${stopwatch.elapsed}');
    }
  }
  print('done');
}
