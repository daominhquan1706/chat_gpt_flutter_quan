import 'package:chat_gpt_flutter_quan/models/ad_model.dart';
import 'package:chat_gpt_flutter_quan/pages/chat/controller.dart';
import 'package:chat_gpt_flutter_quan/pages/chat/widgets/chat_type_welcome_widget.dart';
import 'package:chat_gpt_flutter_quan/utils/constants.dart';
import 'package:chat_gpt_flutter_quan/widgets/ad_mod_widget.dart';
import 'package:chat_gpt_flutter_quan/widgets/chat_gpt_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatPage extends GetView<ChatPageController> {
  const ChatPage({Key key}) : super(key: key);
  TextStyle get textStyle => AppConstant.textStyle;

  @override
  ChatPageController get controller => Get.put(ChatPageController());

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff1D1C21),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset('assets/images/logo.jpg'),
          ).paddingAll(6),
          title: const Text('Chatty GPT'),
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
        bottomNavigationBar: AdvertiseWidget(
          ad: controller.bottomAd,
        ),
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
                children: [
                  const CircularProgressIndicator().paddingAll(16),
                  Expanded(child: const Text('Loading...').paddingAll(16)),
                  ElevatedButton(
                    onPressed: controller.handleCancelPressed,
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
          return SelectableText(
            p0.metadata['text'].toString(),
            style: textStyle.copyWith(color: isChatGPT ? Colors.black : Colors.white),
          ).paddingSymmetric(horizontal: 16, vertical: 14);
        },
      ),
    );
  }

  Widget _bubbleBuilder(
    Widget child, {
    @required message,
    @required bool nextMessageInGroup,
  }) {
    final isAuthor = message.author.id == controller.user.id;

    if (isAuthor) {
      return Container(
        decoration: BoxDecoration(
          color: AppColor.userChatBackground,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(8),
            topRight: const Radius.circular(8),
            bottomLeft: const Radius.circular(8),
            bottomRight: nextMessageInGroup ? const Radius.circular(8) : const Radius.circular(0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: child,
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: AppColor.chatGptBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(8),
          topRight: const Radius.circular(8),
          bottomRight: const Radius.circular(8),
          bottomLeft: nextMessageInGroup ? const Radius.circular(8) : const Radius.circular(0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: child,
    );
  }
}
