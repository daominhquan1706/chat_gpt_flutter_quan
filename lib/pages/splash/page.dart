import 'package:chat_gpt_flutter_quan/pages/splash/controller.dart';
import 'package:chat_gpt_flutter_quan/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.asset(
                'assets/images/logo.jpg',
                width: 200,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            LoadingAnimationWidget.beat(
              color: AppColor.chatGptTextColor,
              size: 50,
            ).paddingSymmetric(vertical: 16),
            Text(
              'Chatty GPT',
              style: Theme.of(context).textTheme.headlineSmall,
            )
          ],
        ),
      ),
    );
  }
}
