import 'dart:async';

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
      () => buildMarkdown().paddingSymmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget buildMarkdown() => Column(
          children: MarkdownGenerator(
        config: MarkdownConfig(configs: []),
      ).buildWidgets('${controller.message.value}${controller.isDone.value ? '' : '█ '}'));
}

class ChatGptContainerWidgetController extends GetxController {
  final RxString message = RxString("");

  final types.CustomMessage customMessage;

  ChatGptContainerWidgetController(this.customMessage);
  final RxBool isDone = false.obs;

  @override
  void onInit() {
    StreamSubscription streamSubscription;

    streamSubscription = (customMessage.metadata['stream'] as Stream<String>).listen((event) {
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
          streamSubscription.cancel();
          isDone.value = true;
        }
      }
    }, onError: (error) {});
    super.onInit();
  }
}
