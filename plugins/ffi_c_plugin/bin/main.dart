import 'package:ffi_c_plugin/ffi_c_plugin.dart';

void main() {
  initC(
    3000,
    100,
    100,
    1000,
    6000,
  );
  final stopwatch = Stopwatch();
  stopwatch.start();
  for (int i = 0; i < 1000; i++) {
    updateParticlesC();
    if (i % 10 == 0) {
      print('$i : ${stopwatch.elapsed}');
    }
  }
  print('done');
}
