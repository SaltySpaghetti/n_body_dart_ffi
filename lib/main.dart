import 'package:flutter/material.dart';
import 'package:n_body_dart_ffi/constants.dart';
import 'package:n_body_dart_ffi/ffi_binder.dart';
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
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
  var particlesAmount = 2000;
  var method = Method.dart;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Center(
        child: NBodyDrawer(
          method: method,
          particlesAmount: particlesAmount,
          canvasSize: screenSize,
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        FFIBinder().nativeBinding.init(
              particlesAmount,
              screenSize.width,
              screenSize.height,
              Constants.minMass,
              Constants.maxMass,
            );

        FFIBinder().nativeBinding.update_particles();
        setState(() {
          method = method == Method.dart ? Method.dartNative : Method.dart;
        });
      }),
    );
  }
}
