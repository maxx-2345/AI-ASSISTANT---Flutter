import 'dart:io';

import 'package:ai_assistant/helper/my_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class OcrFeature extends StatefulWidget {
  const OcrFeature({super.key});

  @override
  State<OcrFeature> createState() => _OcrFeatureState();
}

class _OcrFeatureState extends State<OcrFeature> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String copyText = '';

  // to pick image through camera
  Future<void> _getImageFromCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
      ); // Open camera and wait for image

      if (photo != null) {
        setState(() {
          _image = File(photo.path);
        });
      }
    } catch (e) {
      print("permission_error $e");
      if (e.toString().contains("camera_access_denied")) {
        _requestCameraPermission();
      }
    }
  }

  // Function to request camera permission
  Future<bool> _requestCameraPermission() async {
    PermissionStatus cameraStatus = await Permission.camera.status;

    print("permission_log:: $cameraStatus");
    if (cameraStatus.isDenied) {
      print("permission_log::1 $cameraStatus");

      // Request permission
      cameraStatus = await Permission.camera.request();
    } else {
      print("permission_log::2 $cameraStatus");
    }

    if (cameraStatus.isPermanentlyDenied) {
      // Show dialog to open app settings
      // _showSettingsDialog('Camera');
      openAppSettings();
      return false;
    }

    return cameraStatus.isGranted;
  }

  // Function to pick image from gallery
  Future<void> _getImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
        print("gallery path: $_image \n path: ${image.path}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Text Recognition')),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 15),
            // for showing Image
            _image != null
                ? Container(
                  width: 300,
                  height: 300,
                  child: Image.file(_image!, fit: BoxFit.contain),
                )
                : SizedBox(
                  child: Text(
                    'Select Media for Text Extraction',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
            const SizedBox(height: 10),
            // for showing extracted text
            Expanded(child: _extractedTextView()),
            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // camera button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _getImageFromCamera,
                  icon: const Icon(Icons.camera),
                  label: const Text('Take photo'),
                ),

                // gallery button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _getImageFromGallery,
                  icon: const Icon(Icons.photo),
                  label: const Text('Gallery'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    if (copyText!.isNotEmpty) {
                      Clipboard.setData(ClipboardData(text: copyText));
                      MyDialog.success('Successfully copied');
                    } else {
                      MyDialog.error('No text to copy');
                    }
                  },
                  child: const Text(
                    'copy text',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _extractedTextView() {
    if (_image == null) {
      return const Center(child: Text('No result'));
    }
    return FutureBuilder(
      future: _extractText(_image!),
      builder: (context, snapshot) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            snapshot.data ?? '',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.left,
          ),
        );
      },
    );
  }

  // Future<String?> _extractText(File file) async {
  //   final InputImage inputImage = InputImage.fromFile(file);

  //   // Try Latin script first
  //   final latinRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  //   final latinText = await latinRecognizer.processImage(inputImage);
  //   latinRecognizer.close();

  //   if (latinText.text.trim().isNotEmpty) {
  //     setState(() => copyText = latinText.text);
  //     return latinText.text;
  //   }

  // }

  Future<String> _extractText(File file) async {
    final inputImage = InputImage.fromFile(file);
    final List<TextRecognizer> recognizers = [
      TextRecognizer(script: TextRecognitionScript.latin),
      // TextRecognizer(script: TextRecognitionScript.devanagari),
      TextRecognizer(script: TextRecognitionScript.chinese),
      TextRecognizer(script: TextRecognitionScript.japanese),
      TextRecognizer(script: TextRecognitionScript.korean),
    ];

    String combinedText = '';

    for (final recognizer in recognizers) {
      final RecognizedText result = await recognizer.processImage(inputImage);
      if (result.text.trim().isNotEmpty) {
        combinedText += result.text.trim() + '\n';
      }
      await recognizer.close();
    }

    setState(() {
      copyText = combinedText;
    });

    return combinedText.trim();
  }
}
