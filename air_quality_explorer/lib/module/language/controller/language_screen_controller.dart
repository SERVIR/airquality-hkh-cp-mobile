import 'dart:io';

import 'package:air_quality_explorer/core/sharePreference_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageScreenController extends GetxController {
  var locale = "".obs;
  var languageDropValue = 'English'.obs;
  var languageDrop = [
    'English',
    'Nepalese',
  ];

  // @override
  // void onInit() {
  //   getLanguageLocal();
  //   super.onInit();
  // }

  getLanguageLocal() async {
    locale.value = await getLocaleLanguage();
    languageDropValue.value = locale.value == "ne_IN" ? "Nepalese" : "English";
  }

  updateLanguage() {
    var local = languageDropValue.value == 'English'
        ? const Locale('en', 'US')
        : const Locale('ne', 'IN');
    Get.updateLocale(local);
    setLocale(local);
  }

  Future<Locale> getLocale(String locale) async {
    String defaultLocale = Platform.localeName;
    getLanguageLocal();
    switch (locale) {
      case "en_US":
        {
          return const Locale('en', 'US');
        }
      case "ne_IN":
        {
          return const Locale('ne', 'IN');
        }
      default:
        return defaultLocale == 'ne_IN'
            ? const Locale('ne', 'IN')
            : const Locale('en', 'US');
    }
  }
}
