// import 'package:air_quality_explorer/core/color.dart';
// import 'package:air_quality_explorer/core/images.dart';
// import 'package:air_quality_explorer/core/stringConst.dart';
// import 'package:air_quality_explorer/module/home/controller/home_screen_controller.dart';
// import 'package:air_quality_explorer/widgets/alert_box_widget.dart';
// import 'package:air_quality_explorer/widgets/submit_button_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class AddLocationBottomSheetWidget extends StatelessWidget {
//   final HomeScreenController controller;
//   const AddLocationBottomSheetWidget({
//     Key? key,
//     required this.controller,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: Get.size.width,
//       height: Get.size.height * 0.56,
//       decoration: const BoxDecoration(
//         color: AppColor.appPrimaryColor,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(25),
//           topRight: Radius.circular(25),
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.only(top: 20),
//         child: Column(
//           children: [
//             Text(
//               Str.addLocations,
//               style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                   color: AppColor.redColor,
//                   fontSize: 15,
//                   fontWeight: FontWeight.w500,
//                   decoration: TextDecoration.underline),
//             ),
//             SizedBox(
//               height: Get.size.height * 0.017,
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 27),
//               child: Text(
//                 "addLoactionNotice".tr,
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context)
//                     .textTheme
//                     .displayLarge!
//                     .copyWith(fontSize: 13),
//               ),
//             ),
//             SizedBox(
//               height: Get.size.height * 0.022,
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 60),
//               child: Text(
//                 "addLoactionNotice2".tr,
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context)
//                     .textTheme
//                     .displayLarge!
//                     .copyWith(fontSize: 15, color: AppColor.appButtonColor),
//               ),
//             ),
//             SizedBox(
//               height: Get.size.height * 0.022,
//             ),
//             Container(
//               width: Get.size.width * 0.21,
//               height: Get.size.height * 0.17,
//               decoration: BoxDecoration(
//                 color: AppColor.appPrimaryColor,
//                 border: Border.all(color: AppColor.appButtonColor),
//                 borderRadius: BorderRadius.circular(20),
//                 image: const DecorationImage(
//                   image: AssetImage(AppImages.staticLocationIcon),
//                 ),
//               ),
//             ),
//             SizedBox(height: Get.size.height * 0.0135),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Obx(
//                   () => Checkbox(
//                     value: controller.isCheck.value,
//                     activeColor: AppColor.lighttextColor,
//                     onChanged: (bool? value) {
//                       controller.isCheck.value = value!;
//                     },
//                   ),
//                 ),
//                 Text(
//                   "dontShowAgain".tr,
//                   style: Theme.of(context)
//                       .textTheme
//                       .displayLarge!
//                       .copyWith(color: AppColor.appButtonColor),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: Get.size.height * 0.027,
//             ),
//             SubmitButtonWidget(
//               height: Get.size.height * 0.062,
//               width: Get.size.width * 0.26,
//               btnText: "ok".tr,
//               onTap: () {
//                 Get.back();
//                 showDialog(
//                   context: context,
//                   builder: (context) => AlertDialogBoxWidget(
//                     controller: ,
//                     alrtTitle: "searchPlaceNaddLocation".tr,
//                     alertFirstButtonNm: "ok".tr,
//                     firstBtnTap: () {
//                       controller.isSearch.value = true;
//                       Get.back();
//                     },
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
