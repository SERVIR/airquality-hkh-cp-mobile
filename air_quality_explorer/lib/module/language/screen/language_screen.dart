// ignore_for_file: prefer_const_constructors

import 'package:air_quality_explorer/core/color.dart';
import 'package:air_quality_explorer/module/language/controller/language_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LanguageScreenController());

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
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: SizedBox(
                    height: Get.size.height * 0.045,
                    width: Get.size.height * 0.045,
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 15,
                      color: AppColor.appbarbackIconColor,
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  // Str.language,
                  "language".tr,
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
              height: Get.size.height * 0.040,
            ),
            Text(
              "selectLanguage".tr,
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(color: Color(0xFF5D6571), fontSize: 16),
            ),
            SizedBox(
              height: Get.size.height * 0.014,
            ),
            Obx(
              () => Container(
                height: Get.size.height * 0.08,
                width: Get.size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFF3FAFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: DropdownButton(
                      value: controller.languageDropValue.value,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: controller.languageDrop.map((items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(
                            items,
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(fontSize: 16),
                          ),
                        );
                      }).toList(),
                      underline: Container(),
                      iconEnabledColor: const Color(0xFF555555),
                      isExpanded: true,
                      elevation: 0,
                      onChanged: (newValue) async {
                        controller.languageDropValue.value = "$newValue";
                        controller.updateLanguage();
                      },
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
