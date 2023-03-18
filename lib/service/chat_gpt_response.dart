import 'dart:convert';

class ChatGPTResponse {
  final String text;
  final Map<String, dynamic> entities;

  ChatGPTResponse({this.text, this.entities});

  factory ChatGPTResponse.fromJson(Map<String, dynamic> json) {
    return ChatGPTResponse(
      text: json['choices'][0]['message']['content'].toString().trim(),
      entities: extractEntities(json),
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
