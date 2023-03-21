import 'package:chat_gpt_flutter_quan/flavors.dart';
import 'package:chat_gpt_flutter_quan/models/chat_gpt_response.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatGPTApi {
  static const String apiUrl = "https://api.openai.com/v1/chat/completions";
  static String get token => F.apiTokenChatGPT;

  static Future<ChatGPTResponse> getResponse(List<Map<String, String>> messages) async {
    try {
      // return 'haha';
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json; charset=utf-8"
        },
        body: json.encode({
          "model": "gpt-3.5-turbo",
          // "messages": messages,
          // if more than 5 get 5 last messages
          "messages": messages.length > 5 ? messages.sublist(messages.length - 5) : messages,
          "max_tokens": 1000,
        }),
      );

      if (response.statusCode == 200) {
        final chatGPTResponse = processChatGPTResponse(response.body);
        Get.log(response.body);
        return chatGPTResponse;
      } else {
        throw Exception('Failed to load chatGPT response');
      }
    } catch (e) {
      rethrow;
    }
  }
}
