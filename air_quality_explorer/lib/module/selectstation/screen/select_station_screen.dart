// ignore_for_file: unrelated_type_equality_checks

import 'package:air_quality_explorer/core/color.dart';
import 'package:air_quality_explorer/database/check_insertdata.dart';
import 'package:air_quality_explorer/models/chart_data.dart';
import 'package:air_quality_explorer/models/save_location_recent_response_model.dart';
import 'package:air_quality_explorer/module/selectstation/controller/select_station_screen_controller.dart';
import 'package:air_quality_explorer/widgets/vector_meter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// ignore: must_be_immutable
class SelectStationScreen extends StatefulWidget {
  String? stationId;
  String? stationName;
  String pollutantTypeNm;
  String modelClass;
  String modelClassList;
  String source;
  List<Geo>? pollutantLayerList;
  int selectIndex;
  RxBool? isForecast;
  bool isUserSaved;
  SelectStationScreen(
      {super.key,
      this.stationId,
      this.stationName,
      required this.modelClass,
      required this.modelClassList,
      required this.pollutantTypeNm,
      required this.source,
      this.pollutantLayerList,
      required this.selectIndex,
      this.isForecast,
      this.isUserSaved = false});

  @override
  State<SelectStationScreen> createState() => _SelectStationScreenState();
}

class _SelectStationScreenState extends State<SelectStationScreen> {
  final controller = Get.put(SelectStationScreenController());

