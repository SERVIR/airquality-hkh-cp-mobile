import 'package:air_quality_explorer/core/color.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';

class DayAfterDateWidget extends StatelessWidget {
  const DayAfterDateWidget({
    Key? key,
    required this.now,
    required this.dateRowController,
  }) : super(key: key);

  final DateTime now;
  final DatePickerController dateRowController;

  @override
  Widget build(BuildContext context) {
    return DatePicker(
      // DateT0ime(controller.now.year, controller.now.month,
      // controller.now.day),
      DateTime(now.year, now.month, now.day + 0),
      width: 45,
      daysCount: 3,
      controller: dateRowController,
      initialSelectedDate: DateTime.now(),
      selectionColor: AppColor.appButtonColor,
      selectedTextColor: AppColor.appPrimaryColor,
      // deactivatedColor: kRedColor,
      dateTextStyle: Theme.of(context)
          .textTheme
          .displayLarge!
          .copyWith(fontSize: 12, fontWeight: FontWeight.w700),
      dayTextStyle: Theme.of(context)
          .textTheme
          .displayLarge!
          .copyWith(fontSize: 11, fontWeight: FontWeight.w400),
      monthTextStyle:
          Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 10),
      onDateChange: (date) {},
    );
  }
}
