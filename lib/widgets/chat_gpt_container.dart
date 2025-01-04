import 'dart:async';

import 'package:chat_gpt_flutter_quan/repositories/chat_gpt_repository.dart';
import 'package:chat_gpt_flutter_quan/service/message_chat_service.dart';
import 'package:chat_gpt_flutter_quan/utils/utils.dart';
import 'package:chat_gpt_flutter_quan/widgets/support_message_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ChatGptContainerWidget extends GetWidget<ChatGptContainerWidgetController> {
  final types.CustomMessage customMessage;
  final TextStyle textStyle = const TextStyle(
    color: Colors.black,
    fontSize: 18,
  );

  const ChatGptContainerWidget(
    this.customMessage, {
    super.key,
  });

  @override
  ChatGptContainerWidgetController get controller =>
      Get.put(ChatGptContainerWidgetController(customMessage), tag: customMessage.id.toString());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: SelectableText(
              '${controller.message}${controller.isDone.value ? '' : '▊'}',
              style: textStyle,
            ),
          ),
          if (controller.isDone.value) SupportMessageContainerWidget(controller),
        ],
      ),
    );
  }
}

class ChatGptContainerWidgetController extends GetxController {
  final types.CustomMessage customMessage;
  final RxString message = RxString('');
  final RxBool isDone = false.obs;
  final RxList<String> listKeywords = RxList<String>([]);
  final RxBool isSearching = false.obs;
  late StreamSubscription? streamSubscription;

  ChatGptContainerWidgetController(this.customMessage);

  Stream<GenerateContentResponse>? get stream =>
      customMessage.metadata?['stream'] as Stream<GenerateContentResponse>?;
  String get roomId => customMessage.metadata?['roomId'] as String;
  String get text => customMessage.metadata?['text'] as String;

  @override
  void onInit() {
    super.onInit();
    _initializeMessage();
  }

  @override
  void onClose() {
    streamSubscription?.cancel();
    super.onClose();
  }

  void _initializeMessage() {
    if (stream == null) {
      message.value = text;
      isDone.value = true;
      return;
    }

    streamSubscription = stream!.listen(
      _handleGenerateContentResponse,
      onError: (error) {
        Get.log('Stream error: $error');
      },
    );
  }

  void _handleGenerateContentResponse(GenerateContentResponse event) {
    Get.log("GenerateContentResponse ${event.text}");
    message.value += event.text ?? '';

    final isComplete = event.candidates.isNotEmpty && event.candidates[0].finishReason != null;
    if (isComplete) {
      _completeMessage();
    }
  }

  void _completeMessage() {
    MessageChatService.createMessage(
      roomId,
      customMessage
        ..metadata!['stream'] = null
        ..metadata!['text'] = message.value,
    );
    streamSubscription?.cancel();
    isDone.value = true;
  }

  void copyText() {
    AppFunctions.copyTextToClipboard(message.value);
    EasyLoading.showToast('Copied to clipboard');
  }

  Future<void> searchText() async {
    if (isSearching.value) return;

    try {
      isSearching.value = true;
      final prompt = '''Extract 5-10 key search terms from the following text. 
Return only the keywords, one per line, with no numbers or other text:
 
${message.value}''';
      Get.log(prompt);

      final result = await ChatGPTRepository.generateTextCompletion(prompt);
      if (result == null) {
        EasyLoading.showError('Please try again!');
        return;
      }

      _processKeywords(result);
      Get.log(listKeywords.join('\n'));
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.showError(e.toString());
    } finally {
      isSearching.value = false;
    }
  }

  void _processKeywords(String result) {
    listKeywords.value = result.split('\n').where((line) => line.trim().isNotEmpty).toList();
  }

  void searchKeyWord(String keyword) {
    launchUrlString(
      getGoogleKeyword(keyword),
      mode: LaunchMode.inAppBrowserView,
    );
  }

  String getGoogleKeyword(String keyword) => 'https://www.google.com/search?q=$keyword';
}
