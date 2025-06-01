// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_to_text.dart';

// class SpeechToTextFeature extends StatefulWidget {
//   const SpeechToTextFeature({super.key});

//   @override
//   State<SpeechToTextFeature> createState() => _SpeechToTextFeatureState();
// }

// class _SpeechToTextFeatureState extends State<SpeechToTextFeature> {
//   final SpeechToText _speechToText = SpeechToText();
//   bool _speechEnabled = false;
//   String _wordsSpoken = '';
//   double _confidenceLevel = 0;

//   @override
//   void initState() {
//     super.initState();
//     initSpeech();
//   }

//   void initSpeech() async {
//     _speechEnabled = await _speechToText.initialize();
//     setState(() {});
//   }

//   void _startListening() async {
//     await _speechToText.listen(onResult: _onSpeechResult);
//     setState(() {
//       _confidenceLevel = 0;
//     });
//   }

//   void _stopListening() async {
//     await _speechToText.stop();
//     setState(() {});
//   }

//   void _onSpeechResult(result) {
//     setState(() {
//       _wordsSpoken = '${result.recognizedWords}';
//       _confidenceLevel = result.confidence;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Speech to Text')),
//       body: Center(
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(16),
//               child: Text(
//                 _speechToText.isListening
//                     ? 'Listening...'
//                     : _speechEnabled
//                     ? 'Tap the microphone to start listening...'
//                     : 'Speech not available...',
//                 style: const TextStyle(fontSize: 20),
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 child: Text(
//                   _wordsSpoken,
//                   style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
//                 ),
//               ),
//             ),

//             if (_speechToText.isNotListening && _confidenceLevel > 0)
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 100),
//                 child: Text(
//                   'Confidence: ${(_confidenceLevel * 100).toStringAsFixed(1)}%',
//                   style: TextStyle(fontSize: 30, fontWeight: FontWeight.w200),
//                 ),
//               ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _speechToText.isListening ? _stopListening : _startListening,

//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//         child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextFeature extends StatefulWidget {
  const SpeechToTextFeature({super.key});

  @override
  State<SpeechToTextFeature> createState() => _SpeechToTextFeatureState();
}

class _SpeechToTextFeatureState extends State<SpeechToTextFeature> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _wordsSpoken = '';
  double _confidenceLevel = 0;
  bool _hasPermission = false;
  bool _showPermissionWarning = false;

  @override
  void initState() {
    super.initState();
    _checkInitialPermission();
  }

  Future<void> _checkInitialPermission() async {
    final status = await Permission.microphone.status;
    setState(() {
      _hasPermission = status.isGranted;
      _showPermissionWarning = status.isDenied || status.isPermanentlyDenied;
    });
    
    if (_hasPermission) {
      await initSpeech();
    }
  }

  Future<void> initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  Future<void> _requestPermission() async {
    final status = await Permission.microphone.request();
    
    setState(() {
      _hasPermission = status.isGranted;
      _showPermissionWarning = !status.isGranted;
    });

    if (status.isGranted) {
      await initSpeech();
    } else if (status.isPermanentlyDenied) {
      // Open settings only if permanently denied
      await openAppSettings();
    }
  }

  Future<void> _startListening() async {
    if (!_hasPermission) {
      // Request permission only when user initiates action
      await _requestPermission();
      if (!_hasPermission) return;
    }
    
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _confidenceLevel = 0;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = '${result.recognizedWords}';
      _confidenceLevel = result.confidence;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Speech to Text')),
      body: Center(
        child: Column(
          children: [
            // Permission warning banner - only show if permission was denied
            if (_showPermissionWarning)
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.amber[100],
                child: Column(
                  children: [
                    const Text(
                      'Microphone access required to use this feature',
                      style: TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _requestPermission,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Grant Permission'),
                    ),
                  ],
                ),
              ),
            
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                !_hasPermission
                  ? 'Microphone permission needed'
                  : _speechToText.isListening
                    ? 'Listening...'
                    : _speechEnabled
                      ? 'Tap microphone to start'
                      : 'Speech recognition unavailable',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _wordsSpoken,
                  style: const TextStyle(
                    fontSize: 25, 
                    fontWeight: FontWeight.w300
                  ),
                ),
              ),
            ),
            if (_speechToText.isNotListening && _confidenceLevel > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Text(
                  'Confidence: ${(_confidenceLevel * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 30, 
                    fontWeight: FontWeight.w200
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _speechToText.isListening ? _stopListening : _startListening,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: Icon(
          !_hasPermission 
            ? Icons.mic_off 
            : _speechToText.isNotListening 
                ? Icons.mic 
                : Icons.stop
        ),
      ),
    );
  }
}