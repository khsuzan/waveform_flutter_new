import 'package:flutter/foundation.dart';

/// Controller to manage and control waveform state and actions.
import 'dart:async';

class WaveformEventController {
	/// Stream controller for passing events to listeners
	final StreamController<WaveformEventType> eventStreamController = StreamController.broadcast();

	/// Stream for listeners to subscribe to
	Stream<WaveformEventType> get eventStream => eventStreamController.stream;

	/// Emit an event
	void _emitEvent(WaveformEventType event) {
		eventStreamController.add(event);
	}

  void reset(){
    _emitEvent(WaveformEventType.clear);
  }

  bool get isClosed => eventStreamController.isClosed;

	/// Dispose the controller when done
	void dispose() {
		eventStreamController.close();
	}
}

enum WaveformEventType {
  start,
  stop,
  clear,
}
