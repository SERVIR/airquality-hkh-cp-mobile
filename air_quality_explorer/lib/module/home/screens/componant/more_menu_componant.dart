import 'package:air_quality_explorer/core/color.dart';
import 'package:air_quality_explorer/core/images.dart';
import 'package:air_quality_explorer/models/select_pollutantnm_model.dart';
import 'package:air_quality_explorer/module/home/controller/home_screen_controller.dart';
import 'package:air_quality_explorer/module/home/screens/layers_controls_screen.dart';
import 'package:air_quality_explorer/module/savelocation/controller/save_location_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MoreMenuComponant extends StatelessWidget {
  MoreMenuComponant({
    Key? key,
    required this.controller,
    required this.layerCallback,
    required this.arrLayers,
    required this.context,
  }) : super(key: key);
  final List<SelectPollutantModel> arrLayers;
  final HomeScreenController controller;
  final Function(List<SelectPollutantModel>) layerCallback;
  final BuildContext context;

  final saveController = Get.find<SaveLocationScreenController>();
  @override
  Widget build(BuildContext context) {
    /*  controller.arrLayers.forEach(
      (element) {
        if (element.status == true) {
          
        }
      },
    );
 */
    return Container(
        // height: Get.size.height * 0.7,

        width: 60.w,
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 30.h,
            ),

            //// More option share container
            InkWell(
              onTap: () {
                controller.menuButtonSelect.value = false;
                // controller.share();
                controller.captureScreenShot();
              },
              child: Column(
                children: [
                  /* Showcase(
                    key: controller.fifth,
                    title: 'Share location data',
                    titleTextStyle:
                        Theme.of(context).textTheme.displayLarge!.copyWith(
                              fontSize: 16,
                              color: AppColor.appbarTextColor,
                              fontWeight: FontWeight.w600,
                            ),
                    description:
                        'You can share the data of\n the selected location',
                    descTextStyle:
                        Theme.of(context).textTheme.displayLarge!.copyWith(
                              color: AppColor.appButtonColor,
                              fontSize: 14,
                            ),
                    targetShapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    tooltipBorderRadius: BorderRadius.circular(3),
                    onToolTipClick: () {
                      ShowCaseWidget.of(context).startShowCase([
                        controller.six,
                      ]);
                    },
                    child: */
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: AppColor.appPrimaryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        AppImages.shareIcon,
                      ),
                    ),
                  ),
                  // ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Center(
                    child: Text(
                      "share".tr,
                      // Str.share,
                      // controller.morIconNameList[index],
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppColor.whiteColor,
                          ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),

            //// More option layers container
            InkWell(
              onTap: () async {
                // for (var element in arrLayers) {
                //   if (element.status == true) {
                //     temp.add(element);
                //   }
                // }
                var result = await Get.to(
                  LayersControlsScreen(
                    arrLayers: arrLayers,
                    // arrLayers: temp,
                  ),
                );

                if (result != null) {
                  layerCallback(result['selectPollutantLayer']);
                  if (result['isSelectSurface'] == true) {
                    // controller.getAeronetListData();
                    controller.surfaceObservationAeronetMarkers.obs.value;
                    saveController.addUserSqlliteDbMarkers.value =
                        saveController.setSqlDataListSurfaceObservationMarker(
                            "SureFaceObservation");
                  }
                  if (result['isGroundObservation'] == true) {
                    saveController.addUserSqlliteDbMarkers.value =
                        saveController.setSqlDataListSurfaceObservationMarker(
                            "GroundObservation");
                    controller.groundObservationAirnowMarkers.obs.value;
                    // controller.getAirnowListData();
                  }
                }
              },
              child: Column(
                children: [
                  /* Showcase(
                    key: controller.six,
                    title: 'Change the map layer',
                    titleTextStyle:
                        Theme.of(context).textTheme.displayLarge!.copyWith(
                              fontSize: 16,
                              color: AppColor.appbarTextColor,
                              fontWeight: FontWeight.w600,
                            ),
                    description:
                        'You can change the map\n layers and control the\n opacity of the layers',
                    descTextStyle:
                        Theme.of(context).textTheme.displayLarge!.copyWith(
                              color: AppColor.appButtonColor,
                              fontSize: 14,
                            ),
                    targetShapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    tooltipBorderRadius: BorderRadius.circular(3),
                    onToolTipClick: () {
                      ShowCaseWidget.of(context).startShowCase([
                        controller.seven,
                      ]);
                    },
                    child: */
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: AppColor.appPrimaryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        AppImages.layersIcon,
                      ),
                    ),
                  ),
                  // ),
                  const SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: Text(
                      "layers".tr,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppColor.whiteColor,
                          ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),

            const SizedBox(
              height: 10,
            ),
          ],
        ));
  }
}