  @override
  void initState() {
    controller.selectedIndex.value = widget.selectIndex;
    controller.isToday.value = true;
    controller.isPM2Selected.value = true;
    controller.selectPollutantLayer.value =
        widget.pollutantLayerList?[widget.selectIndex].name ?? "";
    // controller.getGroundObservationData(widget.stationId ?? "",
    //     widget.pollutantTypeNm, widget.modelClass, widget.modelClassList);
    controller.aquiMeterValue.value =
        widget.pollutantLayerList?[widget.selectIndex].value?[1] ?? 0.0;
    controller.getTitleMessage(
        cp: widget.pollutantLayerList?[widget.selectIndex].value?[1] ?? 0.0,
        pollutantType:
            widget.pollutantLayerList?[widget.selectIndex].name ?? "");
    if (widget.isForecast?.value != true) {
      controller.getSliceCataLogApi(
          latitude: widget.pollutantLayerList?[widget.selectIndex].latitude,
          longitude: widget.pollutantLayerList?[widget.selectIndex].longitude,
          tempPollutantType:
              widget.pollutantLayerList?[widget.selectIndex].name);
    } else {
      controller.getXmlDataAndForecastApiCall(
        layername: widget.pollutantLayerList?[widget.selectIndex].name ?? "",
        latitude:
            widget.pollutantLayerList?[widget.selectIndex].latitude ?? 0.0,
        longitude:
            widget.pollutantLayerList?[widget.selectIndex].longitude ?? 0.0,
      );
    }

    controller.showMAxAqiValue(widget.pollutantLayerList ?? []);

    /* controller.aqiValueCalculation(
        widget.pollutantLayerList?[widget.selectIndex].value?[1] ?? 0.0,
        "PM2.5"); */
    super.initState();

    // CheckInsertdata().initialise();
    // CheckInsertdata().myStream.listen((source) {
    //   _source = source;

    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    CheckInsertdata().disposeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const SizedBox(
            height: 40,
            width: 40,
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 15,
              color: AppColor.appbarbackIconColor,
            ),
          ),
        ),
        title: Text(
          "selectedStation".tr,
          style: Theme.of(context).textTheme.displayMedium!,
        ),
      ),
      body: /*  Obx(
        () => CheckInsertdata().noInternet.value == false
            ? Center(
                child: Lottie.asset('assets/json/noInternet.json',
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: MediaQuery.of(context).size.height * 0.35),
              )
            : */
          Stack(
        children: [
          ListView(
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.stationName ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.appbarTextColor,
                                        fontSize: 20.w,
                                        fontFamily: 'Poppins'),
                              ),
                              // const Spacer(),
                            ],
                          ),
                          Obx(
                            () => Text(
                              "Source : ${widget.isForecast == true ? "WRF-CHEM" : controller.selectedIndex.value == 0 ? widget.isUserSaved == true ? "GEOS" : "AirNow" : "GEOS"}",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      /*  GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialogBoxWidget(
                                alrtTitle: "doUWantDelete".tr,
                                alertFirstButtonNm: "delete".tr,
                                firstBtnTap: () {
                                  Get.back();
                                },
                              ),
                            );
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.red, shape: BoxShape.circle),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5),
                                child: SvgPicture.asset(
                                  AppImages.deleteIcon,
                                  height: Get.height * 0.028,
                                )),
                          ),
                        )
                       */
                    ],
                  )),
              /* Obx(
                  () =>  */
              VectorMeterWidget(
                aqiMeterValue:
                    controller.finalCalculationAqiMeterValue.obs.value,
                pollutantType: controller.selectPollutantLayer.obs.value,
              ),
              // ),

              Obx(
                () => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Primary Pollutant : ${controller.savelocationMaximumPollutantValue.value} ${controller.showMaxAqiPollutantNm.value}",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.black),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                child: SizedBox(
                  height: Get.size.height * 0.06,
                  width: Get.size.width,
                  child: ListView.builder(
                      controller: controller.scrollController,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: widget.pollutantLayerList?.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              right: 5, left: 5, bottom: 5, top: 5),
                          child: TopSliderMenu(
                            title: widget.pollutantLayerList?[index].name ?? "",
                            isSelected: controller.isPM2Selected.value,
                            ontap: () {
                              controller.selectedIndex.value = index;
                              controller.selectPollutantLayer.value =
                                  widget.pollutantLayerList?[index].name ?? "";
                              controller.isLoading.value = true;
                              controller.dataSource.clear();
                              if (widget.isForecast?.value != true) {
                                controller.getSliceCataLogApi(
                                    latitude: widget
                                        .pollutantLayerList?[index].latitude,
                                    longitude: widget
                                        .pollutantLayerList?[index].longitude,
                                    tempPollutantType:
                                        widget.pollutantLayerList?[index].name);
                              } else {
                                controller.getXmlDataAndForecastApiCall(
                                  layername:
                                      widget.pollutantLayerList?[index].name ??
                                          "",
                                  latitude: widget
                                          .pollutantLayerList?[
                                              widget.selectIndex]
                                          .latitude ??
                                      0.0,
                                  longitude: widget
                                          .pollutantLayerList?[
                                              widget.selectIndex]
                                          .longitude ??
                                      0.0,
                                );
                              }

                              controller.getTitleMessage(
                                  cp: widget.pollutantLayerList?[index]
                                          .value?[1] ??
                                      0.0,
                                  pollutantType:
                                      widget.pollutantLayerList?[index].name ??
                                          "");
                              // controller.getGroundObservationData(
                              //     widget.stationId ?? "",
                              //     widget.pollutantTypeNm,
                              //     widget.modelClass,
                              //     widget.modelClassList);
                              controller.aquiMeterValue.value =
                                  widget.pollutantLayerList?[index].value?[1] ??
                                      0.0;
                              // controller.aqiValueCalculation(
                              //     double.parse(widget.pollutantLayerList?[index]
                              //             .getDecimalValue() ??
                              //         ''),
                              //     "PM2.5");
                            },
                            index: index,
                            selectedIndex: controller.selectedIndex.obs.value,
                          ),
                        );
                      }),
                ),
              ),

              /* Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TopSliderMenu(
                            title: "PM 2.5",
                            isSelected: controller.isPM2Selected.value,
                            ontap: () {
                              controller.isPM2Selected.value = true;
                              controller.isO3Selected.value = false;
                              controller.isSO2Selected.value = false;
                              controller.getGroundObservationData(
                                  widget.stationId ?? "",
                                  widget.pollutantTypeNm,
                                  widget.modelClass,
                                  widget.modelClassList);
                            }),
                        /* const SizedBox(width: 20),
                        TopSliderMenu(
                            title: "O3",
                            isSelected: controller.isO3Selected.value,
                            ontap: () {
                              controller.isPM2Selected.value = false;
                              controller.isO3Selected.value = true;
                              controller.isSO2Selected.value = false;
                              /*  controller.getGroundObservationData(
                                  widget.stationId ?? "", "O3"); */
                            }),
                        const SizedBox(width: 20),
                        TopSliderMenu(
                            title: "SO2",
                            isSelected: controller.isSO2Selected.value,
                            ontap: () {
                              controller.isPM2Selected.value = false;
                              controller.isO3Selected.value = false;
                              controller.isSO2Selected.value = true;
                              /* controller.getGroundObservationData(
                                  widget.stationId ?? "", "SO2"); */
                            }),
                        const SizedBox(width: 20), */
                      ],
                    ),
                  ),
                ),
                 */
              Obx(
                () => Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 10, top: 10, bottom: 10),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      // "healtStatement".tr,
                      controller.titleMessage.value,
                      style:
                          Theme.of(context).textTheme.displayMedium!.copyWith(
                                fontSize: 16.5,
                                fontWeight: FontWeight.w600,
                                // color: AppColor.appTextColor,
                              ),
                    ),
                  ),
                ),
              ),

              //// chart container
              Obx(
                () => controller.isLoading.value == true
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColor.appButtonColor,
                        ),
                      )
                    : controller.dataList.isEmpty
                        ? Center(
                            child: Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Text(
                              "No data available",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(fontSize: 20),
                            ),
                          ))
                        : SfCartesianChart(
                            primaryYAxis: CategoryAxis(
                              title: AxisTitle(
                                  text: controller.chartLeftLable(
                                      controller.selectPollutantLayer.value),
                                  alignment: ChartAlignment.center),
                            ),
                            primaryXAxis: CategoryAxis(
                              plotBands: [
                                PlotBand(
                                  start: DateFormat('HH:mm')
                                      .format(DateTime.now()),
                                  end: DateFormat('HH:mm')
                                      .format(DateTime.now()),
                                  borderColor: AppColor.appButtonColor,
                                  borderWidth: 1,
                                )
                              ],
                              title: AxisTitle(
                                  text: " Time (UTC)",
                                  alignment: ChartAlignment.center),
                            ),
                            tooltipBehavior: controller.tooltipBehavior,
                            series: <ChartSeries<ChartData, String>>[
                              SplineSeries<ChartData, String>(
                                  dataSource: controller.dataSource.obs.value,
                                  xValueMapper: (ChartData sales, _) =>
                                      DateFormat('dd/MM HH:mm')
                                          .format(sales.dateTime),
                                  yValueMapper: (ChartData sales, _) =>
                                      sales.yvalue,
                                  dataLabelSettings:
                                      const DataLabelSettings(isVisible: true))
                            ],
                          ),
              ),
              Center(
                  child: Obx(() => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                            "Start Date : ${controller.chartFromDate.value}  \nEnd Date : ${controller.chartToDate.value}",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                    fontSize: 17, fontWeight: FontWeight.w600)),
                      ))),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ],
      ),
      // ),
    );
  }
}

class TopSliderMenu extends StatelessWidget {
  final String title;
  final bool isSelected;
  final void Function() ontap;
  final int index;
  final RxInt selectedIndex;
  const TopSliderMenu({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.ontap,
    required this.index,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Obx(
        () => Container(
          height: Get.size.height * 0.04,
          width: Get.size.width * 0.2,
          decoration: BoxDecoration(
              color: index == selectedIndex.value
                  ? AppColor.appButtonColor
                  : AppColor.appPrimaryColor,
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [
                BoxShadow(
                    color: AppColor.shadowColor,
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: Offset(1, 2)),
              ]),
          child: Center(
            child: Text(
              title,
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontSize: 18,
                    fontWeight: index == selectedIndex.value
                        ? FontWeight.w600
                        : FontWeight.w500,
                    color: index != selectedIndex.value
                        ? AppColor.appButtonColor
                        : AppColor.appPrimaryColor,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
