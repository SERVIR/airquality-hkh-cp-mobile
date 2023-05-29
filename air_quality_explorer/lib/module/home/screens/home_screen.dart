// ignore_for_file: must_call_super

import 'package:air_quality_explorer/core/color.dart';
import 'package:air_quality_explorer/core/images.dart';
import 'package:air_quality_explorer/database/check_insertdata.dart';
import 'package:air_quality_explorer/models/select_pollutantnm_model.dart';
import 'package:air_quality_explorer/module/home/controller/home_screen_controller.dart';
import 'package:air_quality_explorer/module/home/screens/componant/audio_play_componant_widget.dart';
import 'package:air_quality_explorer/module/home/screens/componant/fps_componant.dart';
import 'package:air_quality_explorer/module/home/screens/componant/more_menu_componant.dart';
import 'package:air_quality_explorer/module/home/screens/componant/search_place_list_componant.dart';
import 'package:air_quality_explorer/module/savelocation/controller/save_location_screen_controller.dart';
import 'package:air_quality_explorer/widgets/alert_box_widget.dart';
import 'package:air_quality_explorer/widgets/range_slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive {
    return true;
  }

  final controller = Get.put(HomeScreenController());
  final saveCntrl = Get.put(SaveLocationScreenController());

  @override
  void initState() {
    super.initState();
    controller.layers = controller.arrLayers
        .where((element) =>
            element.status == true || element.defaultSelect == true)
        .toList();
    // controller.selectedArrLayers = controller.arrLayers
    //     .where((element) =>
    //         element.status == true || element.defaultSelect == true)
    //     .toList();
    saveCntrl.getSqlDbStoreData();
    controller.removeDaynemicMarker();
    CheckInsertdata().handleDevicesLocationPermission();
    for (var element in controller.layers) {
      CheckInsertdata()
          .selectedAllLayerArr
          .add(SelectedModelArr(selectedLayer: element));
    }
  }

  // ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RepaintBoundary(
            key: controller.globalKey,
            child: SizedBox(
              height: Get.size.height,
              width: Get.size.width,
              child: Obx(
                () => /* controller.isMapLoding.value == true
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColor.appButtonColor),
                      )
                    :  */
                    FlutterMap(
                  mapController: controller.mapControllers,
                  options: MapOptions(
                      center: LatLng(
                        controller.lat.value,
                        controller.long.value,
                      ),
                      zoom: controller.zoom.value,
                      onTap: (tapPosition, point) {
                        controller.dynamicLatitude.value = point.latitude;
                        controller.dynamicLongitude.value = point.longitude;
                        saveCntrl.dynamicMarkers.add(
                          Marker(
                            point: point,
                            builder: (context) => const Icon(
                              Icons.room,
                              size: 40,
                              color: AppColor.appButtonColor,
                            ),
                          ),
                        );
                        Future.delayed(const Duration(milliseconds: 200), () {
                          showGeneralDialog(
                            context: context,
                            pageBuilder: (ctx, a1, a2) {
                              return Container();
                            },
                            transitionBuilder: (ctx, a1, a2, child) {
                              var curve = Curves.easeInOut.transform(a1.value);
                              return Transform.scale(
                                scale: curve,
                                child: AlertDialogBoxWidget(
                                  controller: saveCntrl.addLocationController,
                                  cityNM:
                                      controller.searchCityName.obs.value.value,
                                  lat: "${point.latitude}",
                                  long: "${point.longitude}",
                                  alrtTitle: "saveLocatonMsg".tr,
                                  alertFirstButtonNm: "addLocation".tr,
                                  isLoading: saveCntrl.isAddLocation.obs.value,
                                  yesBtnTap: () {
                                    controller.getGroundObservationData(
                                      "9",
                                      "pm",
                                    );
                                    // controller
                                    //     .userAddRecentAndArchiveApi();
                                    setState(() {});
                                  },
                                  noBtnTap: () {
                                    saveCntrl.dynamicMarkers.removeLast();
                                    Get.back();
                                    setState(() {});
                                  },
                                ),
                              );
                            },
                            transitionDuration:
                                const Duration(milliseconds: 300),
                          );
                        });

                        setState(() {});
                      }),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    ),

                    /* with play */
                    if (controller.isRecentSelect.value == false)
                      TileLayer(
                          opacity: 0.5,
                          wmsOptions: controller.getLayerForPlay().getLayer(
                              date1: controller.playDate.value,
                              isForcast: controller.isForcastRangeSelect.value))
                    else
                      /* Without play */
                      for (int i = 0; i < controller.layers.length; i++)
                        if (controller.layers[i].isLayerType == true)
                          TileLayer(
                            opacity: controller.layers[i].opacity,
                            wmsOptions: controller.layers[i].getLayer(
                                date1: controller.currentDate,
                                isForcast: false),
                          ),
                    // else
                    //// Ground Observation Marker Icon
                    if (CheckInsertdata().checkIsSelectGround == true)
                      MarkerLayer(
                          markers: controller.setGroundObservationMarker()),

                    //// Surface Observation Marker Icon
                    if (CheckInsertdata().checkIsSelectSurface == true)
                      MarkerLayer(
                        markers: controller.setSurfaceObservationMarker(),
                      ),
                    //// Dynamic Marker (user add marker)
                    if (saveCntrl.dynamicMarkers.isNotEmpty)
                      MarkerLayer(
                        markers: saveCntrl.dynamicMarkers,
                      ),
                    //// User Added Location Marker
                    saveCntrl.isMapLoding.value == true
                        ? const CircularProgressIndicator(
                            color: Colors.transparent,
                          )
                        : MarkerLayer(
                            markers:
                                saveCntrl.addUserSqlliteDbMarkers.obs.value,
                          ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(controller.searchLocationLat.value,
                              controller.searchLocationLong.value),
                          builder: (context) => const Icon(
                            Icons.room,
                            size: 40,
                            color: AppColor.redColor,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),

          /// More button container
          Obx(
            () => controller.menuButtonSelect.value == false
                ? Container()
                : controller.selectDropdownValue.value != 'Recent'
                    ? Container()
                    : controller.isSearch.value == true
                        ? Container()
                        : Positioned(
                            top: 70.h,
                            right: 10.w,
                            child: MoreMenuComponant(
                              controller: controller,
                              arrLayers: controller.layers,
                              layerCallback: (List<SelectPollutantModel> lLit) {
                                controller.layers = lLit;
                                // controller.selectedArrLayers = lLit;
                                setState(() {});
                              },
                              context: context,
                            ),
                          ),
          ),

          /// Top Row Container
          Obx(
            () => Positioned(
              top: Get.size.height * 0.06,
              right: Get.size.width * 0.03,
              left: 10,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Row(
                  children: [
                    /// Search Container
                    controller.isFullScreen.value == true
                        ? Container()
                        : controller.isSearch.value == true
                            ? Container(
                                height: Get.size.height * 0.066,
                                width: Get.size.width * 0.76,
                                decoration: BoxDecoration(
                                  color: AppColor.appPrimaryColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        AppImages.searchIcon,
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: TextField(
                                          controller:
                                              controller.searchController,
                                          decoration: const InputDecoration(
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              hintText: 'Search...'),
                                          onChanged: (value) {
                                            if (value == "") {
                                              controller.searchCityList.clear();
                                            }
                                          },
                                          onSubmitted: (value) {
                                            controller.isLoading.value = true;
                                            controller.fetchPlace(value);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  controller.isSearch.value = true;
                                },
                                child: Container(
                                  height: Get.size.height * 0.066,
                                  width: Get.size.height * 0.066,
                                  decoration: BoxDecoration(
                                    color: AppColor.appPrimaryColor,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      AppImages.searchIcon,
                                    ),
                                  ),
                                ),
                              ),
                    // ),
                    const Spacer(),

                    /// Play/Pause container
                    controller.isFullScreen.value == true
                        ? Container()
                        : controller.isRecentSelect.value == true
                            ? Container()
                            : controller.isSearch.value == true
                                ? Container()
                                : Container(
                                    height: Get.size.height * 0.066,
                                    width: Get.size.width * 0.6,
                                    decoration: BoxDecoration(
                                      color: AppColor.appPrimaryColor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18),
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              // Get.to(CountdownTimerDemo());
                                              controller.isPlay.value =
                                                  !controller.isPlay.value;
                                              if (controller.isPlay.value ==
                                                  true) {
                                                controller
                                                    .getPlayNPauseTimeDurationAnimation();
                                              } else {
                                                if (controller.timer == null ||
                                                    controller
                                                        .timer!.isActive) {
                                                  /* 
                                                  controller.storeTime =
                                                      controller.timer; */
                                                  controller.timer?.cancel();
                                                }
                                              }
                                            },
                                            child: SizedBox(
                                              height: 50,
                                              width: 50,
                                              child: Center(
                                                child: Icon(
                                                  controller.isPlay.value ==
                                                          true
                                                      ? Icons.pause_rounded
                                                      : Icons
                                                          .play_arrow_rounded,
                                                  size: 30,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            controller.playDate.value.isEmpty
                                                ? DateFormat("yyyy-MM-dd")
                                                    .format(controller
                                                        .startDate.value)
                                                : controller.playDate.value,
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayLarge!
                                                .copyWith(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    ),
                                    // ),
                                  ),
                    const Spacer(),

                    controller.isFullScreen.value == true

                        /// Full screen close container
                        ? InkWell(
                            onTap: () {
                              controller.isFullScreen.value = false;
                            },
                            child: Container(
                              height: Get.size.height * 0.066,
                              width: Get.size.height * 0.066,
                              decoration: BoxDecoration(
                                color: AppColor.appPrimaryColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  AppImages.crossIcon,
                                ),
                              ),
                            ),
                          )
                        : controller.isSearch.value == true

                            /// Search close container
                            ? InkWell(
                                onTap: () {
                                  controller.isSearch.value = false;
                                  controller.searchCityList.clear();
                                  controller.searchController.clear();
                                },
                                child: Container(
                                  height: Get.size.height * 0.066,
                                  width: Get.size.height * 0.066,
                                  decoration: BoxDecoration(
                                      color: AppColor.appPrimaryColor,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      AppImages.crossIcon,
                                    ),
                                  ),
                                ),
                              )

                            /// More Container
                            : InkWell(
                                onTap: () {
                                  controller.menuButtonSelect.value =
                                      !controller.menuButtonSelect.value;
                                  controller.isMorBtnTap.value =
                                      !controller.isMorBtnTap.value;
                                  controller.selectDropdownValue.value =
                                      'Recent';
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Container(
                                    height: Get.size.height * 0.066,
                                    width: Get.size.height * 0.066,
                                    decoration: BoxDecoration(
                                      color: AppColor.appPrimaryColor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        AppImages.moreIcon,
                                        color:
                                            controller.isMorBtnTap.value != true
                                                ? AppColor.appButtonColor
                                                : AppColor.appbarTextColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                    // ),
                  ],
                ),
              ),
            ),
          ),

          //! Recent/forcast/archive container
          Positioned(
            bottom: Get.height * 0.025,
            left: 10,
            right: 10,
            child: const RangeSliderWidget(),
          ),

          /// fps speed container
          Obx(
            () => controller.isRecentSelect.value == true
                ? Container()
                : controller.isSearch.value == true
                    ? Container()
                    : Positioned(
                        bottom: Get.size.height * 0.13,
                        right: Get.size.width * 0.61,
                        left: 0,
                        child: FPSSpeedComponant(controller: controller),
                      ),
          ),

          /// Scale container
          Obx(
            () => controller.selectDropdownValue.value == 'Recent'
                ? Container()
                : controller.isSearch.value == true
                    ? Container()
                    : Positioned(
                        bottom: 90,
                        right: 10,
                        left: Get.size.width * 0.43,
                        child: Image.asset(AppImages.scaleImages)),
          ),

          /// Audio player componant
          Obx(
            () => controller.ifChangeDate.value == false
                ? Container()
                : controller.ifChangeDate.value == true
                    ? Container()
                    : controller.isSearch.value == true
                        ? Container()
                        : Positioned(
                            bottom: Get.size.height * 0.15,
                            right: 0,
                            left: Get.size.width * 0.4,
                            child: AudioPlayComponantWidget(
                              controller: controller,
                            ),
                          ),
          ),

          /// Search list data
          Positioned(
            top: Get.size.height * 0.11,
            // right: Get.size.width * 0.2,
            left: 10,
            child: Obx(
              () => controller.searchCityList.isEmpty
                  ? Container()
                  : SearchPlaceListComponant(
                      controller: controller,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
