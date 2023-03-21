import 'package:chat_gpt_flutter_quan/flavors.dart';
import 'package:chat_gpt_flutter_quan/routes/app_pages.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';

class AppService extends GetxService {
  FirebaseRemoteConfig get remoteConfig => FirebaseRemoteConfig.instance;

  @override
  void onInit() {
    final currentRoute = Get.currentRoute;

    Future.delayed(const Duration(milliseconds: 100)).then((value) async {
      await Get.offAllNamed(Routes.SPLASH).then((value) async {});
      await fetchRemoteConfig();
      if (currentRoute != Routes.SPLASH) {
        Get.toNamed(currentRoute);
      } else {
        Get.offAllNamed(Routes.CHAT);
      }
    });

    super.onInit();
  }

  Future<void> fetchRemoteConfig() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await remoteConfig.fetchAndActivate();
    F.apiTokenChatGPT = remoteConfig.getString('API_TOKEN_CHATGPT');
    F.bannerAdUnitBottomBanner =
        remoteConfig.getString('BANNER_AD_UNIT_ID_BOTTOM_BANNER');
  }
}
