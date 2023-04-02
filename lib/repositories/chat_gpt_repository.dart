import 'dart:async';
import 'dart:convert';

import 'package:chat_gpt_flutter_quan/flavors.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChatGPTRepository {
  static const String apiChatUrl = 'https://api.openai.com/v1/chat/completions';
  static const String apiTextCompelteUrl = 'https://api.openai.com/v1/completions';
  static String? get token => F.apiTokenChatGPT;
  static Dio dio = Dio();

  // make stream request call to chatgpt api
  static Future<Stream<String>?> generateChat(
    List<Map<String, String>> messages, {
    required String idLoading,
  }) async {
    final contextMessages = messages.length > 5 ? messages.sublist(messages.length - 5) : messages;
    var rs = await Dio().post<ResponseBody>(
      apiChatUrl,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=utf-8',
        },
        responseType: ResponseType.stream,
      ),
      data: {
        'model': 'gpt-3.5-turbo',
        'messages': contextMessages,
        // "max_tokens": 1000,
        'stream': true,
      },
      cancelToken: Get.put<CancelToken>(CancelToken(), tag: idLoading),
    );
    StreamTransformer<Uint8List, List<int>> unit8Transformer = StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        sink.add(List<int>.from(data));
      },
    );

    return rs.data?.stream
        .transform(unit8Transformer)
        .transform(const Utf8Decoder())
        .transform(const LineSplitter())
        .asBroadcastStream();
  }

  // make stream request call to chatgpt api
  static Future<String?> generateTextCompletion(
    String prompt,
  ) async {
    http.Response response = await http.post(
      Uri.parse(apiTextCompelteUrl),
      body: jsonEncode({
        'model': 'text-davinci-003',
        'prompt': prompt,
        'max_tokens': 1000,
      }),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      Get.log(response.body);
      return jsonDecode(response.body)['choices'][0]['text'];
    } else {
      return '';
    }
  }
}
