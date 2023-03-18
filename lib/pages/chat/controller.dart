import 'package:chat_gpt_flutter_quan/service/chat_gpt_service.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'dart:math';

class ChatPageController extends GetxController {
  final isLoading = false.obs;
  final RxList<types.Message> messages = RxList<types.Message>([]);
  final user = const types.User(id: 'user');
  final chatGptUser = const types.User(id: 'chatGptUser');
  ChatPageController();

  void _requestResponse(String text) async {
    final imageId = _randomString(10);
    try {
      isLoading.toggle();

      final imageMessage = types.ImageMessage(
        author: chatGptUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: imageId,
        uri:
            'https://upload.wikimedia.org/wikipedia/commons/b/b1/Loading_icon.gif?20151024034921',
        height: 10,
        width: 10,
        size: 10,
      );

      messages.insert(0, imageMessage);

      var response = await ChatGPTApi.getResponse(text);

      final textMessage = types.TextMessage(
        author: chatGptUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: _randomString(10),
        text: response,
      );
      final index = messages.indexWhere((element) => element.id == imageId);
      messages.removeAt(index);
      messages.insert(0, textMessage);
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.toggle();
      messages.removeWhere((element) => element.id == imageId);
    }
  }

  void handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: _randomString(10),
      text: message.text,
    );

    messages.insert(0, textMessage);

    _requestResponse(message.text);
  }

  String _randomString(int length) {
    const String chars = "abcdefghijklmnopqrstuvwxyz0123456789";
    Random rng = Random();

    String result = "";
    for (int i = 0; i < length; i++) {
      result += chars[rng.nextInt(chars.length)];
    }

    return result;
  }
}
