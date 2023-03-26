import 'package:chat_gpt_flutter_quan/routes/app_pages.dart';
import 'package:chat_gpt_flutter_quan/service/app_controller.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  AppController get _appService => Get.find<AppController>();

  @override
  void onInit() {
    _appService.fetchRemoteConfig().then((value) {
      Get.offAllNamed(Routes.ROOM);
    });
    super.onInit();
  }
}
