import 'dart:async';
import 'dart:convert';

import 'package:chat_gpt_flutter_quan/flavors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class ChatGPTRepository {
  static const String apiUrl = "https://api.openai.com/v1/chat/completions";
  static String get token => F.apiTokenChatGPT;
  static http.Client client = http.Client();
  static Dio dio = Dio();

  // make stream request call to chatgpt api
  static Future<Stream<String>> makeRequest(List<Map<String, String>> messages) async {
    var rs = await Dio().post<ResponseBody>(
      apiUrl,
      options: Options(headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json; charset=utf-8",
      }, responseType: ResponseType.stream), // set responseType to `stream`
      data: {
        "model": "gpt-3.5-turbo",
        "messages": messages.length > 3 ? messages.sublist(messages.length - 3) : messages,
        // "max_tokens": 1000,
        "stream": true,
      },
    );
    StreamTransformer<Uint8List, List<int>> unit8Transformer = StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        sink.add(List<int>.from(data));
      },
    );

    SSEClient.subscribeToSSE(url: apiUrl, header: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json; charset=utf-8",
    }).listen((event) {});

    return rs.data.stream
        .transform(unit8Transformer)
        .transform(const Utf8Decoder())
        .transform(const LineSplitter())
        .asBroadcastStream();
  }

  static stopRequest() {
    client.close();
    client = http.Client();
  }
}
