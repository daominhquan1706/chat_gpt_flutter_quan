import 'package:chat_gpt_flutter_quan/service/app_controller.dart';
import 'package:chat_gpt_flutter_quan/utils/constants.dart';
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
    const smallCorner = Radius.circular(3);
    if (isAuthor) {
      return Container(
        decoration: BoxDecoration(
          color: AppColor.userChatBackground,
          borderRadius: BorderRadius.only(
            topLeft: bigCorner,
            topRight: bigCorner,
            bottomLeft: bigCorner,
            bottomRight: nextMessageInGroup ? bigCorner : smallCorner,
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
          topLeft: bigCorner,
          topRight: bigCorner,
          bottomRight: bigCorner,
          bottomLeft: nextMessageInGroup ? bigCorner : smallCorner,
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
