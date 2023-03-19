import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/utils.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdModService {
  static String get bannerAdUnitId {
    if (GetPlatform.isAndroid) {
      return kDebugMode
          ? 'ca-app-pub-3940256099942544/6300978111'
          : dotenv.env['BANNER_AD_UNIT_ID_BOTTOM_BANNER'];
    }
    return null;
  }

  static BannerAdListener bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) {
      debugPrint('AdModService: $ad onAdLoaded.');
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
