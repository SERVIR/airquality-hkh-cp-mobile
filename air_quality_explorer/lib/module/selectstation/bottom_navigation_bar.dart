import 'package:air_quality_explorer/core/color.dart';
import 'package:air_quality_explorer/core/images.dart';
import 'package:air_quality_explorer/module/home/screens/home_screen.dart';
import 'package:air_quality_explorer/module/savelocation/screen/save_location_screen.dart';
import 'package:air_quality_explorer/module/setting/screen/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class BottomNavigationbarScreen extends StatefulWidget {
  const BottomNavigationbarScreen({super.key});

  @override
  State<BottomNavigationbarScreen> createState() =>
      _BottomNavigationbarScreenState();
}

class _BottomNavigationbarScreenState extends State<BottomNavigationbarScreen>
    with SingleTickerProviderStateMixin {
  // final _selectedIndex = 0.obs;
  late TabController controller;

  final screen = [
    const HomeScreen(),
    const SaveLocationScreen(),
    const SettingScreen(),
  ];

  @override
  void initState() {
    controller = TabController(length: 3, vsync: this);
    controller.index = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: TabBarView(
            controller: controller,
            physics: const NeverScrollableScrollPhysics(),
            children: screen),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            height: Get.size.height * 0.08,
            width: Get.size.width,
            decoration: BoxDecoration(
              color: AppColor.appPrimaryColor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      controller.index = 0;
                    });
                  },
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        color: controller.index == 0
                            ? AppColor.appButtonColor
                            : AppColor.appPrimaryColor,
                        boxShadow: [
                          BoxShadow(
                              color: controller.index == 0
                                  ? const Color.fromRGBO(14, 108, 182, 0.3)
                                  : AppColor.appPrimaryColor,
                              blurRadius: 16,
                              spreadRadius: 1),
                        ],
                        borderRadius: BorderRadius.circular(60)),
                    child: Center(
                      child: SvgPicture.asset(
                        AppImages.homeIcon,
                        height: 14,
                        width: 14,
                        color: controller.index == 0
                            ? AppColor.whiteColor
                            : AppColor.appTextColor,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      controller.index = 1;
                    });
                  },
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: controller.index == 1
                          ? AppColor.appButtonColor
                          : AppColor.appPrimaryColor,
                      boxShadow: [
                        BoxShadow(
                            color: controller.index == 1
                                ? const Color.fromRGBO(14, 108, 182, 0.3)
                                : AppColor.appPrimaryColor,
                            blurRadius: 16,
                            spreadRadius: 1),
                      ],
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        AppImages.saveIcon,
                        color: controller.index == 1
                            ? AppColor.whiteColor
                            : AppColor.appTextColor,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      controller.index = 2;
                    });
                  },
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        color: controller.index == 2
                            ? AppColor.appButtonColor
                            : AppColor.appPrimaryColor,
                        boxShadow: [
                          BoxShadow(
                              color: controller.index == 2
                                  ? const Color.fromRGBO(14, 108, 182, 0.3)
                                  : AppColor.appPrimaryColor,
                              blurRadius: 16,
                              spreadRadius: 1),
                        ],
                        borderRadius: BorderRadius.circular(60)),
                    child: Center(
                      child: SvgPicture.asset(
                        AppImages.settingIcon,
                        color: controller.index == 2
                            ? AppColor.whiteColor
                            : AppColor.appTextColor,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
