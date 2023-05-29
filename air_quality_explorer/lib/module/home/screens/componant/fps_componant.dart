import 'package:air_quality_explorer/core/color.dart';
import 'package:air_quality_explorer/core/images.dart';
import 'package:air_quality_explorer/module/home/controller/home_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class FPSSpeedComponant extends StatelessWidget {
  const FPSSpeedComponant({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final HomeScreenController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(
          left: 10,
        ),
        /* child: Showcase(
          key: controller.thirteen,
          title: 'Control playback speed',
          titleTextStyle: Theme.of(context).textTheme.displayLarge!.copyWith(
                fontSize: 16,
                color: AppColor.appbarTextColor,
                fontWeight: FontWeight.w600,
              ),
          description: 'You can control the playback\n speed upto 6fps',
          descTextStyle: Theme.of(context).textTheme.displayLarge!.copyWith(
                fontSize: 14,
                color: AppColor.appButtonColor,
              ),
          targetShapeBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          tooltipBorderRadius: BorderRadius.circular(3),
          onToolTipClick: () {
            controller.selectDropdownValue.value = "Recent";
            ShowCaseWidget.of(context).startShowCase([controller.fourteen]);
          }, */
        child: Container(
          height: Get.size.height * 0.066,
          decoration: BoxDecoration(
            color: AppColor.appPrimaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    controller.minus();
                  },
                  child: Container(
                    height: 26,
                    width: 26,
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.08), blurRadius: 5)
                      ],
                    ),
                    child: Center(child: SvgPicture.asset(AppImages.minusIcon)),
                  ),
                ),
                const Spacer(),
                Text(
                  "${controller.fps.value} fps",
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    controller.add();
                  },
                  child: Container(
                    height: 26,
                    width: 26,
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.08), blurRadius: 5)
                      ],
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/plush1.svg',
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        // ),
      ),
    );
  }
}
