import 'package:chat_gpt_flutter_quan/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  await MobileAds.instance.initialize();
  runApp(App());
}
