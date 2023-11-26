import 'package:flutter/material.dart';
import 'package:n_body_dart_ffi/controls.dart';
import 'package:n_body_dart_ffi/models.dart';
import 'package:n_body_dart_ffi/painters/n_body.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var method = Method.dartNative;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: NBodyDrawer(
              key: UniqueKey(),
              canvasSize: screenSize,
              particlesAmount: 3000,
              method: method,
            ),
          ),
          Controls(
            method: method,
            onMethodChanged: (m) {
              if (context.mounted) {
                setState(() {
                method = m;
              });
              }
            },
          )
        ],
      ),
    );
  }
}
