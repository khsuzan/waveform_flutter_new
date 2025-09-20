import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:waveform_flutter_new/src/waveform_event_controller.dart';

import 'amplitude.dart';
import 'listmodel.dart';
import 'waveform_bar.dart';

/// A widget that displays an animated list of waveform bars based on a stream
/// of amplitude values.
class AnimatedWaveList extends StatefulWidget {
  /// Creates an [AnimatedWaveList] widget.
  ///
  /// The [stream] parameter is the stream of amplitude values to display. The
  /// [barBuilder] parameter is an optional function to build custom waveform
  /// bars.
  const AnimatedWaveList({
    required this.stream,
    this.barBuilder,
    this.eventController,
    super.key,
  });

  final Stream<Amplitude> stream; // The stream of amplitude values.
  final WaveformEventController? eventController;
  final Widget Function(Animation<double> animation, Amplitude amplitude)?
      barBuilder;

  @override
  State<AnimatedWaveList> createState() => _AnimatedWaveListState();
}

class _AnimatedWaveListState extends State<AnimatedWaveList> {
  // Key for the AnimatedList
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  // Model for managing the list of amplitude values
  late ListModel<Amplitude> _list;
  StreamSubscription<dynamic>? eventControllerSubscription;
  StreamSubscription<Amplitude>? streamSubscription;

  // Builds a waveform bar widget using the provided animation and amplitude.
  //
  // If a custom [barBuilder] is provided, it will be used to build the bar.
  // Otherwise, a default [WaveFormBar] will be created.
  Widget _barBuilder(Animation<double> animation, Amplitude amplitude) =>
      widget.barBuilder?.call(animation, amplitude) ??
      WaveFormBar(animation: animation, amplitude: amplitude);

  // Builds a waveform bar widget for the given index and animation.
  Widget _buildItem(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) =>
      _barBuilder(animation, _list[index]);

  // Builds a waveform bar widget for a removed item with the given animation.
  Widget _buildRemovedItem(
    Amplitude amplitude,
    BuildContext context,
    Animation<double> animation,
  ) =>
      _barBuilder(animation, amplitude);

  // Inserts the next amplitude value into the list model.
  void _insert(Amplitude amplitude) => _list.insert(0, amplitude);

  @override
  void initState() {
    super.initState();

    // Initialize the list model with an empty list and the removed item
    // builder.
    _list = ListModel<Amplitude>(
      listKey: _listKey,
      initialItems: <Amplitude>[],
      removedItemBuilder: _buildRemovedItem,
    );

    // Listen to the stream and insert new amplitude values into the list.
    streamSubscription = widget.stream.listen((event) {
      if (mounted) _insert(event);
    });

    eventControllerSubscription =
        widget.eventController?.eventStream.listen((event) {
      switch (event) {
        case WaveformEventType.clear:
          final itemCount = _list.length;
          for (var i = itemCount - 1; i >= 0; i--) {
            _list.removeAt(i);
          }
        case WaveformEventType.start:
          // Handle start event if needed
          break;
        case WaveformEventType.stop:
          // Handle stop event if needed
          break;
      }
    });
  }

  @override
  void dispose() {
    eventControllerSubscription?.cancel();
    streamSubscription?.cancel();
    widget.eventController?.dispose();
    super.dispose();
  }

  // Build the AnimatedList widget.
  @override
  Widget build(BuildContext context) => AnimatedList(
        scrollDirection: Axis.horizontal,
        reverse: true,
        key: _listKey,
        initialItemCount: _list.length,
        itemBuilder: _buildItem,
      );
}
