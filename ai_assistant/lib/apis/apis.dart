import 'dart:convert';
import 'dart:io';

import 'package:ai_assistant/helper/global.dart';
import 'package:http/http.dart';

class APIs {
  /// to get answer from chat gpt
  static Future<String> getAnswer(String question) async {
    try {
      final res = await post(
        Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $apiKey',
        },
        body: jsonEncode({
          "model": "deepseek/deepseek-chat",
          "max-tokens": 2000,
          "temperature": 0,
          "messages": [
            {"role": "user", "content": question},
          ],
        }),
      );
      final data = jsonDecode(res.body);
      print('res: $data');
      return data['choices'][0]['message']['content'];
    } catch (e) {
      print('getAnswerE: $e');
      return 'Something went wrong(Try again in sometime)';
    }
  }
}
