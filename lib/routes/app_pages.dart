import 'package:chat_gpt_flutter_quan/pages/chat/controller.dart';
import 'package:chat_gpt_flutter_quan/pages/chat/page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

// IMPORTANT: Ask yourself about authentication & showAppbar to integrate correctly Middleware
abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.CHAT,
      transition: Transition.fadeIn,
      page: () => ChatPage(),
      bindings: [
        BindingsBuilder(() => Get.put<ChatPageController>(ChatPageController())),
      ],
      
    ),
  ];
}
