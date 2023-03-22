import 'dart:async';

import 'package:chat_gpt_flutter_quan/flavors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatGPTApi {
  static const String apiUrl = "https://api.openai.com/v1/chat/completions";
  static String get token => F.apiTokenChatGPT;
  static http.Client client = http.Client();

  // make stream request call to chatgpt api
  static Future<http.StreamedResponse> makeRequest(List<Map<String, String>> messages) async {
    var request = http.Request('POST', Uri.parse(apiUrl));
    request.headers.addAll(
      {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json; charset=utf-8",
      },
    );
    request.body = json.encode({
      "model": "gpt-3.5-turbo",
      "messages": messages.length > 3 ? messages.sublist(messages.length - 3) : messages,
      // "max_tokens": 1000,
      "stream": true,
    });

    // Use StreamedRequest instead of Response
    var streamedResponse = await request.send();
    if (streamedResponse.statusCode == 200) {
      return streamedResponse;
    } else {
      throw Exception('Failed to load chatGPT response');
    }
  }

  static stopRequest() {
    client.close();
    client = http.Client();
  }
}
