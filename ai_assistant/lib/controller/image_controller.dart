import 'package:ai_assistant/helper/global.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

enum Status { none, loading, complete }

class ImageController extends GetxController {
  final textC = TextEditingController();

  final status = Status.none.obs;

  String url = '';

  Future<void> createAIImage() async {
    OpenAI.apiKey = apiKey;
    if (textC.text.trim().isNotEmpty) {
      status.value = Status.loading;

      OpenAIImageModel image = await OpenAI.instance.image.create(
        prompt: textC.text,
        n: 1,
        size: OpenAIImageSize.size512,
        responseFormat: OpenAIImageResponseFormat.url,
      );
      url = image.data[0].url.toString();
      textC.text = '';
      status.value = Status.complete;
    }
  }
}
