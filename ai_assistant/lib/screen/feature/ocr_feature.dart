import 'package:flutter/material.dart';

class OcrFeature extends StatefulWidget {
  const OcrFeature({super.key});

  @override
  State<OcrFeature> createState() => _OcrFeatureState();
}

class _OcrFeatureState extends State<OcrFeature> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Text Recognition')),
      body: ListView(children: []),
    );
  }
}
