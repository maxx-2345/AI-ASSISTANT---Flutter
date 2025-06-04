import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ai_assistant/helper/my_dialogs.dart';

class OcrController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  final Rx<File?> image = Rx<File?>(null);
  final RxString extractedText = ''.obs;

  Future<void> getImageFromCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 60,
      );

      if (photo != null) {
        final file = File(photo.path);
        image.value = file;
        await extractText(file);
      }
    } catch (e) {
      print('Camera error: $e');
      MyDialog.error('Failed to open camera');
    }
  }

  Future<void> getImageFromGallery() async {
    final XFile? imageFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 60,
    );

    if (imageFile != null) {
      final file = File(imageFile.path);
      image.value = file;
      await extractText(file);
    }
  }

  Future<void> extractText(File file) async {
    try {
      final inputImage = InputImage.fromFile(file);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText result = await textRecognizer.processImage(inputImage);
      await textRecognizer.close();

      final cleanedLines = result.text
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toSet();

      extractedText.value = cleanedLines.join('\n');
    } catch (e) {
      print('OCR error: $e');
      MyDialog.error('Text recognition failed.');
    }
  }

  void copyTextToClipboard() {
    if (extractedText.value.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: extractedText.value));
      MyDialog.success('Text copied to clipboard');
    } else {
      MyDialog.error('No text to copy');
    }
  }

  void clear() {
    image.value = null;
    extractedText.value = '';
  }
}
