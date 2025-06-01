import 'dart:convert';
import 'dart:typed_data';
import 'package:ai_assistant/helper/global.dart';
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

  /// Image Generation with DeepAI Text-to-Image
   static Future<Uint8List?> generateImage(String prompt) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.vyro.ai/v2/image/generations'),
      );

      // Add headers
      request.headers['Authorization'] = 'Bearer $openArtKey';

      // Add form fields
      request.fields.addAll({
        'prompt': prompt,
        'style': 'imagine-turbo',
        'aspect_ratio': '1:1',
        'seed': '5',
      });

      final response = await request.send();
      final bytes = await response.stream.toBytes();

      print('API response: ${response.statusCode}');

      if (response.statusCode == 200) {
        return bytes; // Return raw image bytes
      } 
      else if (response.statusCode == 429 || response.statusCode == 503) {
        print('Retrying...');
        await Future.delayed(Duration(
          seconds: response.statusCode == 429 ? 10 : 15
        ));
        return generateImage(prompt);
      } 
      else {
        print('API Error: ${utf8.decode(bytes)}');
        return null;
      }
    } catch (e) {
      print('Image generation failed: $e');
      return null;
    }
  }
}





//  import 'dart:convert';
// import 'dart:typed_data';
// import 'package:ai_assistant/helper/global.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;

// class APIs {
//   // ... keep existing chat code ...

//   /// Image Generation - Fixed Version
//   static Future<Uint8List?> generateImage(String prompt) async {
//     try {
//       final request = http.MultipartRequest(
//         'POST',
//         Uri.parse('https://api.vyro.ai/v2/image/generations'),
//       );

//       // Add headers
//       request.headers['Authorization'] = 'Bearer $openArtKey';

//       // Add form fields
//       request.fields.addAll({
//         'prompt': prompt,
//         'style': 'imagine-turbo',
//         'aspect_ratio': '1:1',
//         'seed': '5',
//       });

//       final response = await request.send();
//       final bytes = await response.stream.toBytes();

//       print('API response: ${response.statusCode}');

//       if (response.statusCode == 200) {
//         return bytes; // Return raw image bytes
//       } 
//       else if (response.statusCode == 429 || response.statusCode == 503) {
//         print('Retrying...');
//         await Future.delayed(Duration(
//           seconds: response.statusCode == 429 ? 10 : 15
//         ));
//         return generateImage(prompt);
//       } 
//       else {
//         print('API Error: ${utf8.decode(bytes)}');
//         return null;
//       }
//     } catch (e) {
//       print('Image generation failed: $e');
//       return null;
//     }
//   }
// }












// static Future<String?> generateImage(String prompt) async {
//     try {
//       // Create a multipart request
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse('https://api.vyro.ai/v2/image/generations'),
//       );

//       // Add headers
//       request.headers['Authorization'] = 'Bearer $openArtKey';

//       // Add form fields
//       request.fields.addAll({
//         'prompt': prompt,
//         'style': 'imagine-turbo',
//         'aspect_ratio': '1:1',
//         'seed': '5',
//       });

//       // If you need to upload a file, use:
//       // request.files.add(await http.MultipartFile.fromPath('file', filePath));

//       // Send the request
//       final response = await request.send();

//       // Get response data
//       final responseBody = await response.stream.bytesToString();
//       print('API response: ${response.statusCode}');

//       // Handle status codes
//       if (response.statusCode == 200) {
//         return base64Encode(await response.stream.toBytes());
//       } else if (response.statusCode == 429) {
//         print('Too many requests - waiting 10 seconds');
//         await Future.delayed(const Duration(seconds: 10));
//         return generateImage(prompt);
//       } else if (response.statusCode == 503) {
//         print('Model loading - retrying in 15 seconds');
//         await Future.delayed(const Duration(seconds: 15));
//         return generateImage(prompt);
//       } else {
//         print('API Error: $responseBody');
//         return null;
//       }
//     } catch (e) {
//       print('Image generation failed: $e');
//       return null;
//     }
//   }