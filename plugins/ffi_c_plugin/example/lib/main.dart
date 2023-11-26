import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:ffi_c_plugin/ffi_c_plugin.dart' as ffi_c_plugin;

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
                    controller.text = '';
                    ffi_c_plugin.initC(
                      3000,
                      100,
                      100,
                      1000,
                      6000,
                    );
                    setState(() {});
                  },
                ),
                FloatingActionButton(
                  child: const Text('upd'),
                  onPressed: () {
                    var p = ffi_c_plugin.updateParticlesC();
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
