// ignore_for_file: must_be_immutable

import 'package:air_quality_explorer/core/color.dart';
import 'package:air_quality_explorer/core/images.dart';
import 'package:air_quality_explorer/models/save_location_recent_response_model.dart';
import 'package:air_quality_explorer/module/savelocation/controller/save_location_screen_controller.dart';
import 'package:air_quality_explorer/module/selectstation/screen/select_station_screen.dart';
import 'package:air_quality_explorer/widgets/alert_box_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SaveLocationScreen extends StatefulWidget {
  const SaveLocationScreen({super.key});

  @override
  State<SaveLocationScreen> createState() => _SaveLocationScreenState();
}

class _SaveLocationScreenState extends State<SaveLocationScreen>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(SaveLocationScreenController());

  // @override
  // bool get wantKeepAlive => true;

  @override
  void initState() {
    controller.tabController = TabController(length: 2, vsync: this);
    controller.getAllList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: AppColor.whiteColor,
          appBar: AppBar(
            backgroundColor: AppColor.whiteColor,
            elevation: 0,
            title: Text(
              "saveLocation".tr,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            actions: [
              Obx(
                () => controller.saveLocationSqlDbList.isEmpty
                    ? Container()
                    : controller.isDeleteSaveLocationSelectBtn.value == true
                        ? InkWell(
                            onTap: () {
                              controller.isDeleteSaveLocationSelectBtn.value =
                                  false;
                              controller.savelocationSelected.value = false;
                              controller.isSelectedsaveLocationValue.clear();
                            },
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: Center(
                                child: SvgPicture.asset(AppImages.crossIcon),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(
                                top: 10, right: 10, bottom: 10),
                            child: Container(
                              width: Get.size.width * 0.23,
                              decoration: BoxDecoration(
                                  color: AppColor.appPrimaryColor,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: AppColor.appButtonColor)),
                              child: InkWell(
                                onTap: () {
                                  controller.isDeleteSaveLocationSelectBtn
                                      .value = true;
                                },
                                child: Center(
                                  child: Text(
                                    "Select",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge!
                                        .copyWith(
                                            fontSize: 15,
                                            color: AppColor.appbarTextColor,
                                            fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                          ),
              ),
            ],
            bottom: TabBar(
              controller: controller.tabController,
              indicatorColor: Colors.transparent,
              onTap: (index) {
                controller.tabIndex.value = index;
                controller.savelocationSelected.value = false;
                if (index == 0) {
                  controller.isForecastTabSelect.value = false;
                  controller.isDeleteSaveLocationSelectBtn.value = false;
                  controller.isSelectedsaveLocationValue.clear();
                  controller.getAllSqlListRecent();
                  controller.getSaveRecentApiResponse(
                      controller.currentLatitude.value,
                      controller.currentLongitude.value);
                } else {
                  controller.isForecastTabSelect.value = true;
                  controller.isDeleteSaveLocationSelectBtn.value = false;
                  controller.isSelectedsaveLocationValue.clear();
                  controller.getAllSqlListForecast();
                  controller.getSaveForcasteApiResponse(
                      controller.currentLatitude.value,
                      controller.currentLongitude.value);
                }
              },
              tabs: [
                Tab(
                  child: Obx(
                    () => Container(
                      height: Get.size.height,
                      width: Get.size.width,
                      decoration: BoxDecoration(
                          color: controller.tabIndex.value == 0
                              ? AppColor.appButtonColor
                              : AppColor.greayColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                        child: Text(
                          "recent".tr,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: controller.tabIndex.value == 0
                                      ? AppColor.whiteColor
                                      : Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Obx(
                    () => Container(
                      height: Get.size.height,
                      width: Get.size.width,
                      decoration: BoxDecoration(
                          color: controller.tabIndex.value == 1
                              ? AppColor.appButtonColor
                              : AppColor.greayColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                        child: Text(
                          "forecast".tr,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: controller.tabIndex.value == 1
                                      ? AppColor.whiteColor
                                      : Colors.black),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          body: TabBarView(
              controller: controller.tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, bottom: 0, top: 5),
                    child: Stack(
                      children: [
                        //// Save location Sql data
                        ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              child: Text(
                                "saveLocationScreenMessageRecent".tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(letterSpacing: 0.8, fontSize: 17),
                              ),
                            ),

                            Obx(
                              () => controller.deleteLocationLoading.value ==
                                      true
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                          color: AppColor.appButtonColor))
                                  : ListView.builder(
                                      itemCount: controller
                                          .userAddRecentLocationList.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        var data = controller
                                            .userAddRecentLocationList[index];
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: Obx(
                                            () => Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    width: Get.size.width,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color: controller
                                                                .isSelectedsaveLocationValue
                                                                .contains(index)
                                                            ? Colors.black26
                                                            : AppColor
                                                                .appPrimaryColor),
                                                    child: InkWell(
                                                      onTap: () {
                                                        if (controller
                                                                .isDeleteSaveLocationSelectBtn
                                                                .value !=
                                                            true) {
                                                        } else {
                                                          controller
                                                                  .isSelectIndex
                                                                  .value =
                                                              index + 1;
                                                          controller.isSelectedsaveLocationValue
                                                                      .contains(
                                                                          index) ==
                                                                  false
                                                              ? controller
                                                                  .isSelectedsaveLocationValue
                                                                  .add(index)
                                                              : controller
                                                                  .isSelectedsaveLocationValue
                                                                  .remove(
                                                                      index);
                                                        }
                                                        if (controller
                                                            .isSelectedsaveLocationValue
                                                            .isNotEmpty) {
                                                          controller
                                                              .savelocationSelected
                                                              .value = true;
                                                        } else {
                                                          controller
                                                              .savelocationSelected
                                                              .value = false;
                                                        }
                                                      },
                                                      child: Stack(
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        20.w,
                                                                    vertical:
                                                                        20.h),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SizedBox(
                                                                  height: 58.h,
                                                                  child: Row(
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            data.site ??
                                                                                "",
                                                                            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                                                                                fontWeight: FontWeight.w600,
                                                                                color: AppColor.appbarTextColor,
                                                                                fontSize: 20.sp,
                                                                                fontFamily: 'Poppins'),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: Get
                                                                          .size
                                                                          .height *
                                                                      0.11,
                                                                  width: Get
                                                                      .size
                                                                      .width,
                                                                  child: ListView
                                                                      .builder(
                                                                          scrollDirection: Axis
                                                                              .horizontal,
                                                                          itemCount: data
                                                                              .geos
                                                                              ?.length,
                                                                          physics:
                                                                              const BouncingScrollPhysics(),
                                                                          itemBuilder:
                                                                              (context, index) {
                                                                            var pollutantTypeData =
                                                                                data.geos?[index].value![1];
                                                                            return InkWell(
                                                                              onTap: () {
                                                                                if (controller.isDeleteSaveLocationSelectBtn.value != true) {
                                                                                  Get.to(
                                                                                    () => SelectStationScreen(
                                                                                      stationId: data.stId.toString(),
                                                                                      stationName: data.site,
                                                                                      pollutantTypeNm: "pm",
                                                                                      modelClass: 'UsEmbassyPm',
                                                                                      modelClassList: 'UsEmbassyDataList',
                                                                                      source: data.source ?? "",
                                                                                      pollutantLayerList: data.geos ?? [],
                                                                                      selectIndex: index,
                                                                                      isForecast: false.obs,
                                                                                      isUserSaved: true,
                                                                                    ),
                                                                                  );
                                                                                }
                                                                              },
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(left: 2, right: 2),
                                                                                child: Container(
                                                                                  // height: Get.size.height * 0.08,
                                                                                  width: Get.size.height * 0.12,
                                                                                  decoration: BoxDecoration(color: controller.colorCodeAqiRange(pollutantTypeData ?? 0.0), border: Border.all(), borderRadius: BorderRadius.circular(8)),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                      children: [
                                                                                        SizedBox(
                                                                                          width: Get.size.height * 0.09,
                                                                                          child: Center(
                                                                                            child: Text(
                                                                                              data.geos?[index].getDecimalValue() ?? "",
                                                                                              style: Theme.of(context).textTheme.displayLarge!.copyWith(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 20),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Text(
                                                                                          data.geos?[index].name ?? "",
                                                                                          style: Theme.of(context).textTheme.displayLarge!.copyWith(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 13),
                                                                                        ),
                                                                                        Text(
                                                                                          "GEOS",
                                                                                          // data.geos?[index].getSourceType() ?? "",
                                                                                          style: Theme.of(context).textTheme.displayLarge!.copyWith(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 15),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                            //// Save Location Api Data List
                            SaveLocationListviewWidget(
                              saveLocationList:
                                  controller.saveLocationRecenteApiDataList,
                              isForcast: false.obs,
                            ),
                          ],
                        ),
                      ],
                    )),
                //// Forecat Tab
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, bottom: 0, top: 5),
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10),
                        child: Text(
                          // "saveLocationScreenMessageForecast".tr,
                          "Forecast shows the latest available data.",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(letterSpacing: 0.8, fontSize: 17),
                        ),
                      ),
                      Obx(
                        () => controller.deleteLocationLoading.value == true
                            ? const Center(
                                child: CircularProgressIndicator(
                                    color: AppColor.appButtonColor))
                            : ListView.builder(
                                itemCount: controller
                                    .userAddForecastLocationList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var data = controller
                                      .userAddForecastLocationList[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Stack(
                                        children: [
                                          Obx(
                                            () => Container(
                                              width: Get.size.width,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: controller
                                                          .isSelectedsaveLocationValue
                                                          .contains(index)
                                                      ? Colors.black26
                                                      : AppColor
                                                          .appPrimaryColor),
                                              child: InkWell(
                                                onTap: () {
                                                  if (controller
                                                          .isDeleteSaveLocationSelectBtn
                                                          .value !=
                                                      true) {
                                                  } else {
                                                    controller.isSelectIndex
                                                        .value = index + 1;
                                                    controller.isSelectedsaveLocationValue
                                                                .contains(
                                                                    index) ==
                                                            false
                                                        ? controller
                                                            .isSelectedsaveLocationValue
                                                            .add(index)
                                                        : controller
                                                            .isSelectedsaveLocationValue
                                                            .remove(index);
                                                  }
                                                  if (controller
                                                      .isSelectedsaveLocationValue
                                                      .isNotEmpty) {
                                                    controller
                                                        .savelocationSelected
                                                        .value = true;
                                                  } else {
                                                    controller
                                                        .savelocationSelected
                                                        .value = false;
                                                  }
                                                },
                                                child: Stack(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20.w,
                                                              vertical: 20.h),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: 58.h,
                                                            child: Row(
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      data.site ??
                                                                          "",
                                                                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          color: AppColor
                                                                              .appbarTextColor,
                                                                          fontSize: 20
                                                                              .sp,
                                                                          fontFamily:
                                                                              'Poppins'),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: Get.size
                                                                    .height *
                                                                0.11,
                                                            width:
                                                                Get.size.width,
                                                            child: ListView
                                                                .builder(
                                                                    scrollDirection:
                                                                        Axis
                                                                            .horizontal,
                                                                    itemCount: data
                                                                        .geos
                                                                        ?.length,
                                                                    physics:
                                                                        const BouncingScrollPhysics(),
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      var pollutantTypeData = data
                                                                          .geos?[
                                                                              index]
                                                                          .value![1];
                                                                      return InkWell(
                                                                        onTap:
                                                                            () {
                                                                          if (controller.isDeleteSaveLocationSelectBtn.value !=
                                                                              true) {
                                                                            Get.to(
                                                                              () => SelectStationScreen(
                                                                                stationId: data.stId.toString(),
                                                                                stationName: data.site,
                                                                                pollutantTypeNm: "pm",
                                                                                modelClass: 'UsEmbassyPm',
                                                                                modelClassList: 'UsEmbassyDataList',
                                                                                source: data.source ?? "",
                                                                                pollutantLayerList: data.geos ?? [],
                                                                                selectIndex: index,
                                                                                isForecast: true.obs,
                                                                              ),
                                                                            );
                                                                          }
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              left: 2,
                                                                              right: 2),
                                                                          child:
                                                                              Container(
                                                                            // height: Get.size.height * 0.08,
                                                                            // width:
                                                                            //     Get.size.height * 0.12,
                                                                            decoration: BoxDecoration(
                                                                                color: controller.colorCodeAqiRange(pollutantTypeData ?? 0.0),
                                                                                border: Border.all(),
                                                                                borderRadius: BorderRadius.circular(8)),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                children: [
                                                                                  SizedBox(
                                                                                    width: Get.size.height * 0.09,
                                                                                    child: Center(
                                                                                      child: Text(
                                                                                        data.geos?[index].getDecimalValue() ?? "",
                                                                                        style: Theme.of(context).textTheme.displayLarge!.copyWith(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 20),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    data.geos?[index].name ?? "",
                                                                                    style: Theme.of(context).textTheme.displayLarge!.copyWith(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 13),
                                                                                  ),
                                                                                  Text(
                                                                                    "WRF-CHEM",
                                                                                    style: Theme.of(context).textTheme.displayLarge!.copyWith(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 15),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                      SaveLocationListviewWidget(
                        saveLocationList:
                            controller.saveLocationForecastApiDataList,
                        isForcast: true.obs,
                      ),
                    ],
                  ),
                ),
              ]),
          floatingActionButton: Obx(
            () => Visibility(
              visible: controller.savelocationSelected.value &&
                  controller.isDeleteSaveLocationSelectBtn.value == true,
              child: FloatingActionButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => DeleteAlertDailog(
                      isLoading: false.obs,
                      alrtTitle: "doUWantDelete".tr,
                      alertFirstButtonNm: "Yes".tr,
                      firstBtnTap: () {
                        var index = 0;
                        for (var i = 0;
                            i < controller.isSelectedsaveLocationValue.length;
                            i++) {
                          index = i;
                          var tempID = controller
                              .saveLocationSqlDbList[
                                  controller.isSelectedsaveLocationValue[index]]
                              .id;
                          controller.delete(tempID!);
                        }
                        Get.back();
                      },
                    ),
                  );
                },
                child: Obx(
                  () => controller.saveLocationSqlDbList.isEmpty
                      ? Container(
                          height: 100,
                          width: 100,
                          color: Colors.transparent,
                        )
                      : Container(
                          height: 55,
                          width: 55,
                          decoration: BoxDecoration(
                            color: AppColor.redColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                              child: SvgPicture.asset(
                            /* controller.isDeleteSaveLocationSelectBtn.value ==
                                    false
                                ? AppImages.plushIcon
                                : */
                            AppImages.deleteIcon,
                            color: AppColor.appPrimaryColor,
                          )),
                        ),
                ),
              ),
            ),
          )),
    );
  }
}

class SaveLocationListviewWidget extends StatelessWidget {
  List<RecentAndArchiveData> saveLocationList;
  RxBool isForcast;
  SaveLocationListviewWidget({
    Key? key,
    required this.saveLocationList,
    required this.isForcast,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SaveLocationScreenController>();
    return Obx(
      () => controller.isLoading.value == true
          ? Padding(
              padding: EdgeInsets.only(top: Get.size.height * 0.1),
              child: const Center(
                  child: CircularProgressIndicator(
                color: AppColor.appButtonColor,
              )),
            )
          : ListView.builder(
              itemCount: saveLocationList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var data = saveLocationList[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        Obx(
                          () => Container(
                            width: Get.size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: controller.isDeleteSaveLocationSelectBtn
                                            .value ==
                                        true
                                    ? const Color.fromARGB(255, 237, 237, 237)
                                    : AppColor.appPrimaryColor),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 20.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 58.h,
                                        child: Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data.site ?? "",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displayLarge!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: AppColor
                                                              .appbarTextColor,
                                                          fontSize: 20.sp,
                                                          fontFamily:
                                                              'Poppins'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: Get.size.height * 0.11,
                                        // width: Get.size.width,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemCount: data.geos?.length,
                                            itemBuilder: (context, index) {
                                              var pollutantTypeData =
                                                  data.geos?[index].value![1];
                                              return InkWell(
                                                onTap: () {
                                                  if (controller
                                                          .isDeleteSaveLocationSelectBtn
                                                          .value !=
                                                      true) {
                                                    Get.to(
                                                      () => SelectStationScreen(
                                                        stationId: data.stId
                                                            .toString(),
                                                        stationName: data.site,
                                                        pollutantTypeNm: "pm",
                                                        modelClass:
                                                            'UsEmbassyPm',
                                                        modelClassList:
                                                            'UsEmbassyDataList',
                                                        source:
                                                            data.source ?? "",
                                                        pollutantLayerList:
                                                            data.geos ?? [],
                                                        selectIndex: index,
                                                        isForecast: controller
                                                            .isForecastTabSelect
                                                            .obs
                                                            .value,
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 2, right: 2),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: controller
                                                            .colorCodeAqiRange(
                                                                pollutantTypeData ??
                                                                    0.0),
                                                        border: Border.all(),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 5,
                                                          horizontal: 10),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          SizedBox(
                                                            width: Get.size
                                                                    .height *
                                                                0.09,
                                                            child: Center(
                                                              child: Text(
                                                                data.geos?[index]
                                                                        .getDecimalValue() ??
                                                                    "",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .displayLarge!
                                                                    .copyWith(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            20),
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            data.geos?[index]
                                                                    .name ??
                                                                "",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .displayLarge!
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        13),
                                                          ),
                                                          Text(
                                                            isForcast.value ==
                                                                    true
                                                                ? "WRF-CHEM"
                                                                : data.geos?[
                                                                            index]
                                                                        .getSourceType() ??
                                                                    "",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .displayLarge!
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        15),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
