import 'package:flutter/material.dart';
import 'package:waveform_flutter_new/waveform_flutter_new.dart';

void main() {
  runApp(const MyHomePage());
}
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key,});


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
            child: Waveform(), // Shows live waveform
          ),
        ),
      ),
    );
  }
}