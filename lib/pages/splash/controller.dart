import 'package:chat_gpt_flutter_quan/routes/app_pages.dart';
import 'package:chat_gpt_flutter_quan/service/app_service.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  AppService get _appService => Get.find<AppService>();

  @override
  void onInit() {
    _appService.fetchRemoteConfig().then((value) {
      Get.offAllNamed(Routes.CHAT);
    });
    super.onInit();
  }
}
