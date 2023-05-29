import 'package:air_quality_explorer/core/color.dart';
import 'package:air_quality_explorer/database/check_insertdata.dart';
import 'package:air_quality_explorer/module/home/controller/home_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class RangeSliderWidget extends StatelessWidget {
  const RangeSliderWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeCntrl = Get.find<HomeScreenController>();
    return Obx(
      () => Container(
        width: Get.width - 30,
        height: Get.height * 0.08,
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.8)),
        child: SfRangeSlider(
          min: homeCntrl.dateMin.value,
          max: homeCntrl.dateMax.value,
          showLabels: true,
          minorTicksPerInterval: 1,
          showTicks: true,
          enableTooltip: true,
          activeColor: AppColor.appButtonColor,
          stepDuration: const SliderStepDuration(days: 1),
          interval: 2,
          dateFormat: DateFormat.MMMd(),
          dateIntervalType: DateIntervalType.days,
          values: homeCntrl.dateValues.value,
          onChanged: (SfRangeValues newValues) {
            homeCntrl.dateValues.value = newValues;

            DateTime rangeStartDate = DateTime.parse(
                DateFormat('yyyy-MM-dd').format(newValues.start));
            DateTime rangeEndDate =
                DateTime.parse(DateFormat('yyyy-MM-dd').format(newValues.end));
            DateTime nowDate =
                DateTime.parse(DateFormat('yyyy-MM-dd').format(homeCntrl.now));

            homeCntrl.startDate.value = newValues.start;
            if (nowDate.isAfter(newValues.start) ||
                rangeEndDate.isBefore(nowDate)) {
              homeCntrl.isArchivAndRecentSelect.value = true;
              homeCntrl.isForcastRangeSelect.value = false;
              homeCntrl.isRecentSelect.value = false;
              CheckInsertdata().selectPlayAnimationName =
                  "TerraModis-TrueColor";
            } else if (nowDate.isBefore(newValues.end) ||
                rangeEndDate.isAfter(nowDate)) {
              homeCntrl.isForcastRangeSelect.value = true;
              homeCntrl.isRecentSelect.value = false;
              if (CheckInsertdata().selectPlayAnimationName ==
                  "TerraModis-TrueColor") {
                CheckInsertdata().selectPlayAnimationName =
                    "Model-PM2.5(WRF-Chem)";
              }
            } else if (rangeStartDate.isAtSameMomentAs(nowDate) ||
                rangeEndDate.isAtSameMomentAs(nowDate)) {
              homeCntrl.isRecentSelect.value = true;
              CheckInsertdata().selectPlayAnimationName =
                  "TerraModis-TrueColor";
            }
            homeCntrl.endDate.value = newValues.end;
            // if (nowDate != start || nowDate != end) {
            //   homeCntrl.isForcastRangeSelect.value = true;
            // } else {
            //   homeCntrl.isForcastRangeSelect.value = false;
            // }
          },
        ),
      ),
    );
  }
}
