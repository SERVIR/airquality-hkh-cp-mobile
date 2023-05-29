// ignore_for_file: file_names

import 'package:air_quality_explorer/core/color.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';

class TomorrowDateWidget extends StatelessWidget {
  const TomorrowDateWidget({
    Key? key,
    required this.now,
    required this.dateRowController,
  }) : super(key: key);

  final DateTime now;
  final DatePickerController dateRowController;

  @override
  Widget build(BuildContext context) {
    return DatePicker(
      DateTime(now.year, now.month, now.day - 6),
      width: 45,
      daysCount: 7,
      controller: dateRowController,
      initialSelectedDate: DateTime.now(),
      selectionColor: AppColor.appButtonColor,
      selectedTextColor: AppColor.appPrimaryColor,
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
