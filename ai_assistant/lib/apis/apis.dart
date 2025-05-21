import 'dart:convert';
import 'dart:io';
import 'package:ai_assistant/helper/global.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class APIs {
  /// Chat with OpenRouter
  static Future<String> getAnswer(String question) async {
    try {
      final res = await http.post(
        Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          "model": "deepseek/deepseek-chat",
          "max_tokens": 2000,
          "temperature": 0,
          "messages": [
            {"role": "user", "content": question},
          ],
        }),
      );
      final data = jsonDecode(res.body);
      return data['choices'][0]['message']['content'];
    } catch (e) {
      print('Chat error: $e');
      return 'Error: Could not get response';
    }
  }

  /// Image Generation with Hugging Face SDXL
  static Future<String?> generateImage(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://api-inference.huggingface.co/models/stabilityai/stable-diffusion-xl-base-1.0',
        ),
        // In the generateImage() method
        headers: {
          'Authorization': 'Bearer $huggingFaceKey', // Use the global variable
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "inputs": prompt,
          "options": {
            "wait_for_model": true, // Critical for model readiness
            "use_cache": true,
          },
        }),
      );

      print('API Status: ${response.statusCode}');

      // Handle success
      if (response.statusCode == 200) {
        return base64Encode(response.bodyBytes);
      }
      // Handle rate limits
      else if (response.statusCode == 429) {
        print('Too many requests - waiting 10 seconds');
        await Future.delayed(const Duration(seconds: 10));
        return generateImage(prompt); // Retry
      }
      // Handle model loading
      else if (response.statusCode == 503) {
        print('Model loading - retrying in 15 seconds');
        await Future.delayed(const Duration(seconds: 15));
        return generateImage(prompt);
      }
      // Other errors
      else {
        print('API Error: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Image generation failed: $e');
      return null;
    }
  }
}
