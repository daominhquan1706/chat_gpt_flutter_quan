import 'package:chat_gpt_flutter_quan/routes/app_pages.dart';
import 'package:chat_gpt_flutter_quan/service/ad_mod_service.dart';
import 'package:chat_gpt_flutter_quan/service/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Chatty GPT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.robotoTextTheme(),
        useMaterial3: true,
      ),
      getPages: AppPages.pages,
      initialRoute: Routes.SPLASH,
      initialBinding: AppBindings(),
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(builder: _builder),
    );
  }

  Widget _builder(BuildContext context, Widget? child) {
    double textScale = 1.0;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: textScale),
      child: child!,
    );
  }
}

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AppController());
    Get.put(AdModService());
  }
}
