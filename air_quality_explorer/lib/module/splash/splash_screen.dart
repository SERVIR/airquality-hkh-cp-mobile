import 'dart:async';

import 'package:air_quality_explorer/core/color.dart';
import 'package:air_quality_explorer/core/images.dart';
import 'package:air_quality_explorer/core/sharePreference_screen.dart';
import 'package:air_quality_explorer/module/language/controller/language_screen_controller.dart';
import 'package:air_quality_explorer/module/splash/intro_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  LanguageScreenController langController = Get.put(LanguageScreenController());

  @override
  void initState() {
    navigateToHomescreen();
    super.initState();
  }

  navigateToHomescreen() async {
    final localeLangCode = await getLocaleLanguage();
    Locale locale = await langController.getLocale(localeLangCode);

    Get.updateLocale(locale);
    Timer(
      const Duration(milliseconds: 2000),
      () {
        Get.offAll(() => const IntroScreen());
        // Get.offAll(() => const HomeScreen1());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.size.height,
      width: Get.size.width,
      color: AppColor.appPrimaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60),
        child: SvgPicture.asset(AppImages.appLogo),
      ),
    );
  }
}
