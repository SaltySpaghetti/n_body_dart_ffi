// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:logging/logging.dart';
import 'package:native_assets_cli/native_assets_cli.dart';

void main(List<String> args) async {
  await build(args, (config, output) async {
    await Process.run(
      'cargo',
      ['build', '--release'],
      workingDirectory: config.packageRoot.resolve('src/rust/').toFilePath(),
    );
    // TODO: use config.outputDirectory and tell to cargo.
    output.addAsset(
      NativeCodeAsset(
        package: 'ffi_rust_plugin',
        name: 'ffi_rust_plugin_bindings_generated.dart',
        linkMode: DynamicLoadingBundled(),
        os: config.targetOS,
        architecture: config.targetArchitecture,
        file: config.packageRoot
            .resolve('src/rust/target/release/libn_body_rust_simulation.dylib'),
      ),
    );
    // TODO output.addDependencies
  });
}
