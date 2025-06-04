import 'dart:io';

import 'package:ai_assistant/controller/ocr_controller.dart';
import 'package:ai_assistant/helper/my_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class OcrFeature extends StatefulWidget {
  const OcrFeature({super.key});

  @override
  State<OcrFeature> createState() => _OcrFeatureState();
}

class _OcrFeatureState extends State<OcrFeature> {
  final OcrController controller = Get.put(OcrController());

  // Request camera permission
  Future<bool> _requestCameraPermission() async {
    PermissionStatus cameraStatus = await Permission.camera.status;

    if (cameraStatus.isDenied) {
      cameraStatus = await Permission.camera.request();
    }

    if (cameraStatus.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }

    return cameraStatus.isGranted;
  }

  @override
  void dispose() {
    // Clear memory-heavy resources on dispose
    controller.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Text Recognition')),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 15),

            // Display image preview
            Obx(() {
              final image = controller.image.value;
              return image != null
                  ? Container(
                    width: 300,
                    height: 300,
                    child: Image.file(image, fit: BoxFit.contain),
                  )
                  : const SizedBox(
                    child: Text(
                      'Select Media for Text Extraction',
                      style: TextStyle(fontSize: 20),
                    ),
                  );
            }),

            const SizedBox(height: 10),

            // Display extracted text
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Obx(
                  () => Text(
                    controller.extractedText.value.isNotEmpty
                        ? controller.extractedText.value
                        : 'No result',
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    final granted = await _requestCameraPermission();
                    if (granted) {
                      controller.clear(); // Important: Clear previous data
                      await controller.getImageFromCamera();
                    }
                  },
                  icon: const Icon(Icons.camera),
                  label: const Text('Take photo'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    controller.clear(); // Important: Clear previous data
                    await controller.getImageFromGallery();
                  },
                  icon: const Icon(Icons.photo),
                  label: const Text('Gallery'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    if (controller.extractedText.value.isNotEmpty) {
                      controller.copyTextToClipboard();
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
}
