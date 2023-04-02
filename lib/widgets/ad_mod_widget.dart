import 'package:chat_gpt_flutter_quan/models/ad_model.dart';
import 'package:chat_gpt_flutter_quan/service/ad_mod_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdvertiseWidget extends StatelessWidget {
  const AdvertiseWidget({
    Key? key,
    required this.ad,
  }) : super(key: key);

  AdModService get _adModService => Get.find<AdModService>();
  final AdModel ad;

  @override
  Widget build(BuildContext context) {
    if (_adModService.bottomAd == null) {
      return const SizedBox.shrink();
    }
    return Obx(() {
      if (_adModService.bottomAd.isReady.value == true) {
        return SizedBox(
          width: ad.adSize.width.toDouble(),
          height: ad.adSize.height.toDouble(),
          child: AdWidget(ad: ad.bannerAd),
        );
      }
      return const SizedBox.shrink();
    });
  }
}
