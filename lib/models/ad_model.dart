import 'package:chat_gpt_flutter_quan/service/ad_mod_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdModel {
  String? adUnitId = AdModService.bannerAdUnitId;
  AdSize adSize;
  RxBool isReady = false.obs;
  late BannerAd bannerAd;
  AdModel({this.adUnitId, required this.adSize});

  void generateAd() {
    if (adUnitId == null) return;
    bannerAd = BannerAd(
      adUnitId: adUnitId!,
      request: const AdRequest(),
      size: adSize,
      listener: bannerAdListener(
        onAdLoaded: () {
          isReady.value = true;
        },
      ),
    )..load();
  }

  BannerAdListener bannerAdListener({required Function onAdLoaded}) {
    return BannerAdListener(
      onAdLoaded: (ad) {
        debugPrint('AdModService: $ad onAdLoaded.');
        onAdLoaded.call();
      },
      onAdFailedToLoad: (ad, err) {
        debugPrint('AdModService: $ad onAdFailedToLoad.');
        debugPrint('BannerAd failed to load: $err');
        ad.dispose();
      },
      onAdClicked: (ad) {
        debugPrint('AdModService: $ad onAdClicked.');
      },
      onAdClosed: (ad) {
        debugPrint('AdModService: $ad onAdClosed.');
      },
      onAdImpression: (ad) {
        debugPrint('AdModService: $ad onAdImpression.');
      },
      onAdOpened: (ad) {
        debugPrint('AdModService: $ad onAdOpened.');
      },
      onAdWillDismissScreen: (ad) {
        debugPrint('AdModService: $ad onAdWillDismissScreen.');
      },
    );
  }
}
