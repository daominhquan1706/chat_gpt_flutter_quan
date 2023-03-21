import 'package:chat_gpt_flutter_quan/app.dart';
import 'package:chat_gpt_flutter_quan/firebase_options.dart';
import 'package:chat_gpt_flutter_quan/flavors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main() async {
  F.appFlavor = Flavor.PROD;
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    if (!kIsWeb) MobileAds.instance.initialize(),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
  ]);
  runApp(const App());
}
