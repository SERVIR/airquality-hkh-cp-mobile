import 'package:air_quality_explorer/core/color.dart';
import 'package:air_quality_explorer/core/images.dart';
import 'package:air_quality_explorer/module/savelocation/controller/save_location_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

// ignore: must_be_immutable
class VectorMeterWidget extends StatelessWidget {
  RxDouble aqiMeterValue;
  RxString pollutantType;
  VectorMeterWidget(
      {Key? key, required this.aqiMeterValue, required this.pollutantType})
      : super(key: key);

  List<Color> gradiantColor() {
    List<Color> color = [];
    if (aqiMeterValue.value <= 50) {
      color = [Colors.green];
    } else if (aqiMeterValue.value <= 100) {
      color = [Colors.green, Colors.yellow];
    } else if (aqiMeterValue.value <= 150) {
      color = [Colors.green, Colors.yellow, Colors.orange];
    } else if (aqiMeterValue.value <= 200) {
      color = [Colors.green, Colors.yellow, Colors.orange, Colors.red];
    } else if (aqiMeterValue.value <= 300) {
      color = [
        Colors.green,
        Colors.yellow,
        Colors.orange,
        Colors.red,
        Colors.purple
      ];
    } else if (aqiMeterValue.value <= 500) {
      color = [
        Colors.green,
        Colors.yellow,
        Colors.orange,
        Colors.red,
        Colors.purple,
        const Color(0xFF800000)
      ];
    }

    return color;
  }

  String getStatusOfPolutant() {
    if (aqiMeterValue.value <= 50) {
      return "Good";
    } else if (aqiMeterValue.value <= 100) {
      return "Moderate";
    } else if (aqiMeterValue.value <= 150) {
      return "Moderate";
    } else if (aqiMeterValue.value <= 200) {
      return "Unhealthy";
    } else if (aqiMeterValue.value <= 300) {
      return "Very Unhealthy";
    } else if (aqiMeterValue.value <= 500) {
      return "Hazardous";
    }
    return "Good";
  }

  final saveLocationCntrl = Get.find<SaveLocationScreenController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Obx(
            () => SizedBox(
              height: Get.size.height * 0.272,
              width: Get.size.height * 0.272,
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    /* ranges: [
                      GaugeRange(
                        startValue: minAqiValue,
                        endValue: maxAqiValue,
                        startWidth: 15,
                        endWidth: 15,
                        gradient: aqiMeterValue <= 50.0
                            ? const SweepGradient(
                                colors: <Color>[Colors.green],
                              )
                            : aqiMeterValue <= 100.0
                                ? const SweepGradient(
                                    colors: <Color>[Colors.yellow],
                                  )
                                : aqiMeterValue <= 150.0
                                    ? const SweepGradient(
                                        colors: <Color>[Colors.orange],
                                      )
                                    : aqiMeterValue <= 200.0
                                        ? const SweepGradient(
                                            colors: <Color>[Colors.red],
                                          )
                                        : aqiMeterValue <= 300.0
                                            ? const SweepGradient(
                                                colors: <Color>[Colors.purple],
                                              )
                                            : const SweepGradient(
                                                colors: <Color>[
                                                  Color(0xFF800000)
                                                ],
                                              ),
                      ),
                    ], */
                    showFirstLabel: true,
                    showLastLabel: true,
                    maximumLabels: 0,
                    showLabels: true,
                    showTicks: true,
                    maximum: 500,
                    minorTicksPerInterval: 0,
                    axisLineStyle: const AxisLineStyle(
                        color: AppColor.appTextColor,
                        thickness: 15,
                        cornerStyle: CornerStyle.bothCurve),
                    pointers: <GaugePointer>[
                      const RangePointer(
                        value: 500,
                        width: 15,
                        enableAnimation: true,
                        cornerStyle: CornerStyle.bothCurve,
                        gradient: SweepGradient(
                            // colors: gradiantColor(),
                            colors: [
                              Colors.green,
                              Colors.yellow,
                              Colors.orange,
                              Colors.red,
                              Colors.purple,
                              Color(0xFF800000)
                            ]),
                        /* gradient: aqiMeterValue.value <= 50
                            ? const SweepGradient(
                                colors: <Color>[Colors.green],
                              )
                            : aqiMeterValue.value <= 100
                                ? const SweepGradient(
                                    colors: <Color>[Colors.yellow],
                                  )
                                : aqiMeterValue.value <= 150
                                    ? const SweepGradient(
                                        colors: <Color>[Colors.orange],
                                      )
                                    : aqiMeterValue.value <= 200
                                        ? const SweepGradient(
                                            colors: <Color>[Colors.red],
                                          )
                                        : aqiMeterValue.value <= 300
                                            ? const SweepGradient(
                                                colors: <Color>[Colors.purple],
                                              )
                                            : const SweepGradient(
                                                colors: <Color>[
                                                  Color(0xFF800000)
                                                ],
                                              ),
                       */
                      ),
                      MarkerPointer(
                          value: double.parse(
                              aqiMeterValue.value.round().toString()),
                          markerType: MarkerType.image,
                          markerHeight: 30,
                          markerWidth: 30,
                          enableAnimation: true,
                          imageUrl: AppImages.vectorMeterMarkerImg),
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        angle: 270,
                        positionFactor: 0.15,
                        widget: Text(
                          aqiMeterValue.value.round().toString(),
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: saveLocationCntrl.colorCodeAqiRange(
                                            aqiMeterValue.value) ==
                                        const Color(0xffffffff)
                                    ? Colors.black
                                    : saveLocationCntrl
                                        .colorCodeAqiRange(aqiMeterValue.value),
                              ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 8,
          child: Center(
            child: Text(
              getStatusOfPolutant(),
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(fontSize: 20, color: gradiantColor().last),
            ),
          ),
        ),
      ],
    );
  }
}
