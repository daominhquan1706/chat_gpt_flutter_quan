import 'package:chat_gpt_flutter_quan/service/app_controller.dart';
import 'package:chat_gpt_flutter_quan/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';

class ChatBubbleWidget extends StatelessWidget {
  const ChatBubbleWidget({
    Key key,
    @required this.child,
    @required this.message,
    this.nextMessageInGroup = false,
  }) : super(key: key);

  final Widget child;
  final types.Message message;
  final bool nextMessageInGroup;
  types.User get user => Get.find<AppController>().user;
  bool get isAuthor => message.author.id == user.id;

  @override
  Widget build(BuildContext context) {
    const bigCorner = Radius.circular(16);
    const smallCorner = Radius.circular(16);
    if (isAuthor) {
      return SizedBox(
        width: double.infinity,
        child: child,
      );
    }
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.chatGptBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: bigCorner,
          topRight: bigCorner,
          bottomRight: bigCorner,
          bottomLeft: nextMessageInGroup ? bigCorner : smallCorner,
        ),
      ),
      child: child,
    );
  }
}
