import 'package:chat_gpt_flutter_quan/app.dart';
import 'package:chat_gpt_flutter_quan/firebase_options.dart';
import 'package:chat_gpt_flutter_quan/flavors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main() async {
  F.appFlavor = Flavor.PROD;
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    dotenv.load(fileName: ".env"),
    MobileAds.instance.initialize(),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
  ]);
  runApp(const App());
}
