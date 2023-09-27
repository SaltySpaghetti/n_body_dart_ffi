import 'dart:ffi';
import 'dart:io';

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
    nativeLib = Platform.isLinux
        ? DynamicLibrary.open('src/n_body_simulation/target/release/libn_body_simulation.so')
        : (Platform.isAndroid
            ? DynamicLibrary.open('src/n_body_simulation/target/debug/libn_body_simulation.so')
            : (Platform.isWindows
                ? DynamicLibrary.open('src/n_body_simulation/target/debug/n_body_simulation.dll')
                : DynamicLibrary.process()));
  }
}