import 'package:chat_gpt_flutter_quan/service/chat_gpt_response.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatGPTApi {
  static const String apiUrl = "https://api.openai.com/v1/chat/completions";
  static String token = dotenv.env['API_TOKEN_CHATGPT'];

  static Future<String> getResponse(List<Map<String, String>> messages) async {
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json; charset=utf-8"
        },
        body: json.encode({
          "model": "gpt-3.5-turbo",
          "messages": messages,
          "max_tokens": 100,
        }),
      );

      if (response.statusCode == 200) {
        final chatGPTResponse = processChatGPTResponse(response.body);
        Get.log(response.body);
        String decodedString = chatGPTResponse.text;

        String encodedString = utf8.decode(decodedString.runes.toList());
        return encodedString;
      } else {
        throw Exception('Failed to load chatGPT response');
      }
    } catch (e) {
      rethrow;
    }
  }
}
