import 'package:air_quality_explorer/core/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class AlertDialogBoxWidget extends StatelessWidget {
  String? cityNM;
  String? lat;
  String? long;
  final String alrtTitle;
  final String alertFirstButtonNm;
  final Function yesBtnTap;
  final Function noBtnTap;
  TextEditingController controller;
  RxBool isLoading;

  AlertDialogBoxWidget({
    Key? key,
    required this.alrtTitle,
    required this.alertFirstButtonNm,
    required this.yesBtnTap,
    required this.noBtnTap,
    this.cityNM,
    this.lat,
    this.long,
    required this.controller,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor.alertBgColor,
      actions: [
        Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              child: InkWell(
                onTap: () {
                  noBtnTap();
                },
                child: Container(
                  height: 20.h,
                  width: 20.h,
                  decoration: BoxDecoration(
                      color: AppColor.appButtonColor,
                      borderRadius: BorderRadius.circular(50)),
                  child: const Center(
                      child: Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: AppColor.whiteColor,
                  )),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /* cityNM == ""
                      ? Container()
                      : RichText(
                          text: TextSpan(
                            text: "CITY : ",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                text: cityNM ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .copyWith(
                                      fontSize: 15,
                                    ),
                              ),
                            ],
                          ),
                        ),
                  const SizedBox(
                    height: 10,
                  ), */
                  Container(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        text: "LAT : ",
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: lat ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                  fontSize: 15,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        text: "LONG : ",
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: long ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                  fontSize: 15,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      alrtTitle,
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            fontSize: 15,
                          ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: Get.size.height * 0.064,
                    width: Get.size.width * 0.76,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColor.appButtonColor, width: 1),
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextFormField(
                        controller: controller,
                        cursorColor: AppColor.appButtonColor,
                        decoration: const InputDecoration(
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,

                            /* enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: AppColor.appButtonColor)),
                            errorBorder: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: AppColor.appButtonColor)), */
                            hintText: '“My Home” or “My Office”'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            /*  TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                "cancel".tr,
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontSize: 16,
                      color: AppColor.appButtonColor,
                    ),
              ),
            ),
            */
            Obx(
              () => TextButton(
                onPressed: () {
                  yesBtnTap();
                },
                child: isLoading.value == true
                    ? const CircularProgressIndicator(
                        color: AppColor.appButtonColor,
                        strokeWidth: 2,
                      )
                    : Text(
                        alertFirstButtonNm,
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontSize: 16,
                                  color: AppColor.appButtonColor,
                                ),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Delete Alert box widget
// ignore: must_be_immutable
class DeleteAlertDailog extends StatelessWidget {
  final String alrtTitle;
  final String alertFirstButtonNm;
  final Function firstBtnTap;
  RxBool isLoading;

  DeleteAlertDailog({
    Key? key,
    required this.alrtTitle,
    required this.alertFirstButtonNm,
    required this.firstBtnTap,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Center(child: Text("Delete Location")),
      content: Text(
        alrtTitle,
      ),
      actions: [
        CupertinoDialogAction(
            child: Text(alertFirstButtonNm),
            onPressed: () {
              firstBtnTap();
            }),
        CupertinoDialogAction(
            child: const Text('No'),
            onPressed: () {
              Get.back();
            }),
      ],
    );
  }
}

/// Show information dialog
class InformationAlertDialog extends StatelessWidget {
  final String alrtTitle;
  final String alertFirstButtonNm;
  final Function firstBtnTap;

  const InformationAlertDialog({
    Key? key,
    required this.alrtTitle,
    required this.alertFirstButtonNm,
    required this.firstBtnTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Center(
          child: Text(
        alrtTitle,
        style: Theme.of(context)
            .textTheme
            .displayMedium!
            .copyWith(fontSize: 17, fontWeight: FontWeight.w500),
      )),
      // content: Text(
      //   alrtTitle,
      // ),
      actions: [
        CupertinoDialogAction(
            child: Text(alertFirstButtonNm),
            onPressed: () {
              firstBtnTap();
            }),
      ],
    );
  }
}
