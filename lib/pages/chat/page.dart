import 'package:chat_gpt_flutter_quan/models/ad_model.dart';
import 'package:chat_gpt_flutter_quan/pages/chat/controller.dart';
import 'package:chat_gpt_flutter_quan/pages/chat/widgets/chat_bubble_widget.dart';
import 'package:chat_gpt_flutter_quan/pages/chat/widgets/chat_type_welcome_widget.dart';
import 'package:chat_gpt_flutter_quan/routes/app_pages.dart';
import 'package:chat_gpt_flutter_quan/utils/utils.dart';
import 'package:chat_gpt_flutter_quan/widgets/text_field_message.dart';
import 'package:chat_gpt_flutter_quan/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ChatPage extends GetResponsiveView<ChatPageController> {
  ChatPage({Key? key}) : super(key: key);
  TextStyle get textStyle => AppConstant.textStyle;

  @override
  ChatPageController get controller => Get.find<ChatPageController>(tag: Get.parameters['id']!);

  @override
  Widget phone() {
    return Scaffold(
      key: controller.scaffoldKey,
      backgroundColor: AppColor.backgroundColor,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: _buildChat(),
    );
  }

  @override
  Widget tablet() {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: AppColor.backgroundColor,
      body: Row(
        children: [
          _buildDrawer(),
          Expanded(
              child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 800,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _buildChat(),
              ).paddingOnly(bottom: 16, right: 16),
            ),
          )),
        ],
      ),
    );
  }

  @override
  Widget desktop() {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: AppColor.backgroundColor,
      body: Row(
        children: [
          _buildDrawer(),
          Expanded(
              child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 800,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _buildChat(),
              ).paddingOnly(bottom: 16),
            ),
          )),
        ],
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      elevation: 0,
      backgroundColor: AppColor.backgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ListTile(
              leading: const Icon(Icons.replay),
              title: const Text('Reset chat'),
              onTap: () {
                controller.closeDrawer();
                controller.handleClearHistoryPressed();
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('History'),
            onTap: () {
              controller.closeDrawer();
              Get.offAllNamed(Routes.ROOM);
            },
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColor.backgroundColor,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(
          Icons.menu,
          color: Colors.black,
        ),
        onPressed: () {
          if (screen.isDesktop) {
            return;
          }
          controller.openDrawer();
        },
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Chatty GPT',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          8.horizontalSpace,
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
    );
  }

  Obx _buildChat() {
    return Obx(() => Chat(
          messages: controller.messages.value,
          onSendPressed: controller.handleSendPressed,
          user: controller.user,
          bubbleBuilder: _bubbleBuilder,
          theme: DefaultChatTheme(
            backgroundColor: Colors.grey.shade200,
          ),
          customBottomWidget: TextFieldMessage(
            messageFocusNode: controller.messageFocusNode,
            messageController: controller.messageController,
            onSubmitted: (message) {
              controller.handleSendPressed(types.PartialText(text: message));
            },
          ),
          customMessageBuilder: (p0, {required messageWidth}) {
            if (p0.metadata == null) {
              return const SizedBox.shrink();
            }
            final ChatType type = p0.metadata!['type'] ?? ChatType.unknown;
            switch (type) {
              case ChatType.advertisement:
                return Obx(() {
                  final AdModel advertisement = p0.metadata!['advertisement'];
                  if (advertisement.isReady.value) {
                    return AdvertiseWidget(
                      ad: advertisement,
                    );
                  }
                  return const SizedBox.shrink();
                });
              case ChatType.errorMessage:
                return SelectableText(
                  p0.metadata!['error'].toString(),
                  style: textStyle.copyWith(color: Colors.red),
                ).paddingSymmetric(horizontal: 16, vertical: 14);
              case ChatType.loading:
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LoadingAnimationWidget.beat(
                      color: AppColor.chatGptTextColor,
                      size: 30,
                    ).paddingAll(16),
                    const Spacer(),
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
              case ChatType.normalMessage:
                final isChatGPT = p0.author.id == controller.chatGptUser.id;
                if (isChatGPT) {
                  return ChatGptContainerWidget(p0);
                }
                return SelectableText(
                  p0.metadata!['text'].toString(),
                  style: textStyle.copyWith(
                    color: isChatGPT ? AppColor.chatGptTextColor : AppColor.userChatTextColor,
                  ),
                ).paddingSymmetric(horizontal: 16, vertical: 14);
              default:
                return const SizedBox.shrink();
            }
          },
        ));
  }

  Widget _bubbleBuilder(
    Widget child, {
    required types.Message message,
    required bool nextMessageInGroup,
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
