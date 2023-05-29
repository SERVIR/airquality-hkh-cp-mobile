// ignore_for_file: must_be_immutable

import 'package:air_quality_explorer/core/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShareButtonBottomSheetWidget extends StatelessWidget {
  ShareButtonBottomSheetWidget({Key? key, required this.callback})
      : super(key: key);

  Function(bool selectValue) callback;

  var shareNameList = [
    'Print Chart',
    'Download PNG Image',
    'Download JPEG Image',
    'Download PDF Document',
    'Download SVG',
    'Download CSV',
    'Download XLS'
  ].obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.size.height * 0.55,
      width: Get.size.width,
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 32,
          left: 32,
          right: 10,
        ),
        child: ListView.builder(
          itemCount: shareNameList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Get.back();
                    callback(true);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      shareNameList[index],
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: AppColor.appTextColor,
                          ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
