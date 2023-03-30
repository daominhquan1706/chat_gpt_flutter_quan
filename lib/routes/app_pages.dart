import 'package:chat_gpt_flutter_quan/pages/chat/controller.dart';
import 'package:chat_gpt_flutter_quan/pages/chat/page.dart';
import 'package:chat_gpt_flutter_quan/pages/room/controller.dart';
import 'package:chat_gpt_flutter_quan/pages/room/page.dart';
import 'package:chat_gpt_flutter_quan/pages/splash/controller.dart';
import 'package:chat_gpt_flutter_quan/pages/splash/page.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

// IMPORTANT: Ask yourself about authentication & showAppbar to integrate correctly Middleware
abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.SPLASH,
      transition: Transition.fadeIn,
      page: () => const SplashPage(),
      bindings: [
        BindingsBuilder(() => Get.put<SplashController>(SplashController())),
      ],
    ),
    GetPage(
      name: Routes.CHAT,
      transition: Transition.fadeIn,
      page: () => ChatPage(),
      bindings: [
        BindingsBuilder(() => Get.put<ChatPageController>(ChatPageController())),
      ],
    ),
    GetPage(
      name: Routes.ROOM,
      transition: Transition.fadeIn,
      page: () => const RoomPage(),
      bindings: [
        BindingsBuilder(() => Get.put<RoomPageController>(RoomPageController())),
      ],
    ),
  ];
}
