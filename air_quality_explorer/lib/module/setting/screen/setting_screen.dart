// ignore_for_file: prefer_const_constructors

import 'package:air_quality_explorer/core/color.dart';
import 'package:air_quality_explorer/core/images.dart';
import 'package:air_quality_explorer/module/home/screens/componant/info_screen.dart';
import 'package:air_quality_explorer/module/language/screen/language_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Get.size.height * 0.065,
            ),
            Row(
              children: [
                Spacer(),
                Text(
                  "settings".tr,
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: AppColor.appbarTextColor,
                      ),
                ),
                Spacer(),
              ],
            ),
            SizedBox(
              height: Get.size.height * 0.042,
            ),
            InkWell(
              onTap: () {
                Get.to(LanguageScreen());
              },
              child: SizedBox(
                height: Get.size.height * 0.041,
                child: Row(
                  children: [
                    SvgPicture.asset(AppImages.languageIcon),
                    SizedBox(
                      width: Get.size.width * 0.045,
                    ),
                    Text(
                      // Str.language,
                      "language".tr,
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                    ),
                    Spacer(),
                    SvgPicture.asset(AppImages.rightArrowIcon)
                  ],
                ),
              ),
            ),
            SizedBox(
              height: Get.size.height * 0.040,
            ),
            InkWell(
              onTap: () {
                Get.to(() => InfoScreen());
              },
              child: SizedBox(
                height: Get.size.height * 0.041,
                child: Row(
                  children: [
                    SvgPicture.asset(AppImages.infoIcon),
                    SizedBox(
                      width: Get.size.width * 0.045,
                    ),
                    Text(
                      "aboutUs".tr,
                      // Str.aboutus,
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                    ),
                    Spacer(),
                    SvgPicture.asset(AppImages.rightArrowIcon)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
