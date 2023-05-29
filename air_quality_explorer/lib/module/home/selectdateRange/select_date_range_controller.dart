// ignore_for_file: prefer_const_constructors

import 'package:air_quality_explorer/core/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SelectDateRangeController extends GetxController {
  var selectedFromDate = ''.obs;
  var selectedtoDate = ''.obs;
  var selectedTabIndex = 0.obs;
  selectfromDate() async {
    DateTime? pickedDate = await showDatePicker(
        builder: (context, child) {
          return Theme(
              data: ThemeData(
                colorScheme: const ColorScheme.light(
                  primary: AppColor.appButtonColor,
                ),
              ),
              child: child ?? const Text(""));
        },
        context: Get.context!,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 0)),
        lastDate: DateTime(2050));
    if (pickedDate != null) {
      var temp = DateFormat("dd-MM-yyyy").format(pickedDate);
      selectedFromDate.value = temp;
    }
  }

  selectToDate() async {
    DateTime? pickedDate = await showDatePicker(
        builder: (context, child) {
          return Theme(
              data: ThemeData(
                colorScheme: const ColorScheme.light(
                  primary: AppColor.appButtonColor,
                ),
              ),
              child: child ?? Text(""));
        },
        context: Get.context!,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 0)),
        lastDate: DateTime(2050));
    if (pickedDate != null) {
      var temp = DateFormat("dd-MM-yyyy").format(pickedDate);
      selectedtoDate.value = temp;
    }
  }
}
