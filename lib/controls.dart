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
      bottom: 16.0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FPSCounter(),
              const SizedBox(height: 16.0),
              ValueListenableBuilder<List<bool>>(
                valueListenable: selectedLanguage,
                builder: (_, lang, __) {
                  return Container(
                    padding: const EdgeInsets.symmetric(),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 46, 46, 46),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ToggleButtons(
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
                    ),
                  );
                },
              ),
            ],
          ),
        ],
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: FPSContainer(fps: fps),
    );
  }
}

class FPSContainer extends StatelessWidget {
  const FPSContainer({
    super.key,
    required this.fps,
  });

  final int fps;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 250,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 24,
      ),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 46, 46, 46),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'FPS: ',
            style: TextStyle(
              fontSize: 48,
            ),
          ),
          Text(
            '$fps',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
