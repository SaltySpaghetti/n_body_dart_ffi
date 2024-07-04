import 'dart:ffi';
import 'dart:io';
import 'dart:ffi' as ffi;

import 'ffi_c_plugin_bindings_generated.dart';

const String _libName = 'ffi_c_plugin';

/// The dynamic library in which the symbols for [FfiCPluginBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

void initC(
  int particlesAmount,
  double canvasWidth,
  double canvasHeight,
  double minMass,
  double maxMass,
) =>
    init_c(particlesAmount, canvasWidth, canvasHeight, minMass, maxMass);

ffi.Pointer<Particle> updateParticlesC() => update_particles_c();
