import 'dart:async';

import 'package:chat_gpt_flutter_quan/service/message_chat_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:chat_gpt_flutter_quan/models/chat_gpt_response.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:markdown_widget/markdown_widget.dart';

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
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SelectableText(
        controller.message.value,
        style: textStyle,
      ).paddingSymmetric(horizontal: 16, vertical: 14),
      // () => buildMarkdown(controller.message.value).paddingSymmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget buildMarkdown(String data) => Column(children: MarkdownGenerator().buildWidgets(data));
}

class ChatGptContainerWidgetController extends GetxController {
  final RxString message = RxString("");

  final types.CustomMessage customMessage;

  ChatGptContainerWidgetController(this.customMessage);
  final RxBool isDone = false.obs;
  Stream<String> get stream => customMessage.metadata['stream'] as Stream<String>;
  String get roomId => customMessage.metadata['roomId'] as String;
  String get text => customMessage.metadata['text'] as String;
  StreamSubscription streamSubscription;
  @override
  void onInit() {
    if (stream == null) {
      message.value = text;
      return;
    }
    streamSubscription = stream.listen((event) {
      Get.log(event);
      final splitEvents = event.split('data: ');
      for (final splitEvent in splitEvents) {
        if (splitEvent.contains('{') && splitEvent.contains('}')) {
          final jsonString =
              splitEvent.substring(splitEvent.indexOf('{'), splitEvent.lastIndexOf('}') + 1);
          if (jsonString != null) {
            final chatGPTResponse = processChatGPTResponse(jsonString);
            if (chatGPTResponse?.text?.isNotEmpty == true) {
              message.value += chatGPTResponse.text;
            }
          }
        }
        if (event.contains('[DONE]') == true) {
          if (isDone.value == false) {
            MessageChatService.createMessage(
                roomId,
                customMessage
                  ..metadata['stream'] = null
                  ..metadata['text'] = message.value);
            streamSubscription.cancel();
            isDone.value = true;
          }
        }
      }
    }, onError: (error) {});
    super.onInit();
  }
}
