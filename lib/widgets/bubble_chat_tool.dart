import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BubbleChatToolWidget extends StatelessWidget {
  BubbleChatToolWidget({
    Key? key,
    this.onCopyPressed,
    required this.child,
  }) : super(key: key);
  final Widget child;

  Function? onCopyPressed;

  List<ToolActionModel> get actions => [
        ToolActionModel(
          title: 'Copy',
          icon: Icons.copy,
          onPressed: () {
            onCopyPressed?.call();
            Get.back();
            //show toast
          },
        ),
        // ToolActionModel(
        //   title: 'Delete',
        //   icon: Icons.delete,
        //   onPressed: () {},
        // ),
      ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        // focus node
        // FocusScope.of(context).requestFocus(FocusNode());

        // Get.dialog(
        //   AlertBubbleChatTool(
        //     actions: actions,
        //     child: child,
        //   ),
        // );
      },
      child: child,
    );
  }
}

class AlertBubbleChatTool extends StatelessWidget {
  AlertBubbleChatTool({Key? key, required this.child, required this.actions}) : super(key: key);
  final Widget child;
  final List<ToolActionModel> actions;
  final ScrollController scrollController = ScrollController(
    //bottom
    initialScrollOffset: 0.0,
  );

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: SingleChildScrollView(
            controller: scrollController,
            //ios
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                child,
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: actions
                        .map((e) =>
                            _buildButton(text: e.title, onPressed: e.onPressed, icon: e.icon))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton({required String text, Function()? onPressed, required IconData icon}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        onTap: onPressed,
        title: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        trailing: Icon(
          icon,
          color: Colors.black,
          size: 16,
        ),
      ),
    );
  }
}

class ToolActionModel {
  final String title;
  final IconData icon;
  final Function()? onPressed;

  ToolActionModel({
    required this.title,
    required this.icon,
    this.onPressed,
  });
}
