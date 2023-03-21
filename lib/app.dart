import 'package:chat_gpt_flutter_quan/routes/app_pages.dart';
import 'package:chat_gpt_flutter_quan/service/ad_mod_service.dart';
import 'package:chat_gpt_flutter_quan/service/app_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Chatty GPT',
      theme: ThemeData(
          primarySwatch: Colors.blue, textTheme: GoogleFonts.robotoTextTheme()),
      getPages: AppPages.pages,
      initialRoute: Routes.SPLASH,
      initialBinding: AppBindings(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AppService());
    Get.put(AdModService());
  }
}
