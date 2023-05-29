import 'package:air_quality_explorer/core/color.dart';
import 'package:air_quality_explorer/database/check_insertdata.dart';
import 'package:air_quality_explorer/models/select_pollutantnm_model.dart';
import 'package:air_quality_explorer/module/home/controller/layers_controls_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LayersControlsScreen extends StatefulWidget {
  const LayersControlsScreen({
    Key? key,
    required this.arrLayers,
  }) : super(key: key);

  final List<SelectPollutantModel> arrLayers;

  @override
  State<LayersControlsScreen> createState() => _LayersControlsScreenState();
}

class _LayersControlsScreenState extends State<LayersControlsScreen>
    with TickerProviderStateMixin {
  final controller = Get.put(LayersControlsScreenController());

  @override
  void initState() {
    super.initState();
    controller.addLayerControllList(widget.arrLayers);

    for (var element in CheckInsertdata().selectedAllLayerArr) {
      controller.selectedLayerArr.add(element);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appPrimaryColor,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            // for (int i = 0; i < controller.selectedLayerArr.length; i++) {
            //   controller.selectedLayerArr[i].selectedLayer?.status = false;
            // }
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
          "layersCntrls".tr,
          style: Theme.of(context).textTheme.displayMedium!,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: LayerControllDataListWidget(
              controller: controller,
              modelRatingForcast: controller.ratingModelForecast,
              sateliteRatingForcast: controller.ratingSateliteForecast,
              groupValue: controller.radioGroupValueForcast,
              selectList: widget.arrLayers,
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ExpandedListWidget extends StatefulWidget {
  int? index;
  String? title;
  bool? isExpanded;
  List<SelectPollutantModel> subMenuPollutantLayerNmList;
  RxBool? isCheck;
  ExpandedListWidget(
      {Key? key,
      this.index,
      this.title,
      this.isCheck,
      this.isExpanded,
      required this.subMenuPollutantLayerNmList})
      : super(key: key);

  @override
  State<ExpandedListWidget> createState() => _ExpandedListWidgetState();
}

class _ExpandedListWidgetState extends State<ExpandedListWidget> {
  final layerCntrlController = Get.find<LayersControlsScreenController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColor.appPrimaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.title ?? "",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                    width: 50.0,
                    child: Center(
                      child: Icon(
                        widget.isExpanded!
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 30.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        ExpandableContainer(
            expanded: widget.isExpanded!,
            length: widget.subMenuPollutantLayerNmList.length,
            child: widget.isExpanded! == false
                ? Container()
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.subMenuPollutantLayerNmList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (layerCntrlController
                                      .selectedLayerArr.length <=
                                  4) {
                                layerCntrlController
                                        .layerControlGroupList[widget.index!]
                                        .subMenuList![index]
                                        .status =
                                    !layerCntrlController
                                        .layerControlGroupList[widget.index!]
                                        .subMenuList![index]
                                        .status;
                              } else {
                                layerCntrlController
                                    .layerControlGroupList[widget.index!]
                                    .subMenuList![index]
                                    .status = false;
                                layerCntrlController
                                    .layerControlGroupList[widget.index!]
                                    .subMenuList![index]
                                    .defaultSelect = false;
                              }
                              if (layerCntrlController
                                          .layerControlGroupList[widget.index!]
                                          .subMenuList![index]
                                          .status ==
                                      true &&
                                  layerCntrlController.selectedLayerArr.length <
                                      4) {
                                layerCntrlController.selectedLayerArr.add(
                                  SelectedModelArr(
                                    mainIndex: widget.index,
                                    subIndex: index,
                                    selectedLayer: widget
                                        .subMenuPollutantLayerNmList[index],
                                  ),
                                );
                              } else {
                                var checkindex = layerCntrlController
                                    .selectedLayerArr
                                    .indexWhere((element) =>
                                        element.selectedLayer?.pollutantNm ==
                                        widget
                                            .subMenuPollutantLayerNmList[index]
                                            .pollutantNm);
                                layerCntrlController.selectedLayerArr
                                    .removeAt(checkindex);
                              }
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                      activeColor: AppColor.appButtonColor,
                                      value: layerCntrlController
                                          .layerControlGroupList[widget.index!]
                                          .subMenuList?[index]
                                          .obs
                                          .value
                                          .status,
                                      onChanged: (value) {
                                        if (value == true &&
                                            layerCntrlController
                                                    .selectedLayerArr.length <
                                                4) {
                                          layerCntrlController.selectedLayerArr
                                              .add(
                                            SelectedModelArr(
                                              mainIndex: widget.index,
                                              subIndex: index,
                                              selectedLayer: widget
                                                      .subMenuPollutantLayerNmList[
                                                  index],
                                            ),
                                          );
                                        } else {
                                          var checkindex = layerCntrlController
                                              .selectedLayerArr
                                              .indexWhere((element) =>
                                                  element.selectedLayer
                                                      ?.pollutantNm ==
                                                  widget
                                                      .subMenuPollutantLayerNmList[
                                                          index]
                                                      .pollutantNm);
                                          layerCntrlController.selectedLayerArr
                                              .removeAt(checkindex);
                                        }
                                        if (layerCntrlController
                                                .selectedLayerArr.length <=
                                            4) {
                                          layerCntrlController
                                              .layerControlGroupList[
                                                  widget.index!]
                                              .subMenuList![index]
                                              .status = value!;
                                        } else {
                                          value = false;
                                          layerCntrlController
                                              .layerControlGroupList[
                                                  widget.index!]
                                              .subMenuList![index]
                                              .status = false;
                                          layerCntrlController
                                              .layerControlGroupList[
                                                  widget.index!]
                                              .subMenuList![index]
                                              .defaultSelect = false;
                                        }
                                        setState(() {});
                                      }),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.43,
                                    child: Text(
                                      layerCntrlController
                                              .layerControlGroupList[
                                                  widget.index!]
                                              .subMenuList?[index]
                                              .pollutantNm ??
                                          "",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: (layerCntrlController
                                                          .layerControlGroupList[
                                                              widget.index!]
                                                          .subMenuList?[index]
                                                          .status ==
                                                      true ||
                                                  layerCntrlController
                                                          .selectedLayerArr
                                                          .length <
                                                      4)
                                              ? AppColor.appbarTextColor
                                              : AppColor.greayColor),
                                    ),
                                  ),
                                  if (layerCntrlController
                                              .layerControlGroupList[
                                                  widget.index!]
                                              .subMenuList?[index]
                                              .status ==
                                          true &&
                                      layerCntrlController
                                              .layerControlGroupList[
                                                  widget.index!]
                                              .subMenuList?[index]
                                              .defaultSelect ==
                                          false)
                                    if (layerCntrlController
                                            .layerControlGroupList[
                                                widget.index!]
                                            .subMenuList?[index]
                                            .pollutantNm !=
                                        "Surface Observation-AOD (AERONET)")
                                      IconButton(
                                        onPressed: () {
                                          CheckInsertdata()
                                                  .selectPlayAnimationName =
                                              layerCntrlController
                                                      .layerControlGroupList[
                                                          widget.index!]
                                                      .subMenuList?[index]
                                                      .pollutantNm ??
                                                  "";
                                          for (int i = 0;
                                              i <
                                                  layerCntrlController
                                                      .layerControlGroupList
                                                      .length;
                                              i++) {
                                            for (int j = 0;
                                                j <
                                                    layerCntrlController
                                                        .layerControlGroupList[
                                                            i]
                                                        .subMenuList!
                                                        .length;
                                                j++) {
                                              if (widget.index == i) {
                                                if (index == j) {
                                                  layerCntrlController
                                                      .layerControlGroupList[i]
                                                      .subMenuList![j]
                                                      .isPlay = true;
                                                } else {
                                                  layerCntrlController
                                                      .layerControlGroupList[i]
                                                      .subMenuList![j]
                                                      .isPlay = false;
                                                }
                                              } else {
                                                layerCntrlController
                                                    .layerControlGroupList[i]
                                                    .subMenuList![j]
                                                    .isPlay = false;
                                              }
                                            }
                                          }

                                          setState(() {});
                                        },
                                        icon: Icon(
                                            layerCntrlController
                                                        .layerControlGroupList[
                                                            widget.index!]
                                                        .subMenuList?[index]
                                                        .isPlay !=
                                                    true
                                                ? Icons.pause_rounded
                                                : Icons.play_arrow_rounded,
                                            size: 30),
                                      )
                                    else
                                      Container()
                                  else
                                    Container(),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      layerCntrlController
                                              .layerControlGroupList[widget.index!]
                                              .subMenuList?[index]
                                              .isExpanded =
                                          !layerCntrlController
                                              .layerControlGroupList[
                                                  widget.index!]
                                              .subMenuList![index]
                                              .isExpanded;
                                      setState(() {});
                                    },
                                    icon: Icon(
                                        layerCntrlController
                                                    .layerControlGroupList[
                                                        widget.index!]
                                                    .subMenuList?[index]
                                                    .isExpanded ==
                                                false
                                            ? Icons.keyboard_arrow_down_rounded
                                            : Icons.keyboard_arrow_up_rounded,
                                        size: 30),
                                  ),
                                ],
                              ),
                              if (layerCntrlController
                                      .layerControlGroupList[widget.index!]
                                      .subMenuList?[index]
                                      .isExpanded ==
                                  true)
                                if (layerCntrlController
                                    .layerControlGroupList[widget.index!]
                                    .subMenuList![index]
                                    .showOpacity)
                                  SizedBox(
                                    height: 20,
                                    child: Slider(
                                      value: layerCntrlController
                                              .layerControlGroupList[
                                                  widget.index!]
                                              .subMenuList![index]
                                              .opacity *
                                          100,
                                      onChanged: (value) {
                                        layerCntrlController
                                            .layerControlGroupList[
                                                widget.index!]
                                            .subMenuList?[index]
                                            .opacity = value / 100;
                                        setState(() {});
                                      },
                                      min: 0,
                                      divisions: 5,
                                      max: 100,
                                      label:
                                          "${layerCntrlController.layerControlGroupList[widget.index!].subMenuList?[index].opacity}",
                                      activeColor: AppColor.appButtonColor,
                                      inactiveColor: AppColor.lightAppBtnColor,
                                    ),
                                  ),
                              if (layerCntrlController
                                      .layerControlGroupList[widget.index!]
                                      .subMenuList?[index]
                                      .isExpanded ==
                                  true)
                                if (layerCntrlController
                                        .layerControlGroupList[widget.index!]
                                        .subMenuList?[index]
                                        .showLegends ==
                                    true)
                                  const LegendDesignWidget(),
                              if (layerCntrlController
                                          .layerControlGroupList[widget.index!]
                                          .subMenuList?[index]
                                          .isExpanded ==
                                      true &&
                                  !layerCntrlController
                                      .layerControlGroupList[widget.index!]
                                      .subMenuList![index]
                                      .showOpacity &&
                                  layerCntrlController
                                          .layerControlGroupList[widget.index!]
                                          .subMenuList?[index]
                                          .pollutantNm ==
                                      "Ground Observation-PM2.5 (AirNow)")
                                const Padding(
                                  padding: EdgeInsets.only(left: 55, top: 5),
                                  child: Icon(
                                    Icons.square,
                                    color: Color.fromARGB(255, 80, 113, 9),
                                  ),
                                )
                              else if (layerCntrlController
                                          .layerControlGroupList[widget.index!]
                                          .subMenuList?[index]
                                          .isExpanded ==
                                      true &&
                                  !layerCntrlController
                                      .layerControlGroupList[widget.index!]
                                      .subMenuList![index]
                                      .showOpacity &&
                                  layerCntrlController
                                          .layerControlGroupList[widget.index!]
                                          .subMenuList?[index]
                                          .pollutantNm ==
                                      "Surface Observation-AOD (AERONET)")
                                const Padding(
                                  padding: EdgeInsets.only(left: 55, top: 5),
                                  child: Icon(
                                    Icons.change_history_sharp,
                                    color: Colors.red,
                                  ),
                                )
                            ],
                          ),
                        ),
                      );
                    },
                  ))
      ],
    );
  }
}

