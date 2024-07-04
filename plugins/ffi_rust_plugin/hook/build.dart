// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:native_assets_cli/native_assets_cli.dart';
import 'package:native_toolchain_rust/native_toolchain_rust.dart';

void main(List<String> args) async {
  await build(args, (config, output) async {
    final builder = RustBuilder(
      package: 'ffi_rust_plugin',
      cratePath: 'src/rust',
      // Specify custom name to match the dart file, otherwise crate name is used.
      assetName: 'ffi_rust_plugin_bindings_generated.dart',
      buildConfig: config,
      useNativeManifest: false,
    );
    await builder.run(output: output);
    output.addDependencies([
      config.packageRoot.resolve('hook/build.dart'),
    ]);
  });
}
