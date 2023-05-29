// import 'package:air_quality_explorer/core/color.dart';
// import 'package:air_quality_explorer/core/images.dart';
// import 'package:air_quality_explorer/core/stringConst.dart';
// import 'package:air_quality_explorer/module/selectstation/chart_screen_controller.dart';
// import 'package:air_quality_explorer/module/savelocation/save_location_screen.dart';
// import 'package:air_quality_explorer/widgets/archive_data_date_widget.dart';
// import 'package:air_quality_explorer/widgets/forecast_data_date_widget.dart';
// import 'package:air_quality_explorer/widgets/recent_data_date_widget.dart';
// import 'package:air_quality_explorer/widgets/share_button_bottom_sheet.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// class ChartScreen extends StatelessWidget {
//   ChartScreen({super.key});

//   final controller = Get.put(ChartScreenController());

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
//           Str.chart,
//           style: Theme.of(context).textTheme.displayMedium!,
//         ),
//       ),
//       body: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
//             child: ListView(
//               // crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       "Kathmandu",
//                       style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                           fontWeight: FontWeight.w600,
//                           color: AppColor.appbarTextColor,
//                           fontSize: 22),
//                     ),
//                     const Spacer(),
//                     InkWell(
//                       onTap: () {
//                         Get.to(SaveLocationScreen());
//                       },
//                       child: SvgPicture.asset(AppImages.saveIcon),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 6,
//                 ),
//                 RichText(
//                   text: TextSpan(
//                     text: 'Source : AirNow ',
//                     style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                         fontSize: 14,
//                         color: AppColor.appTextColor,
//                         fontWeight: FontWeight.w400),
//                     children: <TextSpan>[
//                       TextSpan(
//                         text: '(Past 24 Hours)',
//                         style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                             fontSize: 14,
//                             color: AppColor.appButtonColor,
//                             fontWeight: FontWeight.w400),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 16,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         controller.isArchive.value = true;
//                         controller.isRecent.value = false;
//                         controller.isForecast.value = false;
//                       },
//                       child: Obx(
//                         () => Column(
//                           children: [
//                             Text(
//                               Str.archive,
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .displayLarge!
//                                   .copyWith(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w500),
//                             ),
//                             Container(
//                               height: Get.size.height * 0.005,
//                               width: Get.size.width * 0.15,
//                               decoration: BoxDecoration(
//                                   color: controller.isArchive.value == true
//                                       ? AppColor.appButtonColor
//                                       : AppColor.whiteColor,
//                                   borderRadius: BorderRadius.circular(50)),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     InkWell(
//                       onTap: () {
//                         controller.isRecent.value = true;
//                         controller.isForecast.value = false;
//                         controller.isArchive.value = false;
//                       },
//                       child: Obx(
//                         () => Column(
//                           children: [
//                             Text(
//                               Str.recent,
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .displayLarge!
//                                   .copyWith(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w500),
//                             ),
//                             Container(
//                               height: Get.size.height * 0.005,
//                               width: Get.size.width * 0.15,
//                               decoration: BoxDecoration(
//                                   color: controller.isRecent.value == true
//                                       ? AppColor.appButtonColor
//                                       : AppColor.whiteColor,
//                                   borderRadius: BorderRadius.circular(50)),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     InkWell(
//                       onTap: () {
//                         controller.isForecast.value = true;
//                         controller.isRecent.value = false;
//                         controller.isArchive.value = false;
//                       },
//                       child: Obx(
//                         () => Column(
//                           children: [
//                             Text(
//                               Str.forecast,
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .displayLarge!
//                                   .copyWith(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w500),
//                             ),
//                             Container(
//                               height: Get.size.height * 0.005,
//                               width: Get.size.width * 0.15,
//                               decoration: BoxDecoration(
//                                   color: controller.isForecast.value == true
//                                       ? AppColor.appButtonColor
//                                       : AppColor.whiteColor,
//                                   borderRadius: BorderRadius.circular(50)),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Obx(
//                   () => SizedBox(
//                       height: Get.size.height * 0.12,
//                       width: Get.size.width,
//                       child: controller.isArchive.value == true
//                           ? ArchiveDateWidget(
//                               now: controller.now,
//                               dateRowController: controller.dateRowController)
//                           : controller.isForecast.value == true
//                               ? ForecastDateWidget(
//                                   now: controller.now,
//                                   dateRowController:
//                                       controller.dateRowController)
//                               : RecentDateWidget(
//                                   now: controller.now,
//                                   dateRowController:
//                                       controller.dateRowController)),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 SfCartesianChart(
//                   primaryXAxis: CategoryAxis(),
//                   // legend: Legend(isVisible: true),
//                   tooltipBehavior: controller.tooltipBehavior,
//                   series: <LineSeries<SalesData, String>>[
//                     LineSeries<SalesData, String>(
//                         dataSource: <SalesData>[
//                           SalesData('Jan', 35),
//                           SalesData('Feb', 28),
//                           SalesData('Mar', 34),
//                           SalesData('Apr', 32),
//                           SalesData('May', 40)
//                         ],
//                         xValueMapper: (SalesData sales, _) => sales.year,
//                         yValueMapper: (SalesData sales, _) => sales.sales,
//                         dataLabelSettings:
//                             const DataLabelSettings(isVisible: true))
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 20),
//                   child: Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: SizedBox(
//                       height: 179,
//                       width: Get.size.width,
//                       child: Padding(
//                         padding: const EdgeInsets.only(
//                             left: 30, top: 25, right: 10, bottom: 25),
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 SizedBox(
//                                   height: 47,
//                                   child: Column(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceAround,
//                                     children: [
//                                       SizedBox(
//                                         width: Get.size.width * 0.1,
//                                         child: Text(
//                                           "27",
//                                           textAlign: TextAlign.center,
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .displayLarge!
//                                               .copyWith(
//                                                   fontWeight: FontWeight.w700,
//                                                   color: AppColor.appTextColor,
//                                                   fontSize: 20),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: Get.size.width * 0.1,
//                                         child: Text(
//                                           "PM10",
//                                           textAlign: TextAlign.center,
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .displayLarge!
//                                               .copyWith(
//                                                   fontWeight: FontWeight.w500,
//                                                   color: AppColor.appTextColor,
//                                                   fontSize: 11),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   width: 2,
//                                 ),
//                                 Container(
//                                   height: 47,
//                                   width: 4,
//                                   decoration: BoxDecoration(
//                                     color: AppColor.greayColor,
//                                     borderRadius: BorderRadius.circular(50),
//                                   ),
//                                   child: FAProgressBar(
//                                     direction: Axis.vertical,
//                                     progressColor: AppColor.redColor,
//                                     verticalDirection: VerticalDirection.up,
//                                     currentValue: 40,
//                                   ),
//                                 ),
//                                 const Spacer(),

//                                 /// Second container
//                                 SizedBox(
//                                   height: 47,
//                                   child: Column(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceAround,
//                                     children: [
//                                       SizedBox(
//                                         width: Get.size.width * 0.1,
//                                         child: Text(
//                                           "34",
//                                           textAlign: TextAlign.center,
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .displayLarge!
//                                               .copyWith(
//                                                   fontWeight: FontWeight.w700,
//                                                   color: AppColor.appTextColor,
//                                                   fontSize: 20),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: Get.size.width * 0.1,
//                                         child: Text(
//                                           "NOx",
//                                           textAlign: TextAlign.center,
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .displayLarge!
//                                               .copyWith(
//                                                   fontWeight: FontWeight.w500,
//                                                   color: AppColor.appTextColor,
//                                                   fontSize: 11),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   width: 5,
//                                 ),
//                                 Container(
//                                   height: 47,
//                                   width: 4,
//                                   decoration: BoxDecoration(
//                                     color: AppColor.greayColor,
//                                     borderRadius: BorderRadius.circular(50),
//                                   ),
//                                   child: FAProgressBar(
//                                     direction: Axis.vertical,
//                                     progressColor: AppColor.orangeColor,
//                                     verticalDirection: VerticalDirection.up,
//                                     currentValue: 60,
//                                   ),
//                                 ),
//                                 const Spacer(),

//                                 /// Third container
//                                 SizedBox(
//                                   height: 47,
//                                   child: Column(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceAround,
//                                     children: [
//                                       SizedBox(
//                                         width: Get.size.width * 0.1,
//                                         child: Text(
//                                           "26",
//                                           textAlign: TextAlign.center,
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .displayLarge!
//                                               .copyWith(
//                                                   fontWeight: FontWeight.w700,
//                                                   color: AppColor.appTextColor,
//                                                   fontSize: 20),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: Get.size.width * 0.1,
//                                         child: Text(
//                                           "BC",
//                                           textAlign: TextAlign.center,
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .displayLarge!
//                                               .copyWith(
//                                                   fontWeight: FontWeight.w500,
//                                                   color: AppColor.appTextColor,
//                                                   fontSize: 11),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   width: 5,
//                                 ),
//                                 Container(
//                                   height: 47,
//                                   width: 4,
//                                   decoration: BoxDecoration(
//                                     color: AppColor.greayColor,
//                                     borderRadius: BorderRadius.circular(50),
//                                   ),
//                                   child: FAProgressBar(
//                                     direction: Axis.vertical,
//                                     progressColor: AppColor.blueColor,
//                                     verticalDirection: VerticalDirection.up,
//                                     currentValue: 40,
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   width: 20,
//                                 ),
//                               ],
//                             ),
//                             const Spacer(),
//                             Row(
//                               children: [
//                                 /// Four container
//                                 SizedBox(
//                                   height: 47,
//                                   child: Column(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceAround,
//                                     children: [
//                                       SizedBox(
//                                         width: Get.size.width * 0.1,
//                                         child: Text(
//                                           "36",
//                                           textAlign: TextAlign.center,
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .displayLarge!
//                                               .copyWith(
//                                                   fontWeight: FontWeight.w700,
//                                                   color: AppColor.appTextColor,
//                                                   fontSize: 20),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: Get.size.width * 0.1,
//                                         child: Text(
//                                           "SO2",
//                                           textAlign: TextAlign.center,
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .displayLarge!
//                                               .copyWith(
//                                                   fontWeight: FontWeight.w500,
//                                                   color: AppColor.appTextColor,
//                                                   fontSize: 11),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   width: 5,
//                                 ),
//                                 Container(
//                                   height: 47,
//                                   width: 4,
//                                   decoration: BoxDecoration(
//                                     color: AppColor.greayColor,
//                                     borderRadius: BorderRadius.circular(50),
//                                   ),
//                                   child: FAProgressBar(
//                                     direction: Axis.vertical,
//                                     progressColor: AppColor.greenColor,
//                                     verticalDirection: VerticalDirection.up,
//                                     currentValue: 40,
//                                   ),
//                                 ),
//                                 const Spacer(),

//                                 /// Five container
//                                 SizedBox(
//                                   height: 47,
//                                   child: Column(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceAround,
//                                     children: [
//                                       SizedBox(
//                                         width: Get.size.width * 0.1,
//                                         child: Text(
//                                           "45",
//                                           textAlign: TextAlign.center,
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .displayLarge!
//                                               .copyWith(
//                                                   fontWeight: FontWeight.w700,
//                                                   color: AppColor.appTextColor,
//                                                   fontSize: 20),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: Get.size.width * 0.1,
//                                         child: Text(
//                                           "OC",
//                                           textAlign: TextAlign.center,
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .displayLarge!
//                                               .copyWith(
//                                                   fontWeight: FontWeight.w500,
//                                                   color: AppColor.appTextColor,
//                                                   fontSize: 11),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   width: 5,
//                                 ),
//                                 Container(
//                                   height: 47,
//                                   width: 4,
//                                   decoration: BoxDecoration(
//                                     color: AppColor.greayColor,
//                                     borderRadius: BorderRadius.circular(50),
//                                   ),
//                                   child: FAProgressBar(
//                                     direction: Axis.vertical,
//                                     progressColor: AppColor.purpleColor,
//                                     verticalDirection: VerticalDirection.up,
//                                     currentValue: 50,
//                                   ),
//                                 ),
//                                 const Spacer(),

//                                 /// Six container
//                                 SizedBox(
//                                   height: 47,
//                                   child: Column(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceAround,
//                                     children: [
//                                       SizedBox(
//                                         width: Get.size.width * 0.1,
//                                         child: Text(
//                                           "54",
//                                           textAlign: TextAlign.center,
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .displayLarge!
//                                               .copyWith(
//                                                   fontWeight: FontWeight.w700,
//                                                   color: AppColor.appTextColor,
//                                                   fontSize: 20),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: Get.size.width * 0.1,
//                                         child: Text(
//                                           "CO",
//                                           textAlign: TextAlign.center,
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .displayLarge!
//                                               .copyWith(
//                                                   fontWeight: FontWeight.w500,
//                                                   color: AppColor.appTextColor,
//                                                   fontSize: 11),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   width: 5,
//                                 ),
//                                 Container(
//                                   height: 47,
//                                   width: 4,
//                                   decoration: BoxDecoration(
//                                     color: AppColor.greayColor,
//                                     borderRadius: BorderRadius.circular(50),
//                                   ),
//                                   child: FAProgressBar(
//                                     direction: Axis.vertical,
//                                     progressColor: AppColor.skyColor,
//                                     verticalDirection: VerticalDirection.up,
//                                     currentValue: 30,
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   width: 20,
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             bottom: 15,
//             right: 15,
//             child: InkWell(
//               onTap: () {
//                 Get.bottomSheet(ShareButtonBottomSheetWidget(
//                   callback: (bool selectValue) {},
//                 ));
//               },
//               child: Container(
//                 height: 55,
//                 width: 55,
//                 decoration: BoxDecoration(
//                   color: AppColor.appButtonLightColor,
//                   borderRadius: BorderRadius.circular(50),
//                 ),
//                 child: Center(child: SvgPicture.asset(AppImages.uploadIcon)),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
