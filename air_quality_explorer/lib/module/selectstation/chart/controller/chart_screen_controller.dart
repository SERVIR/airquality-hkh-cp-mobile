import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartScreenController extends GetxController {
  var isArchive = false.obs;
  var isRecent = true.obs;
  var isForecast = false.obs;
  TooltipBehavior? tooltipBehavior;
  DatePickerController dateRowController = DatePickerController();
  DateTime now = DateTime.now();
}
