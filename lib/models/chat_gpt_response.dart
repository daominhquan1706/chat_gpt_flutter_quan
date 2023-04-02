import 'dart:convert';

class ChatGPTResponse {
  final String text;

  ChatGPTResponse({
    required this.text,
  });

  factory ChatGPTResponse.fromJson(Map<String, dynamic> json) {
    String text = '';
    if ((json['choices'][0]['delta'] as Map<String, dynamic>).containsKey('content')) {
      text = json['choices'][0]['delta']['content'].toString();
    }

    return ChatGPTResponse(
      text: text,
      // entities: extractEntities(json), totalTokens: 0,
      // totalTokens: json['usage']['total_tokens'] as int,
    );
  }

  @override
  String toString() {
    return 'ChatGPTResponse{text: $text}';
  }
}

ChatGPTResponse processChatGPTResponse(String responseBody) {
  var parsedJson = jsonDecode(responseBody);
  return ChatGPTResponse.fromJson(parsedJson);
}
