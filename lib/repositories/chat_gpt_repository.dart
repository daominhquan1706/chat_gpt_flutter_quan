import 'dart:async';
import 'dart:convert';

import 'package:chat_gpt_flutter_quan/flavors.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;

class ChatGPTRepository {
  static const String apiChatUrl = 'https://api.openai.com/v1/chat/completions';
  static const String apiTextCompelteUrl = 'https://api.openai.com/v1/completions';
  static String? get token => F.apiTokenChatGPT;
  static Dio dio = Dio();
  static GenerativeModel? _model;
  static GenerativeModel get model {
    _model ??= GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: F.apiTokenGemini!,
    );
    return _model!;
  }

  static int maxContextMessage = 5;

  // make stream request call to chatgpt api
  static Future<Stream<GenerateContentResponse>?> generateChat(
    List<Map<String, String>> messages, {
    required String idLoading,
  }) async {
    final contextCount =
        messages.length > maxContextMessage ? messages.length - maxContextMessage : 0;
    final contextMessages = messages.sublist(contextCount);

    // Convert messages to Content format for Gemini
    final content = contextMessages.map((msg) => Content.text(msg['content'] ?? '')).toList();

    try {
      final Stream<GenerateContentResponse> contentStream = model.generateContentStream(content);

      // Convert the response stream to String stream
      return contentStream;
    } catch (e) {
      Get.log('Error generating chat: $e');
      return null;
    }
  }

  // make stream request call to chatgpt api
  static Future<String?> generateTextCompletion(
    String prompt,
  ) async {
    try {
      final content = Content.text(prompt);
      final response = await model.generateContent([content]);
      final text = response.text;

      if (text != null) {
        Get.log(text);
        return text;
      } else {
        return '';
      }
    } catch (e) {
      Get.log('Error generating text completion: $e');
      return '';
    }
  }

  static String correctUtf8(String input) {
    List<int> bytes = latin1.encode(input);
    String result = utf8.decode(bytes);
    return result;
  }
}
