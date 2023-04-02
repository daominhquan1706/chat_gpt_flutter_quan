import 'dart:async';

import 'package:chat_gpt_flutter_quan/repositories/chat_gpt_repository.dart';
import 'package:chat_gpt_flutter_quan/service/message_chat_service.dart';
import 'package:chat_gpt_flutter_quan/utils/utils.dart';
import 'package:chat_gpt_flutter_quan/widgets/support_message_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'package:chat_gpt_flutter_quan/models/chat_gpt_response.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:markdown_widget/markdown_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ChatGptContainerWidget extends GetWidget<ChatGptContainerWidgetController> {
  @override
  ChatGptContainerWidgetController get controller =>
      Get.put(ChatGptContainerWidgetController(customMessage), tag: customMessage.id.toString());

  final types.CustomMessage customMessage;
  TextStyle get textStyle => const TextStyle(
        color: Colors.black,
        fontSize: 18,
      );

  const ChatGptContainerWidget(
    this.customMessage, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            controller.message.value + (controller.isDone.value ? '' : '▊'),
            style: textStyle,
          ).paddingSymmetric(horizontal: 16, vertical: 14),
          if (controller.isDone.value) SupportMessageContainerWidget(controller),
        ],
      ),
      // () => buildMarkdown(controller.message.value).paddingSymmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget buildMarkdown(String data) => Column(children: MarkdownGenerator().buildWidgets(data));
}

class ChatGptContainerWidgetController extends GetxController {
  final RxString message = RxString('');

  final types.CustomMessage customMessage;

  ChatGptContainerWidgetController(this.customMessage);
  final RxBool isDone = false.obs;
  Stream<String>? get stream => customMessage.metadata!['stream'] as Stream<String>?;
  String get roomId => customMessage.metadata!['roomId'] as String;
  String get text => customMessage.metadata!['text'] as String;
  late StreamSubscription streamSubscription;
  RxList<String> listKeywords = RxList<String>([]);

  @override
  void onInit() {
    if (stream == null) {
      message.value = text;
      isDone.value = true;
      return;
    }
    streamSubscription = stream!.listen((event) {
      Get.log(event);
      final splitEvents = event.split('data: ');
      for (final splitEvent in splitEvents) {
        if (splitEvent.contains('{') && splitEvent.contains('}')) {
          final jsonString =
              splitEvent.substring(splitEvent.indexOf('{'), splitEvent.lastIndexOf('}') + 1);
          final chatGPTResponse = processChatGPTResponse(jsonString);
          if (chatGPTResponse.text.isNotEmpty == true) {
            message.value += chatGPTResponse.text;
          }
        }
        if (event.contains('[DONE]') == true) {
          if (isDone.value == false) {
            MessageChatService.createMessage(
                roomId,
                customMessage
                  ..metadata!['stream'] = null
                  ..metadata!['text'] = message.value);
            streamSubscription.cancel();
            isDone.value = true;
          }
        }
      }
    }, onError: (error) {});
    super.onInit();
  }

  void copyText() {
    AppFunctions.copyTextToClipboard(message.value);

    EasyLoading.showToast('Copied to clipboard');
  }

  Future<void> searchText() async {
    try {
      EasyLoading.show();
      final promt = 'generate 7 keywords relate to "${message.value}":';
      Get.log(promt);
      final result = await ChatGPTRepository.generateTextCompletion(promt);
      if (result == null) {
        EasyLoading.showError('please try again!');
        return;
      }
      List<String> keywords = result.split('\n')..removeWhere((element) => element.isEmpty);

      listKeywords.value = keywords.map((e) {
        final split = e.split(' ')..removeAt(0);
        return split.join(' ');
      }).toList()
        ..removeWhere((element) => element.isEmpty);
      Get.log(listKeywords.join(','));
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  void searchKeyWord(String keyword) {
    launchUrlString('https://www.google.com/search?q=$keyword');
  }
}
