import 'package:chat_gpt_flutter_quan/service/chat_gpt_response.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatGPTApi {
  static const String apiUrl = "https://api.openai.com/v1/chat/completions";
  static const String token =
      "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"; // Thêm API Token của bạn vào đây

  static Future<String> getResponse(String query) async {
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: json.encode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "user", "content": query}
          ],
          "temperature": 0.7
        }),
      );

      if (response.statusCode == 200) {
        final chatGPTResponse = processChatGPTResponse(response.body);
        Get.log(chatGPTResponse.text);
        return chatGPTResponse.text;
      } else {
        throw Exception('Failed to load chatGPT response');
      }
    } catch (e) {
      rethrow;
    }
  }
}
