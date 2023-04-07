import 'package:chat_gpt_flutter_quan/flavors.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_version_checker/flutter_app_version_checker.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:url_launcher/url_launcher_string.dart';

class AppController extends GetxService {
  FirebaseRemoteConfig get remoteConfig => FirebaseRemoteConfig.instance;
  final user = const types.User(id: 'user');
  final chatGptUser = const types.User(id: 'chatGptUser');

  @override
  void onInit() {
    Future.delayed(const Duration(milliseconds: 0)).then((value) async {
      await fetchRemoteConfig();
    });
    checkVersion();
    super.onInit();
  }

  void checkVersion() async {
    if (kIsWeb) return;
    AppVersionChecker().checkUpdate().then((value) {
      Get.log(value.toString());
      Future.delayed(const Duration(seconds: 2), () {
        if (value.canUpdate == true) {
          Get.dialog(
            WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                title: const Text('Update Available'),
                content: const Text('Please update to latest version'),
                actions: [
                  TextButton(
                    onPressed: () {
                      launchUrlString(value.appURL!);
                    },
                    child: const Text('Update'),
                  ),
                ],
              ),
            ),
            barrierDismissible: false,
          );
        }
      });
    });
  }

  Future<void> fetchRemoteConfig() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await remoteConfig.fetchAndActivate();
    F.apiTokenChatGPT = remoteConfig.getString('API_TOKEN_CHATGPT');
    F.bannerAdUnitBottomBanner = remoteConfig.getString('BANNER_AD_UNIT_ID_BOTTOM_BANNER');
  }
}
