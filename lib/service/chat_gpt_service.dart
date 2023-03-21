import 'package:chat_gpt_flutter_quan/flavors.dart';
import 'package:chat_gpt_flutter_quan/models/chat_gpt_response.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatGPTApi {
  static const String apiUrl = "https://api.openai.com/v1/chat/completions";
  static String get token => F.apiTokenChatGPT;
  static http.Client client = http.Client();

  static Future<ChatGPTResponse> getResponse(List<Map<String, String>> messages) async {
    try {
      var response = await client.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json; charset=utf-8"
        },
        body: json.encode({
          "model": "gpt-3.5-turbo",
          "messages": messages.length > 3 ? messages.sublist(messages.length - 3) : messages,
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
    } on http.ClientException {
      return null;
    } catch (e) {
      Get.log(e.toString());
      throw Exception('Failed to load chatGPT response');
    }
  }

  static stopRequest() {
    client.close();
    client = http.Client();
  }
}
