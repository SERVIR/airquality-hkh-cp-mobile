// import 'package:air_quality_explorer/core/color.dart';
// import 'package:air_quality_explorer/core/images.dart';
// import 'package:air_quality_explorer/core/stringConst.dart';
// import 'package:air_quality_explorer/module/home/selectdateRange/select_date_range_controller.dart';
// import 'package:air_quality_explorer/widgets/outline_submit_button_widget.dart';
// import 'package:air_quality_explorer/widgets/submit_button_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';

// class SelectDateScreen extends StatelessWidget {
//   SelectDateScreen({super.key});

//   final controller = Get.put(SelectDateRangeController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.whiteColor,
//       appBar: AppBar(
//         backgroundColor: AppColor.whiteColor,
//         elevation: 0,
//         leading: InkWell(
//           onTap: () {
//             Get.back();
//           },
//           child: const SizedBox(
//             height: 40,
//             width: 40,
//             child: Icon(
//               Icons.arrow_back_ios_new_rounded,
//               size: 15,
//               color: AppColor.appbarbackIconColor,
//             ),
//           ),
//         ),
//         title: Text(
//           Str.selectDateRange,
//           style: Theme.of(context).textTheme.displayMedium!,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(left: 20, right: 20, top: 100),
//         child: Column(
//           children: [
//             Container(
//               height: Get.size.height * 0.075,
//               width: Get.size.width,
//               decoration: BoxDecoration(
//                 color: AppColor.lightBlueColor,
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 16, right: 5),
//                 child: Row(
//                   children: [
//                     Obx(
//                       () => Text(
//                         controller.selectedFromDate.value == ""
//                             ? "Select date"
//                             : controller.selectedFromDate.value,
//                         style: Theme.of(context).textTheme.displayMedium!.copyWith(
//                             fontSize: 16, color: AppColor.appTextColor),
//                       ),
//                     ),
//                     const Spacer(),
//                     InkWell(
//                       onTap: () {
//                         controller.selectfromDate();
//                       },
//                       child: SizedBox(
//                         height: 50,
//                         width: 50,
//                         child: Center(
//                           child: SvgPicture.asset(
//                             AppImages.calenderIcon,
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             Container(
//               height: Get.size.height * 0.075,
//               width: Get.size.width,
//               decoration: BoxDecoration(
//                 color: AppColor.lightBlueColor,
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 16, right: 5),
//                 child: Row(
//                   children: [
//                     Obx(
//                       () => Text(
//                         controller.selectedtoDate.value == ""
//                             ? "Select date"
//                             : controller.selectedtoDate.value,
//                         style: Theme.of(context).textTheme.displayMedium!.copyWith(
//                             fontSize: 16, color: AppColor.appTextColor),
//                       ),
//                     ),
//                     const Spacer(),
//                     InkWell(
//                       onTap: () {
//                         controller.selectToDate();
//                       },
//                       child: SizedBox(
//                         height: 50,
//                         width: 50,
//                         child: Center(
//                           child: SvgPicture.asset(
//                             AppImages.calenderIcon,
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             const Spacer(),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 OutlineSubmitButtonWidget(
//                   height: Get.size.height * 0.065,
//                   width: Get.size.height * 0.150,
//                   buttonNm: 'Cancel',
//                   onTap: () {
//                     Get.back();
//                   },
//                 ),
//                 SubmitButtonWidget(
//                   height: Get.size.height * 0.065,
//                   width: Get.size.height * 0.150,
//                   btnText: 'Apply',
//                   onTap: () {},
//                 ),
//               ],
//             ),
//             const SizedBox(
//               height: 50,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
