import 'package:flutter/material.dart';

class SpeechToTextFeature extends StatefulWidget {
  const SpeechToTextFeature({super.key});

  @override
  State<SpeechToTextFeature> createState() => _SpeechToTextFeatureState();
}

class _SpeechToTextFeatureState extends State<SpeechToTextFeature> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Speech to Text')),
      body: ListView(children: []),
    );
  }
}
