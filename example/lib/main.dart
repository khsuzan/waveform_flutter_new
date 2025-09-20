import 'dart:math';

import 'package:flutter/material.dart';
import 'package:waveform_flutter_new/waveform_flutter_new.dart';
import 'package:waveform_flutter_new/src/waveform_event_controller.dart';

void main() {
  runApp(const MyHomePage());
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late WaveformEventController _eventController;

  @override
  void initState() {
    super.initState();
    _eventController = WaveformEventController();
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }


  Stream<Amplitude> createTenSecondStream() async* {
    final random = Random();
    for (var i = 0; i < 100; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      yield Amplitude(current: random.nextDouble() * 100, max: 100);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Waveform Example'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Waveform(
                  amplitudeStream: createTenSecondStream(),
                  eventController: _eventController,
                ), // Shows live waveform
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (!_eventController.isClosed) {
                      _eventController.reset();
                    }
                  },
                  child: const Text('Clear Wave'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
