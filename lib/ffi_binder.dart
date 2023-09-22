import 'dart:ffi';

import 'package:n_body_dart_ffi/flutter_ffi_gen.dart';

/// Controller that expose method channel and FFI
class FFIBinder {
  late DynamicLibrary nativeLib;
  late FFINativeBinding nativeBinding;

  static FFIBinder? _instance;

  factory FFIBinder() => _instance ??= FFIBinder._();

  FFIBinder._() {
    initialize();
    nativeBinding = FFINativeBinding.fromLookup(nativeLib.lookup);
  }

  void initialize() {
    nativeLib = DynamicLibrary.open(
      'src/n_body_simulation/target/debug/n_body_simulation.dll',
    );
  }
}
