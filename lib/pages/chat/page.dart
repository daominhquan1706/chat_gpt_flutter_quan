import 'package:chat_gpt_flutter_quan/pages/chat/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';

class ChatPage extends GetView<ChatPageController> {
  @override
  ChatPageController get controller => Get.put(ChatPageController());

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Obx(
          () => Chat(
            messages: controller.messages.value,
            onSendPressed: controller.handleSendPressed,
            user: controller.user,
          ),
        ),
      );
}
