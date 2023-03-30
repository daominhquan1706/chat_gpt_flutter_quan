import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextFieldMessage extends StatelessWidget {
  final FocusNode messageFocusNode;
  final TextEditingController messageController;

  final Function(String) onSubmitted;

  const TextFieldMessage({Key key, this.messageFocusNode, this.messageController, this.onSubmitted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Stack(
                children: [
                  TextFormField(
                    focusNode: messageFocusNode,
                    controller: messageController,
                    decoration: const InputDecoration(
                      suffix: SizedBox(
                        width: 32,
                      ),
                      hintText: 'Enter a prompt here',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(500)),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    onFieldSubmitted: (value) {
                      if (value.isNotEmpty) {
                        onSubmitted(value);
                        messageController.text = '';
                        messageFocusNode.requestFocus();
                      }
                    },
                  ).paddingSymmetric(horizontal: 16, vertical: 20),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 32,
                    child: InkWell(
                      child: const Icon(
                        Icons.send,
                      ),
                      onTap: () {
                        if (messageController.text.isNotEmpty) {
                          onSubmitted(messageController.text);
                          messageController.text = '';
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        SafeArea(child: Container()),
      ],
    );
  }
}
