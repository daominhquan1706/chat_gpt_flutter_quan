import 'package:chat_gpt_flutter_quan/utils/app_colors.dart';
import 'package:chat_gpt_flutter_quan/utils/constants.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ChatTypeWelComeWidget extends StatelessWidget {
  const ChatTypeWelComeWidget({Key key, this.onTapOption}) : super(key: key);
  TextStyle get textStyle => AppConstant.textStyle;

  final Function(String) onTapOption;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Hello! How can I help you today?',
      style: textStyle.copyWith(color: AppColor.chatGptTextColor),
    ).paddingSymmetric(horizontal: 16, vertical: 14);
  }
}
