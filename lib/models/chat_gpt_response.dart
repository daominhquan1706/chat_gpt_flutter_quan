import 'dart:convert';

class ChatGPTResponse {
  final String text;
  final Map<String, dynamic> entities;
  final int totalTokens;

  ChatGPTResponse({this.text, this.entities, this.totalTokens});

  factory ChatGPTResponse.fromJson(Map<String, dynamic> json) {
    String text;
    if ((json['choices'][0]['delta'] as Map<String, dynamic>).containsKey('content')) {
      text = json['choices'][0]['delta']['content'].toString();
    }

    return ChatGPTResponse(
      text: text,
      entities: extractEntities(json),
      // totalTokens: json['usage']['total_tokens'] as int,
    );
  }

  static Map<String, dynamic> extractEntities(Map<String, dynamic> json) {
    Map<String, dynamic> entities = {};
    Iterable<dynamic> extractedEntities = json['choices'][0]['entities'];

    if (extractedEntities != null) {
      for (var entity in extractedEntities) {
        var name = entity['name'];
        var value = entity['value'][entity['start'] + entity['end']];

        if (!entities.containsKey(name)) {
          entities[name] = <String>[];
        }
        entities[name].add(value.toString());
      }
    }
    return entities;
  }

  @override
  String toString() {
    return 'ChatGPTResponse{text: $text, entities: $entities}';
  }
}

ChatGPTResponse processChatGPTResponse(String responseBody) {
  var parsedJson = jsonDecode(responseBody);
  return ChatGPTResponse.fromJson(parsedJson);
}
