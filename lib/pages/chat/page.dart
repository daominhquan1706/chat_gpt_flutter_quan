import 'package:chat_gpt_flutter_quan/models/ad_model.dart';
import 'package:chat_gpt_flutter_quan/pages/chat/controller.dart';
import 'package:chat_gpt_flutter_quan/pages/chat/widgets/chat_bubble_widget.dart';
import 'package:chat_gpt_flutter_quan/pages/chat/widgets/chat_type_welcome_widget.dart';
import 'package:chat_gpt_flutter_quan/utils/constants.dart';
import 'package:chat_gpt_flutter_quan/utils/functions.dart';
import 'package:chat_gpt_flutter_quan/widgets/ad_mod_widget.dart';
import 'package:chat_gpt_flutter_quan/widgets/bubble_chat_tool.dart';
import 'package:chat_gpt_flutter_quan/widgets/chat_gpt_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatPage extends GetView<ChatPageController> {
  const ChatPage({Key key}) : super(key: key);
  TextStyle get textStyle => AppConstant.textStyle;

  @override
  ChatPageController get controller => Get.put(ChatPageController(), tag: Get.parameters['roomId']);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff1D1C21),
          // leading: ClipRRect(
          //   borderRadius: BorderRadius.circular(8),
          //   child: Image.asset('assets/images/logo.jpg'),
          // ).paddingAll(6),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chatty GPT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              Row(
                children: [
                  Text(
                    'Online',
                    style: textStyle.copyWith(
                      color: Colors.green,
                      fontSize: 14,
                    ),
                  ),
                ],
              )
            ],
          ),
          actions: [
            // clear history button
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: controller.handleClearHistoryPressed,
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(child: _buildChat()),
          ],
        ),
        // bottomNavigationBar: AdvertiseWidget(
        //   ad: controller.bottomAd,
        // ),
      );

  Obx _buildChat() {
    return Obx(
      () => Chat(
        scrollController: controller.scrollController,
        messages: controller.messages.value,
        onSendPressed: controller.handleSendPressed,
        user: controller.user,
        bubbleBuilder: _bubbleBuilder,
        theme: DefaultChatTheme(
          backgroundColor: Colors.grey.shade200,
        ),
        customMessageBuilder: (p0, {messageWidth}) {
          final ChatType type = p0.metadata['type'];
          switch (type) {
            case ChatType.advertisement:
              return Obx(() {
                final AdModel advertisement = p0.metadata['advertisement'];
                if (advertisement.isReady.value) {
                  return AdvertiseWidget(
                    ad: advertisement,
                  );
                }
                return const SizedBox.shrink();
              });
            case ChatType.errorMessage:
              return SelectableText(
                p0.metadata['error'].toString(),
                style: textStyle.copyWith(color: Colors.red),
              ).paddingSymmetric(horizontal: 16, vertical: 14);
            case ChatType.loading:
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator().paddingAll(16),
                  const Text('Loading...').paddingAll(16),
                  ElevatedButton(
                    onPressed: () {
                      controller.handleCancelPressed(p0.id);
                    },
                    // change to red
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Stop'),
                  ).paddingAll(16),
                ],
              );
            case ChatType.welcome:
              return ChatTypeWelComeWidget(
                onTapOption: (text) {
                  controller.handleSendPressed(types.PartialText(text: text));
                },
              );
              break;
            default:
              break;
          }
          final isChatGPT = p0.author.id == controller.chatGptUser.id;
          if (isChatGPT) {
            return ChatGptContainerWidget(p0);
          }
          return Text(
            p0.metadata['text'].toString(),
            style: textStyle.copyWith(color: isChatGPT ? Colors.black : Colors.white),
          ).paddingSymmetric(horizontal: 16, vertical: 14);
        },
      ),
    );
  }

  Widget _bubbleBuilder(
    Widget child, {
    @required types.Message message,
    @required bool nextMessageInGroup,
  }) {
    return BubbleChatToolWidget(
      onCopyPressed: () {
        if (Get.isRegistered<ChatGptContainerWidgetController>(tag: message.id)) {
          final text = Get.find<ChatGptContainerWidgetController>(tag: message.id).message.value;
          AppFunctions.copyTextToClipboard(text);
        }
      },
      child: ChatBubbleWidget(
        message: message,
        nextMessageInGroup: nextMessageInGroup,
        child: child,
      ),
    );
  }
}
