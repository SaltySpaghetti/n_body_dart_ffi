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

  @override
  void initState() {
    super.initState();
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
                    ffi_c_plugin.initC(
                      3000,
                      100,
                      100,
                      1000,
                      6000,
                    );
                  },
                ),
                FloatingActionButton(
                  child: const Text('upd'),
                  onPressed: () {
                    ffi_c_plugin.updateParticlesC();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
