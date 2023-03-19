import 'dart:io';

import 'package:chat_gpt_flutter_quan/service/ad_mod_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdModWiget extends StatefulWidget {
  const AdModWiget({Key key}) : super(key: key);

  @override
  State<AdModWiget> createState() => _AdModWigetState();
}

class _AdModWigetState extends State<AdModWiget> {
  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';
  BannerAd _bannerAd;

  /// Loads a banner ad.
  void _loadAd() {
    _bannerAd = BannerAd(
      adUnitId: AdModService.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize(width: Get.width.toInt(), height: 52),
      listener: AdModService.bannerAdListener,
    )..load();
  }

  @override
  void initState() {
    _loadAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_bannerAd != null) {
      return SizedBox(
        height: 52,
        child: AdWidget(ad: _bannerAd),
      );
    }
    return Container();
  }
}
