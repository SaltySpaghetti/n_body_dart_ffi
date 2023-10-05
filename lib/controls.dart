import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' show FrameTimingSummarizer;
import 'package:n_body_dart_ffi/models.dart';

class Controls extends StatelessWidget {
  const Controls({
    super.key,
    required this.method,
    required this.onMethodChanged,
  });

  final Method method;
  final Function(Method) onMethodChanged;

  @override
  Widget build(BuildContext context) {
    var selectedLanguage = ValueNotifier<List<bool>>(
        List.generate(Method.values.length, (index) => false));
    selectedLanguage.value[method.index] = true;

    return Positioned(
      left: 16,
      bottom: 16,
      child: IntrinsicHeight(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 24,
          ),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 46, 46, 46),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                method.methodName(),
                style: const TextStyle(fontSize: 25),
              ),
              const FPSCounter(),
              const SizedBox(height: 16.0),
              ValueListenableBuilder<List<bool>>(
                  valueListenable: selectedLanguage,
                  builder: (_, lang, __) {
                    return ToggleButtons(
                      borderRadius: BorderRadius.circular(8),
                      isSelected: selectedLanguage.value,
                      children: List.generate(Method.values.length,
                          (index) => Method.values[index].methodIcon()),
                      onPressed: (index) {
                        onMethodChanged(Method.values[index]);
                        for (var i = 0;
                            i < selectedLanguage.value.length;
                            i++) {
                          selectedLanguage.value[i] = i == index ? true : false;
                        }
                      },
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class FPSCounter extends StatefulWidget {
  const FPSCounter({super.key});

  @override
  State<FPSCounter> createState() => _FPSCounterState();
}

class _FPSCounterState extends State<FPSCounter> {
  int fps = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addTimingsCallback((timings) {
      final frameTimes = FrameTimingSummarizer(timings);

      if (context.mounted) {
        setState(() {
          fps = 1000000.0 ~/ frameTimes.averageFrameBuildTime.inMicroseconds;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(left: 16.0),
      height: 72,
      width: 128,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'FPS: ',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Text(
            '$fps',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
