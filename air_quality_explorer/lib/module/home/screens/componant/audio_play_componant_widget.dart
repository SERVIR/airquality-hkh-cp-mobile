import 'package:air_quality_explorer/core/color.dart';
import 'package:air_quality_explorer/module/home/controller/home_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AudioPlayComponantWidget extends StatelessWidget {
  const AudioPlayComponantWidget({
    Key? key,
    // required this.nine,
    required this.controller,
    // required this.ten,
    // required this.eleven,
  }) : super(key: key);

  // final GlobalKey<State<StatefulWidget>> nine;
  final HomeScreenController controller;
  // final GlobalKey<State<StatefulWidget>> ten;
  // final GlobalKey<State<StatefulWidget>> eleven;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10),
      /* child: Showcase(
        key: nine,
        title: 'Date and time timeline',
        titleTextStyle: Theme.of(context).textTheme.displayLarge!.copyWith(
              fontSize: 16,
              color: AppColor.appbarTextColor,
              fontWeight: FontWeight.w600,
            ),
        description: 'This is a timeline where you can\n see the date and time',
        descTextStyle: Theme.of(context).textTheme.displayLarge!.copyWith(
              fontSize: 14,
              color: AppColor.appButtonColor,
            ),
        targetShapeBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        tooltipBorderRadius: BorderRadius.circular(3),
        onToolTipClick: () {
          controller.menuButtonSelect.value = false;
          ShowCaseWidget.of(context).startShowCase([
            ten,
          ]);
        }, */
      child: Container(
        height: Get.size.height * 0.094,
        // width: Get.size.width * 0.30,
        decoration: BoxDecoration(
          color: AppColor.appPrimaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Text(
                DateFormat('dd-MM-yyyy  HH:mm:ss').format(DateTime.now()),
                style: Theme.of(context)
                    .textTheme
                    .displayLarge!
                    .copyWith(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Obx(
                () => SizedBox(
                  height: 10,
                  /* child: Showcase(
                      key: ten,
                      title: 'Manually playhead',
                      titleTextStyle:
                          Theme.of(context).textTheme.displayLarge!.copyWith(
                                fontSize: 16,
                                color: AppColor.appbarTextColor,
                                fontWeight: FontWeight.w600,
                              ),
                      description:
                          'You can also adjust this playhead\n manually',
                      descTextStyle:
                          Theme.of(context).textTheme.displayLarge!.copyWith(
                                fontSize: 14,
                                color: AppColor.appButtonColor,
                              ),
                      targetShapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      tooltipBorderRadius: BorderRadius.circular(3),
                      onToolTipClick: () {
                        controller.menuButtonSelect.value = false;
                        ShowCaseWidget.of(context).startShowCase([
                          eleven,
                        ]);
                      }, */
                  child: Slider(
                    value: controller.rangeSlider.obs.value.toDouble(),
                    onChanged: (value) {
                      controller.rangeSlider.value = value.toInt();
                    },
                    min: 0,
                    divisions: 100,
                    max: 100,
                    activeColor: AppColor.appButtonColor,
                    inactiveColor: AppColor.greayColor,
                  ),
                ),
              ),
              // ),
            ],
          ),
        ),
      ),
      // ),
    );
  }
}
