// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:native_assets_cli/native_assets_cli.dart';

void main(List<String> args) async {
  await build(args, (config, output) async {
    final target = config.targetArchitecture == Architecture.arm64
        ? 'aarch64-apple-darwin'
        : 'x86_64-apple-darwin';
    final result = await Process.run(
      'cargo',
      [
        'build',
        '--release',
        '--target=$target',
        '--target-dir=${config.outputDirectory.toFilePath()}'
      ],
      workingDirectory: config.packageRoot.resolve('src/rust/').toFilePath(),
    );

    if (result.exitCode != 0) {
      print('${result.stderr} ${result.stdout}');
      throw 'cargo build failed';
    }
    // TODO: use config.outputDirectory and tell to cargo.
    output.addAsset(
      NativeCodeAsset(
        package: 'ffi_rust_plugin',
        name: 'ffi_rust_plugin_bindings_generated.dart',
        linkMode: DynamicLoadingBundled(),
        os: config.targetOS,
        architecture: config.targetArchitecture,
        file: config.outputDirectory
            .resolve('$target/release/libn_body_rust_simulation.dylib'),
      ),
    );
    output.addDependencies([
      config.packageRoot.resolve('hook/build.dart'),
    ]);
    // TODO output.addDependencies
  });
}
