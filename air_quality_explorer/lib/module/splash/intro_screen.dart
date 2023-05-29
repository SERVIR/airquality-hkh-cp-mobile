import 'package:air_quality_explorer/core/color.dart';
import 'package:air_quality_explorer/core/images.dart';
import 'package:air_quality_explorer/module/selectstation/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  PageController controller = PageController();
  var currentId = 0.obs;
  @override
  void initState() {
    super.initState();
    controller = PageController();
  }

  add(int id) {
    // controller = PageController();
    currentId.value = id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appPrimaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 350.h,
              decoration: const BoxDecoration(
                color: AppColor.appButtonLightColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50)),
              ),
              child: Column(
                children: [
                  Container(
                    height: 340.h,
                    width: Get.size.width,
                    decoration: const BoxDecoration(
                      color: AppColor.lightAppBtnColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(45),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: PageView(
                        controller: controller,
                        children: [
                          Image.asset(AppImages.intro1Img),
                          Image.asset(AppImages.intro2Img),
                          Image.asset(AppImages.intro3Img),
                        ],
                        onPageChanged: (value) {
                          currentId.value = value;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    currentId.value == 0
                        ? "Start at home"
                        : currentId.value == 1
                            ? "Save the locations"
                            : "Customized Settings",
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColor.appbarTextColor,
                        fontSize: 20),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Obx(
                  () => SizedBox(
                    width: Get.size.width * 0.75,
                    child: Text(
                      currentId.value == 0
                          ? "At a glance, view air pollutants across the region and over time."
                          : currentId.value == 1
                              ? "Save a location by tapping the map and check air quality at any time from anywhere."
                              : "Choose language as per your convenience.",
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: AppColor.lightGrayColor,
                              letterSpacing: 1),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Get.size.height * 0.018,
            ),

            /// Nepali language translate
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    currentId.value == 0
                        ? "घरबाट सुरु गर्नुहोस्"
                        : currentId.value == 1
                            ? "स्थानहरू बचत गर्नुहोस्"
                            : "अनुकूलित सेटिङहरू",
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColor.appbarTextColor,
                        fontSize: 20),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Obx(
                  () => SizedBox(
                    width: Get.size.width * 0.75,
                    child: Text(
                      currentId.value == 0
                          ? "एक नजरमा, क्षेत्र र समयसँगै वायु प्रदूषकहरू हेर्नुहोस्।"
                          : currentId.value == 1
                              ? "नक्सा ट्याप गरेर एक स्थान बचत गर्नुहोस् र कुनै पनि समयमा कहींबाट हावा गुणस्तर जाँच गर्नुहोस्।"
                              : "आफ्नो सुविधा अनुसार भाषा छान्नुहोस्।",
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: AppColor.lightGrayColor,
                              letterSpacing: 1),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 6,
                    width: currentId.value == 0 ? 40 : 18,
                    decoration: BoxDecoration(
                      color: currentId.value == 0
                          ? AppColor.appButtonColor
                          : AppColor.lightAppBtnColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 6,
                    width: currentId.value == 1 ? 40 : 18,
                    decoration: BoxDecoration(
                      color: currentId.value == 1
                          ? AppColor.appButtonColor
                          : AppColor.lightAppBtnColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 6,
                    width: currentId.value == 2 ? 40 : 18,
                    decoration: BoxDecoration(
                      color: currentId.value == 2
                          ? AppColor.appButtonColor
                          : AppColor.lightAppBtnColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 30,
                right: 40,
              ),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Get.off(() => const BottomNavigationbarScreen());
                    },
                    child: Text(
                      "Skip",
                      style:
                          Theme.of(context).textTheme.displayMedium!.copyWith(
                                fontSize: 20,
                                color: AppColor.appButtonColor,
                              ),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      if (currentId.value == 0) {
                        controller.animateToPage(1,
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeIn);
                      } else if (currentId.value == 1) {
                        controller.animateToPage(2,
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeIn);
                      } else if (currentId.value == 2) {
                        Get.off(() => const BottomNavigationbarScreen());
                      }
                    },
                    child: Obx(
                      () => SizedBox(
                        height: Get.size.height * 0.055,
                        width: Get.size.height * 0.1,
                        child: Center(
                          child: currentId.value == 0 || currentId.value == 1
                              ? SvgPicture.asset(AppImages.rightArrowIcon,
                                  color: AppColor.appButtonColor)
                              : Text(
                                  "Done",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                        fontSize: 20,
                                        color: AppColor.appButtonColor,
                                      ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
