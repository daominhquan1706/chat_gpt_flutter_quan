import 'package:chat_gpt_flutter_quan/service/chat_gpt_service.dart';
import 'package:chat_gpt_flutter_quan/utils/string_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:scroll_to_index/scroll_to_index.dart';

enum ChatType {
  welcome,
  loading,
  normalMessage,
  errorMessage,
}

class ChatPageController extends GetxController {
  final isLoading = false.obs;
  final RxList<types.Message> messages = RxList<types.Message>([]);
  final user = const types.User(id: 'user');
  final chatGptUser = const types.User(id: 'chatGptUser');
  ChatPageController();
  AutoScrollController scrollController = AutoScrollController();
  List<Map<String, String>> contextMessages = [];

  static int totalTokens = 0;


  @override
  void onInit() {
    messages.insert(
        0,
        types.CustomMessage(
          author: chatGptUser,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: StringUtils.randomString(10),
          metadata: const {"type": ChatType.welcome},
        ));

    super.onInit();
  }

  void _requestResponse(String input) async {
    final imageId = StringUtils.randomString(10);
    try {
      isLoading.value = true;

      final imageMessage = types.CustomMessage(
          author: chatGptUser,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: imageId,
          metadata: const {
            'type': ChatType.loading,
          });

      messages.insert(0, imageMessage);

      var result = await ChatGPTApi.getResponse([
        ...contextMessages,
        {"role": "user", "content": input}
      ]);
      contextMessages.add({"role": "assistant", "content": result});

      final textMessage = types.CustomMessage(
        author: chatGptUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: StringUtils.randomString(10),
        metadata: {
          "text": result,
        },
      );
      final index = messages.indexWhere((element) => element.id == imageId);
      messages.removeAt(index);
      messages.insert(0, textMessage);
    } catch (e) {
      final textMessage = types.CustomMessage(
        author: chatGptUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: StringUtils.randomString(10),
        metadata: {
          "type": ChatType.errorMessage,
          "text": kDebugMode ? e.toString() : 'Something went wrong',
        },
      );

      final index = messages.indexWhere((element) => element.id == imageId);
      messages.removeAt(index);
      messages.insert(index, textMessage);
    } finally {
      isLoading.value = false;
      messages.removeWhere((element) => element.id == imageId);
    }
  }

  void handleSendPressed(types.PartialText message) {
    final textMessage = types.CustomMessage(
        author: user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: StringUtils.randomString(10),
        metadata: {
          "text": message.text,
        });

    messages.insert(0, textMessage);

    _requestResponse(message.text);
    scrollController.scrollToIndex(0);
  }

  
  
}
