import 'package:chat_gpt_flutter_quan/pages/chat/controller.dart';
import 'package:chat_gpt_flutter_quan/widgets/ad_mod_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatPage extends GetView<ChatPageController> {
  const ChatPage({Key key}) : super(key: key);
  TextStyle get textStyle => const TextStyle(
        color: Colors.black,
        fontSize: 18,
      );

  @override
  ChatPageController get controller => Get.put(ChatPageController());

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            Expanded(child: _buildChat()),
          ],
        ),
        bottomNavigationBar: const AdModWiget(),
      );

  Obx _buildChat() {
    return Obx(
      () => Chat(
        scrollController: controller.scrollController,
        messages: controller.messages.value,
        onSendPressed: controller.handleSendPressed,
        user: controller.user,
        customMessageBuilder: (p0, {messageWidth}) {
          final ChatType type = p0.metadata['type'];
          switch (type) {
            case ChatType.errorMessage:
              return SelectableText(
                p0.metadata['error'].toString(),
                style: textStyle.copyWith(color: Colors.red),
              ).paddingSymmetric(horizontal: 16, vertical: 14);
            case ChatType.loading:
              return const CircularProgressIndicator().paddingAll(16);
            case ChatType.welcome:
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    '''Sure, I'll be happy to assist you. As an AI chatbot powered by OpenAI, my primary objective is to help and answer all your queries related to coding in Flutter using the getX library without null-safety. Here are 5 recommended topics for us to discuss:
''',
                    style: textStyle.copyWith(color: Colors.black),
                  ),
                  ...[
                    'Tell me a Chuck Norris joke',
                    'Write me an email to apply for a job',
                    'Write an essay about climate change',
                    'Explain AI in three sentences',
                    'Tell me a joke',
                  ].map((e) => _buildChatOptiton(e)).toList(),
                  SelectableText(
                    '''
Please feel free to ask me anything. How can I assist you today?''',
                    style: textStyle.copyWith(color: Colors.black),
                  ),
                ],
              ).paddingSymmetric(horizontal: 16, vertical: 14);
              break;
            default:
              break;
          }
          final isChatGPT = p0.author.id == controller.chatGptUser.id;
          return SelectableText(
            p0.metadata['text'].toString(),
            style: textStyle.copyWith(
                color: isChatGPT ? Colors.black : Colors.white),
          ).paddingSymmetric(horizontal: 16, vertical: 14);
        },
      ),
    );
  }

  Widget _buildChatOptiton(String text) {
    return InkWell(
      onTap: () {
        controller.handleSendPressed(types.PartialText(text: text));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(8.0)),
        child: Text(
          text,
          style: textStyle.copyWith(color: Colors.white),
        ).paddingSymmetric(horizontal: 16, vertical: 14),
      ).paddingOnly(bottom: 8),
    );
  }
}
