import 'package:ai_assistant/helper/my_dialogs.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  bool _hasMicPermission = false;
  bool _showPermissionWarning = false;

  @override
  void initState() {
    super.initState();
    _checkInitialPermission();
  }

  Future<void> _checkInitialPermission() async {
    final status = await Permission.microphone.status;
    print('Microphone permission status: $_hasMicPermission');

    setState(() {
      _hasMicPermission = status.isGranted;
      _showPermissionWarning = status.isDenied || status.isPermanentlyDenied;
    });
    if (status.isGranted) {
      _initializeSpeech();
    }
  }

  Future<void> _requestPermission() async {
    final status = await Permission.microphone.request();
    print('Microphone permission status: $_hasMicPermission');

    if (status.isGranted) {
      setState(() {
        _hasMicPermission = true;
        _showPermissionWarning = false;
      });
      _initializeSpeech();
      _startListening(); // Automatically start listening after permission
    } else if (status.isPermanentlyDenied) {
      openAppSettings(); // Opens system app settings
    } else {
      setState(() {
        _showPermissionWarning = true;
      });
    }
  }

  Future<void> _initializeSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onStatus: (status) => print('Speech status: $status'),
      onError: (error) => print('Speech error: $error'),
    );
    print('Speech initialized: $_speechEnabled');
    setState(() {});
  }

  void _startListening() async {
    if (!_hasMicPermission) {
      await _requestPermission();
      return;
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
      _wordsSpoken = result.recognizedWords;
      _confidenceLevel = result.confidence;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Speech to Text')),
      body: Column(
        children: [
          if (_showPermissionWarning)
            Container(
              color: Colors.redAccent,
              padding: const EdgeInsets.all(12),
              child: const Text(
                'Microphone permission is required to use speech recognition.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              _speechToText.isListening
                  ? 'Listening...'
                  : _speechEnabled
                  ? 'Tap the button & start Speaking!'
                  : 'Speech not available...',
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              _wordsSpoken,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
            ),
          ),
          if (_speechToText.isNotListening && _confidenceLevel > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Text(
                'Confidence: ${(_confidenceLevel * 100).toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                if (_wordsSpoken.trim().isNotEmpty) {
                  Clipboard.setData(ClipboardData(text: _wordsSpoken));
                  MyDialog.success('Successfully copied');
                } else {
                  MyDialog.error('Nothing to copy here');
                }
              },
              child: const Text(
                'copy text',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _speechToText.isListening,
        glowColor: Colors.blue,
        duration: const Duration(milliseconds: 1000),
        repeat: true,
        child: GestureDetector(
          onTapDown: (_) {
            _startListening();
          },
          onTapUp: (_) {
            _stopListening();
          },
          onTapCancel: () {
            _stopListening();
          },
          child: FloatingActionButton(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            onPressed: () {},
            child: Icon(
              _speechToText.isNotListening ? Icons.mic_none : Icons.mic,
            ),
          ),
        ),
      ),
    );
  }
}
