import 'package:chat_gpt_flutter_quan/pages/chat/page.dart';
import 'package:chat_gpt_flutter_quan/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      home: const ChatPage(),
      initialRoute: Routes.CHAT,
      initialBinding: AppBindings(initRoute: Routes.CHAT),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppBindings extends Bindings {
  final String initRoute;

  AppBindings({
    @required this.initRoute,
  });

  @override
  void dependencies() {
    // Get.put(AppLocalizationController());
  }
}
