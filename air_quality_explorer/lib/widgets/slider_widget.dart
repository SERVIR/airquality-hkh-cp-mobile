import 'package:air_quality_explorer/core/color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

//// SfSlider Widget
class SfSliderWidget extends StatefulWidget {
  final dynamic minvalue;
  final dynamic maxvalue;
  final dynamic value;
  final Function callBack;
  const SfSliderWidget(
      {super.key,
      required this.minvalue,
      required this.maxvalue,
      required this.callBack,
      required this.value});

  @override
  State<SfSliderWidget> createState() => _SfSliderWidgetState();
}

class _SfSliderWidgetState extends State<SfSliderWidget> {
  @override
  Widget build(BuildContext context) {
    return SfSlider(
      min: widget.minvalue,
      max: widget.maxvalue,
      interval: 2,
      minorTicksPerInterval: 1,
      inactiveColor: AppColor.greayColor,
      activeColor: AppColor.appButtonColor,
      stepDuration: const SliderStepDuration(days: 1),
      dateFormat: DateFormat.MMMd(),
      dateIntervalType: DateIntervalType.days,
      showTicks: true,
      tooltipTextFormatterCallback:
          (dynamic actualValue, String formattedText) {
        return DateFormat('dd/MM/yyyy').format(actualValue);
      },
      enableTooltip: true,
      showLabels: true,
      value: widget.value,
      onChanged: (newValue) {
        widget.callBack(newValue);
      },
    );
  }
}
