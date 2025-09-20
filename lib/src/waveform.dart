// ...existing code...
import 'package:flutter/material.dart';
import 'package:waveform_flutter_new/src/waveform_event_controller.dart';

import 'amplitude.dart';
import 'amplitude_helpers.dart';
import 'animated_wave_list.dart';

class Waveform extends StatelessWidget {
  final WaveformEventController? eventController;
  const Waveform({super.key, this.amplitudeStream, this.eventController});

  final Stream<Amplitude>? amplitudeStream;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final stream = amplitudeStream ?? createRandomAmplitudeStream();
    return SizedBox(
      width: width,
      height: 100,
      child: AnimatedWaveList(
        stream: stream,
        eventController: eventController,
      ),
    );
  }
}
