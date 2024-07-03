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
  var method = Method.dart;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Center(
            child: NBodyDrawer(
              key: UniqueKey(),
              canvasSize: screenSize,
              particlesAmount: 3000,
              method: method,
            ),
          ),
          Positioned(
            left: 32,
            bottom: 32,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 24,
              ),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 46, 46, 46),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                method.methodName(),
                style: const TextStyle(fontSize: 48),
              ),
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
