import 'package:chat_gpt_flutter_quan/utils/constants.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ChatTypeWelComeWidget extends StatelessWidget {
  ChatTypeWelComeWidget({Key key, this.onTapOption}) : super(key: key);
  TextStyle get textStyle => AppConstant.textStyle;

  final Function(String) onTapOption;

  final listOptions = [
    'Write me an email to apply for a job',
    'Explain AI in three sentences',
    'Tell me a joke',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(
          '''I'll be happy to assist you. As an AI chatbot powered by OpenAI, here what I can do:''',
          style: AppConstant.textStyle.copyWith(color: Colors.black),
        ),
        ...listOptions.map((e) => _buildChatOptiton(e)).toList(),
        SelectableText(
          ''' 
Please feel free to ask me anything. How can I assist you today?''',
          style: textStyle.copyWith(color: Colors.black),
        ),
      ],
    ).paddingSymmetric(horizontal: 16, vertical: 14);
  }

  Widget _buildChatOptiton(String text) {
    return InkWell(
      onTap: () {
        onTapOption?.call(text);
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8.0)),
        child: Text(
          text,
          style: textStyle.copyWith(color: Colors.white),
        ).paddingSymmetric(horizontal: 16, vertical: 14),
      ).paddingOnly(bottom: 8),
    );
  }
}
