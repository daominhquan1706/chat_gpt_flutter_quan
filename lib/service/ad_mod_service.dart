import 'package:chat_gpt_flutter_quan/flavors.dart';
import 'package:chat_gpt_flutter_quan/models/ad_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdModService extends GetxService {
  static final isReady = false.obs;
  static int totalTokens = 0;

  AdModel bottomAd;

  List<AdModel> adsChat = [];

  static String get bannerAdUnitId {
    if (!kIsWeb) {
      return F.bannerAdUnitBottomBanner;
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    if (!kIsWeb) {
      _loadBottomAd();
    }
  }

  @override
  void onClose() {
    dispose();
    super.onClose();
  }

  void _loadBottomAd() {
    bottomAd = AdModel(
      adUnitId: bannerAdUnitId,
      adSize: AdSize(
        height: 52,
        width: Get.width.toInt(),
      ),
    )..generateAd();
  }

  void dispose() {
    bottomAd?.bannerAd?.dispose();
    for (var ad in adsChat) {
      ad?.bannerAd?.dispose();
    }
  }
}
