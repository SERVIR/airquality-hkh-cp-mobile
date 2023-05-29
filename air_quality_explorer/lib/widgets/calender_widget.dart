// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, prefer_final_fields

import 'package:air_quality_explorer/core/color.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({
    Key? key,
  }) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DatePickerController _dateRowController = DatePickerController();
  static final now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return DatePicker(
      DateTime(now.year, now.month, now.day),

      width: 45,
      controller: _dateRowController,
      initialSelectedDate: DateTime(now.year, now.month, now.day),
      selectionColor: AppColor.appButtonColor,
      selectedTextColor: AppColor.appPrimaryColor,
      // deactivatedColor: kRedColor,
      dateTextStyle: Theme.of(context)
          .textTheme
          .displayLarge!
          .copyWith(fontSize: 22, fontWeight: FontWeight.w700),
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
