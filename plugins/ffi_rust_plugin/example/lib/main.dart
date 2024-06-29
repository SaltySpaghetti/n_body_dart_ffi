import 'dart:async';
import 'dart:ffi';

import 'package:ffi_rust_plugin/ffi_rust_plugin.dart' as ffi_rust_plugin;
import 'package:ffi_rust_plugin/ffi_rust_plugin_bindings_generated.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late int sumResult;
  late Future<int> sumAsyncResult;
  Pointer<NBody> ffiRust = nullptr;
  Pointer<ParticleRust> p = nullptr;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Native Packages'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                FloatingActionButton(
                  child: const Text('init'),
                  onPressed: () {
                    ffiRust = ffi_rust_plugin.initRust(
                      3000,
                      100,
                      100,
                      1000,
                      6000,
                      ffiRust,
                    );
                  },
                ),
                FloatingActionButton(
                  child: const Text('upd'),
                  onPressed: () {
                    p = ffi_rust_plugin.updateParticlesRust(ffiRust);
                    controller.text = '';
                    for (var i = 0; i < 3; i++) {
                      controller.text = '${controller.text}  ${p[i].pos_x}';
                    }
                    setState(() {});
                  },
                ),
                TextField(
                  readOnly: true,
                  controller: controller,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