class LayerControllDataListWidget extends StatefulWidget {
  const LayerControllDataListWidget({
    Key? key,
    required this.controller,
    required this.modelRatingForcast,
    required this.sateliteRatingForcast,
    required this.groupValue,
    required this.selectList,
  }) : super(key: key);

  final LayersControlsScreenController controller;
  final RxInt modelRatingForcast;
  final RxInt sateliteRatingForcast;
  final RxInt groupValue;
  final List<SelectPollutantModel> selectList;

  @override
  State<LayerControllDataListWidget> createState() =>
      _LayerControllDataListWidgetState();
}

class _LayerControllDataListWidgetState
    extends State<LayerControllDataListWidget> {
  final layerCntrlController = Get.find<LayersControlsScreenController>();
  List<SelectPollutantModel> selectPollutantnm = [];
  // List<SelectPollutantModel> selectAllLayer = [];

  bool expand = false;
  int? tapped;
  var isCheckCheckBox = false.obs;

  @override
  // void initState() {
  //   selectAllLayer = widget.selectList;
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: AppColor.appPrimaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 0, left: 24, right: 24),
            child: ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Selected Layers",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColor.appButtonColor),
                  ),
                ),
                SizedBox(
                  child: Obx(
                    () => ListView.builder(
                        shrinkWrap: true,
                        itemCount: layerCntrlController.selectedLayerArr.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Text(
                              "- ${layerCntrlController.selectedLayerArr[index].selectedLayer?.pollutantNm}",
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                const SizedBox(height: 5),
                const Divider(
                  color: AppColor.greayColor,
                  thickness: 4,
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          expand = ((tapped == null) ||
                                  ((index == tapped) || !expand))
                              ? !expand
                              : expand;

                          tapped = index;
                        });
                      },
                      child: ExpandedListWidget(
                        index: index,
                        title: layerCntrlController
                                .layerControlGroupList[index].name ??
                            "",
                        isExpanded: index == tapped ? expand : false,
                        isCheck: isCheckCheckBox.obs.value,
                        subMenuPollutantLayerNmList: layerCntrlController
                                .layerControlGroupList[index].subMenuList ??
                            [],
                      ),
                    );
                  },
                  itemCount: layerCntrlController.layerControlGroupList.length,
                ),
                SizedBox(height: Get.size.height * 0.025),
                SizedBox(height: Get.size.height * 0.025),
                Container(
                  height: Get.size.height * 0.1,
                  width: Get.size.width,
                  color: AppColor.appPrimaryColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    child: InkWell(
                      onTap: () {
                        for (var element
                            in layerCntrlController.selectedLayerArr) {
                          if (element.selectedLayer?.status == true) {
                            selectPollutantnm.add(element.selectedLayer!);
                          }
                        }
                        CheckInsertdata().selectedAllLayerArr.value = [];
                        CheckInsertdata().selectedAllLayerArr.value =
                            layerCntrlController.selectedLayerArr;

                        var selectSurfaceObser = layerCntrlController
                            .selectedLayerArr
                            .where((e) =>
                                e.selectedLayer?.pollutantNm ==
                                "Surface Observation-AOD (AERONET)")
                            .toList();

                        if (selectSurfaceObser.isNotEmpty) {
                          CheckInsertdata().checkIsSelectSurface = true;
                        } else {
                          CheckInsertdata().checkIsSelectSurface = false;
                        }
                        var selectGroundObser = layerCntrlController
                            .selectedLayerArr
                            .where((e) =>
                                e.selectedLayer?.pollutantNm ==
                                "Ground Observation-PM2.5 (AirNow)")
                            .toList();
                        if (selectGroundObser.isNotEmpty) {
                          CheckInsertdata().checkIsSelectGround = true;
                        } else {
                          CheckInsertdata().checkIsSelectGround = false;
                        }

                        Get.back(result: {
                          "selectPollutantLayer": selectPollutantnm,
                          "isSelectSurface":
                              CheckInsertdata().checkIsSelectSurface,
                          "isGroundObservation":
                              CheckInsertdata().checkIsSelectGround
                        });
                      },
                      child: Container(
                        height: Get.size.height * 0.07,
                        width: Get.size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color:
                                layerCntrlController.selectedLayerArr.length <=
                                        4
                                    ? AppColor.appButtonLightColor
                                    : AppColor.greayColor),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Material(
                            color: Colors.transparent,
                            child: Center(
                              child: Text(
                                "Apply",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .copyWith(
                                        fontSize: 20,
                                        color: layerCntrlController
                                                    .selectedLayerArr.length <=
                                                4
                                            ? AppColor.whiteColor
                                            : AppColor.lighttextColor,
                                        fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        /* Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: Get.size.height * 0.1,
            width: Get.size.width,
            color: AppColor.appPrimaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              child: InkWell(
                onTap: () {
                  for (var element in layerCntrlController.selectedLayerArr) {
                    if (element.selectedLayer?.status == true) {
                      selectPollutantnm.add(element.selectedLayer!);
                    }
                  }
                  CheckInsertdata().selectedAllLayerArr.value = [];
                  CheckInsertdata().selectedAllLayerArr.value =
                      layerCntrlController.selectedLayerArr;

                  var selectSurfaceObser = layerCntrlController.selectedLayerArr
                      .where((e) =>
                          e.selectedLayer?.pollutantNm ==
                          "Surface Observation-AOD (AERONET)")
                      .toList();

                  if (selectSurfaceObser.isNotEmpty) {
                    CheckInsertdata().checkIsSelectSurface = true;
                  } else {
                    CheckInsertdata().checkIsSelectSurface = false;
                  }
                  var selectGroundObser = layerCntrlController.selectedLayerArr
                      .where((e) =>
                          e.selectedLayer?.pollutantNm ==
                          "Ground Observation-PM2.5 (AirNow)")
                      .toList();
                  debugPrint(
                      "Select ground data list : ${selectGroundObser.length}");
                  if (selectGroundObser.isNotEmpty) {
                    CheckInsertdata().checkIsSelectGround = true;
                  } else {
                    CheckInsertdata().checkIsSelectGround = false;
                  }
                  Get.back(result: {
                    "selectPollutantLayer": selectPollutantnm,
                    "isSelectSurface": CheckInsertdata().checkIsSelectSurface,
                    "isGroundObservation": CheckInsertdata().checkIsSelectGround
                  });
                },
                child: Container(
                  height: Get.size.height * 0.07,
                  width: Get.size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: layerCntrlController.selectedLayerArr.length <= 4
                          ? AppColor.appButtonLightColor
                          : AppColor.greayColor),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Material(
                      color: Colors.transparent,
                      child: Center(
                        child: Text(
                          "Apply",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                  fontSize: 20,
                                  color: layerCntrlController
                                              .selectedLayerArr.length <=
                                          4
                                      ? AppColor.whiteColor
                                      : AppColor.lighttextColor,
                                  fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ), */
      ],
    );
  }
}

class LegendDesignWidget extends StatelessWidget {
  const LegendDesignWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  Container(
                    height: Get.size.height * 0.007,
                    width: Get.size.width * 0.13,
                    decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            bottomLeft: Radius.circular(50))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "0-50",
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontSize: 14),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  Container(
                    height: Get.size.height * 0.007,
                    width: Get.size.width * 0.13,
                    color: Colors.yellow,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "51-100",
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontSize: 15),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  Container(
                    height: Get.size.height * 0.007,
                    width: Get.size.width * 0.13,
                    color: Colors.orange,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "101-150",
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontSize: 14),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  Container(
                    height: Get.size.height * 0.007,
                    width: Get.size.width * 0.13,
                    color: Colors.red,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "151-200",
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontSize: 14),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  Container(
                    height: Get.size.height * 0.007,
                    width: Get.size.width * 0.13,
                    color: Colors.purple,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "201-300",
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontSize: 14),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  Container(
                    height: Get.size.height * 0.007,
                    width: Get.size.width * 0.13,
                    decoration: const BoxDecoration(
                      color: Color(0xFF800000),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          bottomRight: Radius.circular(50)),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "301-500",
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ExpandableContainer extends StatelessWidget {
  final bool expanded;
  final double collapsedHeight;
  // final double expandedHeight;
  final Widget child;
  final int length;

  const ExpandableContainer({
    Key? key,
    required this.child,
    this.collapsedHeight = 0.0,
    // this.expandedHeight = 260.0,
    this.expanded = true,
    required this.length,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: screenWidth,
      /* height: !expanded
          ? collapsedHeight
          : length == 3
              ? 210
              : length == 5
                  ? 300
                  : 270.0, */
      child: Container(
        child: child,
      ),
    );
  }
}
