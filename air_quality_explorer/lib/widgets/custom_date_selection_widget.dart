import 'package:air_quality_explorer/core/color.dart';
import 'package:air_quality_explorer/core/images.dart';
import 'package:air_quality_explorer/widgets/submit_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../module/selectstation/controller/select_station_screen_controller.dart';

class CustomDateSelectionWidget extends StatelessWidget {
  const CustomDateSelectionWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SelectStationScreenController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Obx(
        () => Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: Get.size.height * 0.060,
                  width: Get.size.width * 0.284,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          controller.selectFromDate.value.isEmpty
                              ? "From date"
                              : controller.selectFromDate.value,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  color: AppColor.appTextColor, fontSize: 12),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          controller.isselectDate.value = '0';
                          controller.selectDate();
                        },
                        child: SizedBox(
                          height: 44,
                          width: 44,
                          child: Center(
                            child: SvgPicture.asset(AppImages.calenderIcon),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: Get.size.height * 0.060,
                  width: Get.size.width * 0.284,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          controller.selectToDate.value.isEmpty
                              ? "To date"
                              : controller.selectToDate.value,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  color: AppColor.appTextColor, fontSize: 12),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          controller.isselectDate.value = '1';
                          controller.selectDate();
                        },
                        child: SizedBox(
                          height: 44,
                          width: 44,
                          child: Center(
                            child: SvgPicture.asset(AppImages.calenderIcon),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SubmitButtonWidget(
                  height: Get.size.height * 0.060,
                  width: Get.size.height * 0.114,
                  btnText: 'apply'.tr,
                  onTap: () {
                    controller.isApply.value = true;
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
