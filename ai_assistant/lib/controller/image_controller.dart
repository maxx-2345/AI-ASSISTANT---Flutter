// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:ai_assistant/apis/apis.dart';
// import 'package:ai_assistant/helper/global.dart';
// import 'package:ai_assistant/helper/my_dialogs.dart';
// import 'package:flutter/material.dart';
// import 'package:gallery_saver_plus/gallery_saver.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart' as share;

// enum Status { none, loading, complete }

// class ImageController extends GetxController {
//   final textC = TextEditingController();
//   final status = Status.none.obs;
//   String url = '';

//   Future<void> createAIImage() async {
//     if (textC.text.trim().isNotEmpty) {
//       status.value = Status.loading;
//       final generatedUrl = await APIs.generateImage(textC.text);
//       if (generatedUrl != null) {
//         url = generatedUrl;
//         textC.text = '';
//         status.value = Status.complete;
//       } else {
//         status.value = Status.none;
//       }
//     } else {
//       MyDialog.info('Please enter a description for image generation!');
//     }
//   }

//   //Download Image to Gallery
//   void downloadImage() async {
//     try {
//       MyDialog.showLoadingDialog();
//       print('URL: $url');

//       Uint8List bytes;

//       if (url.startsWith('data:image')) {
//         // Handle Base64 image with data URI prefix
//         final base64Str = url.split(',')[1];
//         bytes = base64Decode(base64Str);
//       } else if (!url.startsWith('http')) {
//         // Raw Base64 image
//         bytes = base64Decode(url);
//       } else {
//         // Network image
//         bytes = (await get(Uri.parse(url))).bodyBytes;
//       }

//       final dir = await getTemporaryDirectory();
//       final file = await File('${dir.path}/ai_image.png').writeAsBytes(bytes);
//       print('Filepath: ${file.path}');

//       await GallerySaver.saveImage(file.path, albumName: appName).then((
//         success,
//       ) {
//         Get.back();
//         MyDialog.success('Image downloaded to Gallery!');
//       });
//     } catch (e) {
//       // to hide loading
//       Get.back();
//       MyDialog.error('Something went wrong please try again after sometime!');
//       print('ImageDownloadE: $e');
//       MyDialog.error('Failed to download image: $e');
//     }
//   }
// }






import 'dart:io';
import 'dart:typed_data';
import 'package:ai_assistant/apis/apis.dart';
import 'package:ai_assistant/helper/global.dart';
import 'package:ai_assistant/helper/my_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

enum Status { none, loading, complete }

class ImageController extends GetxController {
  final textC = TextEditingController();
  final status = Status.none.obs;
  Uint8List? imageBytes; // Changed from String url

  Future<void> createAIImage() async {
    if (textC.text.trim().isEmpty) {
      MyDialog.info('Please enter image description!');
      return;
    }

    status.value = Status.loading;
    try {
      final bytes = await APIs.generateImage(textC.text);
      if (bytes != null) {
        imageBytes = bytes;
        textC.clear();
        status.value = Status.complete;
      } else {
        status.value = Status.none;
        MyDialog.error('Failed to generate image');
      }
    } catch (e) {
      status.value = Status.none;
      MyDialog.error('Image generation error: ${e.toString()}');
    }
  }

  void downloadImage() async {
    if (imageBytes == null) return;

    try {
      MyDialog.showLoadingDialog();
      
      // Save to temporary file
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/ai_image.png');
      await file.writeAsBytes(imageBytes!);

      // Save to gallery
      final success = await GallerySaver.saveImage(file.path, 
        albumName: appName
      );

      Get.back();
      if (success == true) {
        MyDialog.success('Image saved to gallery!');
      } else {
        MyDialog.error('Failed to save image');
      }
    } catch (e) {
      Get.back();
      MyDialog.error('Save failed: ${e.toString()}');
    }
  }
}