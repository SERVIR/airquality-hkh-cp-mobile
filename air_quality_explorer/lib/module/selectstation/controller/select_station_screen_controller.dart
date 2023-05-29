import 'dart:developer';
import 'package:air_quality_explorer/core/base_url.dart';
import 'package:air_quality_explorer/core/color.dart';
import 'package:air_quality_explorer/models/chart_data.dart';
import 'package:air_quality_explorer/models/save_location_recent_response_model.dart';
import 'package:air_quality_explorer/module/savelocation/controller/save_location_screen_controller.dart';
import 'package:air_quality_explorer/services/api_services.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:xml/xml.dart';

class SelectStationScreenController extends GetxController {
  var isToday = true.obs;
  var isTomorrow = false.obs;
  var isDayAfter = false.obs;
  var iscustom = false.obs;
  var selecrRecentDate = "".obs;
  var isSave = false.obs;
  var selectFromDate = "".obs;
  var selectToDate = "".obs;
  var isselectDate = "".obs;
  var isApply = false.obs;
  var totalDays = 0.obs;
  RxBool isPM2Selected = true.obs;
  RxBool isO3Selected = false.obs;
  RxBool isSO2Selected = false.obs;
  TooltipBehavior? tooltipBehavior;
  DatePickerController dateRowController = DatePickerController();
  DateTime now = DateTime.now();
  late DateTime tomorrow = DateTime(now.year, now.month, now.day + 1);
  late DateTime dayAfter = DateTime(now.year, now.month, now.day + 2);
  DateTime selectFrom = DateTime.now();
  DateTime selectTo = DateTime.now();
  var dataList = [].obs;
  var dataSource = <ChartData>[].obs;
  var isLoading = false.obs;
  var polutantValue = 0.0.obs;
  var chartFromDate = "".obs;
  var chartToDate = "".obs;
  final saveScreenController = Get.find<SaveLocationScreenController>();
  var selectedIndex = 0.obs;
  var aquiMeterValue = 0.0.obs;
  ScrollController scrollController = ScrollController();
  var titleMessage = "".obs;
  var selectPollutantLayer = "".obs;
  var finalCalculationAqiMeterValue = 0.0.obs;
  var showMaxAqiPollutantNm = "".obs;
  var savelocationMaximumPollutantValue = 0.0.obs;

  // @override
  // void onInit() {
  //   // isLoading.value = true;
  //   super.onInit();
  // }

  selectDate() async {
    DateTime? pickedDate = await showDatePicker(
        builder: (context, child) {
          return Theme(
              data: ThemeData(
                colorScheme: const ColorScheme.light(
                  primary: AppColor.appButtonColor,
                ),
              ),
              child: child ?? const Text(""));
        },
        context: Get.context!,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 0)),
        lastDate: DateTime(2050));
    if (pickedDate != null) {
      var temp = DateFormat("dd/MM/yyyy").format(pickedDate);
      if (isselectDate.value == "0") {
        selectFrom = pickedDate;
        selectFromDate.value = temp;
      } else {
        selectTo = pickedDate;
        selectToDate.value = temp;
      }
      daysBetween(selectFrom, selectTo);
    }
  }

  daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    totalDays.value = (to.difference(from).inHours / 24).round() + 1;
  }

  /// Fultter share
  // Future<void> share() async {
  //   await FlutterShare.share(
  //       title: "ICIMOD AQE",
  //       linkUrl: "http://smog.icimod.org/apps/airquality/recent/");
  // }

  //// GetGroundObservation Data
  /*  Future getGroundObservationData(String stationID, String typeName,
      String modelClass, String modelClassList) {
    dataList.value = [];
    var startDate = DateFormat("yyyy-MM-dd").format(now);
    var endDate = DateFormat("yyyy-MM-dd").format(now);
    
    Map<String, dynamic> param = {
      "StartDate": startDate,
      "EndDate": "$endDate-23-59",
      "ModelClass": modelClass,
      "ModelClassDataList": modelClassList,
      "stId": stationID,
      "typeName": typeName
    };

    isLoading.value = true;
    return ApiServices.getSelectStationData(param).then((response) {
      if (response != null) {
        dataSource.clear();
        String temp = response['XaxisLabel'];
        String startDate = temp.substring(5, 21);
        String endDate = temp.substring(28, 44);
        chartFromDate.value =
            DateFormat('MMM-dd-yyyy').format(DateTime.parse(startDate));
        chartToDate.value =
            DateFormat('MMM-dd-yyyy').format(DateTime.parse(endDate));

        dataList.addAll(response['SeriesData']);
        if (dataList.isNotEmpty) {
          polutantValue.value = dataList[0][1];
          for (var element in dataList) {
            List<dynamic> temp = element as List;
            final DateTime dateNow = DateTime.fromMillisecondsSinceEpoch(
                (temp[0] as double).toInt());
            double value = saveScreenController.getAqiValueEquation(
                cp: temp[1] as double, pollutantType: "PM2.5");
            double aqiValue = value.roundToDouble();
            ChartData chartData = ChartData(dateNow, aqiValue);
            dataSource.add(chartData);
            isLoading.value = false;
          }
        } else {
          isLoading.value = false;
        }
      }
    });
  } */

  /* /// Set Message
  String setMessage({required double aqiMeterValue}) {
    var message = aquiMeterValue <= 50.0
        ? "It's a great day to be active outside."
        : aqiMeterValue <= 100
            ? "Unusually sensitive people: Consider making outdoor activities shorter and less intense. Watch for symptoms such as coughing or shortness of breath. These are signs to take it easier. \n\nEveryone else: It's a good day to be active outside."
            : aqiMeterValue <= 150
                ? "Sensitive groups: Make outdoor activities shorter and less intense. It's OK to be active outdoors, but take more breaks. Watch for symptoms such as coughing or shortness of breath. \n\nPeople with asthma: Follow your asthma action plan and keep quick relief medicine handy. \n\nPeople with heart disease: Symptoms such as palpitations, shortness of breath, or unusual fatigue may indicate a serious problem. If you have any of these, contact your health care provider."
                : aqiMeterValue <= 200
                    ? "Sensitive groups: Avoid long or intense outdoor activities. Consider rescheduling or moving activities indoors.* \n\nEveryone else: Reduce long or intense activities. Take more breaks during outdoor activities."
                    : aqiMeterValue <= 300
                        ? "Sensitive groups: Avoid all physical activity outdoors. Reschedule to a time when air quality is better or move activities indoors.* \n\nEveryone else: Avoid long or intense activities. Consider rescheduling or moving activities indoors.*"
                        : "Everyone: Avoid all physical activity outdoors. \n\nSensitive groups: Remain indoors and keep activity levels low. Follow tips for keeping particle levels low indoors.*";
    return message;
  } */

  //// Aqi meter value calculation
  double aqiValueCalculation(double value, String pollutantType) {
    var cpValue = value;
    if (pollutantType == "CO") {
      cpValue = value / 1000;
    } else if (pollutantType == "O3") {
      cpValue = value / 1000;
    }
    var temp = saveScreenController.getAqiValueEquation(
        cp: cpValue, pollutantType: pollutantType);
    String temp1 = temp.toStringAsFixed(2);
    aquiMeterValue.value = double.parse(temp1);
    return aquiMeterValue.value;
  }

  animateToIndex(int index) {
    double indextoDuble = 0.0;

    if (index > 3) {
      indextoDuble = double.parse(index.toString()) * 25;
    }
    scrollController.animateTo(
      indextoDuble,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutExpo,
    );
  }

  //// Get Recent And Archive Slice From Catalog
  Future getSliceCataLogApi(
      {double? latitude, double? longitude, String? tempPollutantType}) async {
    var startDate = DateFormat("yyyy-MM-dd")
        .format(DateTime(now.year, now.month, now.day - 7));
    var endDate = DateFormat("yyyy-MM-dd")
        .format(DateTime(now.year, now.month, now.day + 1));

    String pollutantLayerNm = tempPollutantType == "CO"
        ? "CO/GEOS-CO"
        : tempPollutantType == "NO2"
            ? "NO2/GEOS-NO2"
            : tempPollutantType == "O3"
                ? "O3/GEOS-O3"
                : tempPollutantType == "PM2.5"
                    ? "PM/GEOS-PM2p5"
                    : tempPollutantType == "SO2"
                        ? "SO2/GEOS-SO2"
                        : "";

    Map<String, dynamic> parameter = {
      "url": ApiUrl.sliceCatelogApiParamUrl
          .replaceFirst("pollutantLayerNm", pollutantLayerNm),
      "data_ext": ".nc",
      "startDate": startDate,
      "endDate": endDate
    };
    log("Recent date check : $startDate, end date : ${endDate}");

    await ApiServices.getSlicedFromCatalog(parameter).then((response) {
      if (response != null) {
        if (response['status'] == 200) {
          List sliceCatalog = response['data'];
          List temp = [];
          for (int i = 0; i < sliceCatalog.length; i++) {
            temp.add(
                "HKHAirQualityWatch/RecentAndArchive/$pollutantLayerNm/${sliceCatalog[i]}");
          }
          getTimeSeriseApi(
            temp,
            pollutantLayerNm,
            latitude ?? 0.0,
            longitude ?? 0.0,
            startDate,
            endDate,
          );
        }
      }
    });
  }

  //// Get Time Series Api
  /// third  Api
  getTimeSeriseApi(
      List sliceCatalogData,
      String pollutantLayerType,
      double latitude,
      double longitude,
      String startdate,
      String enddate) async {
    var pollutantLayer = pollutantLayerType == "CO/GEOS-CO"
        ? "CO"
        : pollutantLayerType == "NO2/GEOS-NO2"
            ? "NO2"
            : pollutantLayerType == "O3/GEOS-O3"
                ? "O3"
                : pollutantLayerType == "PM/GEOS-PM2p5"
                    ? "PM2p5"
                    : pollutantLayerType == "SO2/GEOS-SO2"
                        ? "SO2"
                        : "";
    Map<String, dynamic> parameter = {
      "DATADIR": sliceCatalogData,
      "LAYER": pollutantLayer,
      "wkt": "POINT($latitude $longitude)",
      "type": "Point"
    };
    log("recent param : $parameter");

    isLoading.value = true;
    await ApiServices.getTimeSeriseModleData(parameter).then((response) {
      if (response != null) {
        dataSource.clear();
        dataList.clear();
        if (response['status'] == 200) {
          dataList.addAll(response['SeriesData']);
          String temp = response['XaxisLabel'];
          String startDate = temp.substring(5, 15);
          String endDate = temp.substring(19, 29);
          if (dataList.isNotEmpty) {
            // polutantValue.value = dataList[0][1];
            for (var element in dataList) {
              List<dynamic> temp = element as List;
              final DateTime dateNow =
                  DateTime.fromMillisecondsSinceEpoch((temp[0]));
              // var pollutanttype =
              //     pollutantLayer == "PM2p5" ? "PM2.5" : pollutantLayer;

              // double value = saveScreenController.getAqiValueEquation(
              //     cp: temp[1] as double, pollutantType: pollutanttype);
              // double convertValue = double.parse(value.toStringAsFixed(2));
              double finalRecentChartValue = temp[1];
              ChartData chartData = ChartData(dateNow,
                  double.parse(finalRecentChartValue.round().toString()));
              dataSource.add(chartData);
              isLoading.value = false;
            }
            chartFromDate.value =
                DateFormat('MMMM-dd-yyyy').format(dataSource.first.dateTime);
            chartToDate.value =
                DateFormat('MMMM-dd-yyyy').format(dataSource.last.dateTime);
          } else {
            isLoading.value = false;
          }
        }
      }
    });
  }

  getTitleMessage({
    required double cp,
    required String pollutantType,
  }) {
    /// static value
    for (int i = 0;
        i < saveScreenController.equationCalculationTableArr.length;
        i++) {
      var temp = saveScreenController.equationCalculationTableArr[i];

      if (cp.clamp(temp.bpLo, temp.bpHi) == cp &&
          temp.pollutantLayerType == pollutantType) {
        titleMessage.value = temp.message ?? "";

        // cpValue = getFinalAqiValue(temp, cp);
      }
    }
  }

  //// Get Xml data from forecast
  getXmlDataAndForecastApiCall(
      {required String layername,
      required double latitude,
      required double longitude}) async {
    String yesterdaydate = DateFormat("yyyyMMdd")
        .format(DateTime(now.year, now.month, now.day - 1));
    isLoading.value = true;
    await ApiServices.getForecastXmlData(yesterdaydate).then((response) async {
      final xml = XmlDocument.parse(response);
      final catelog = xml.findElements('catalog').last;
      final dataset = catelog.findAllElements('dataset');
      List forecastIdList = [];
      for (final finaldata in dataset) {
        var temp = finaldata
            .findAllElements('dataset')
            .map(
              (e) => e.attributes,
            )
            .toList();
        for (int j = 0; j < temp.length; j++) {
          var result = temp[j][1];
          forecastIdList.add(result.value);
        }
      }
      forecastChartDataApiCall(
          forecastIdList: forecastIdList,
          latitude: latitude,
          longitude: longitude,
          layername: layername);
    });
  }

  //// Forecast Chart Data Api Call
  forecastChartDataApiCall(
      {required List forecastIdList,
      required String layername,
      required double latitude,
      required double longitude}) async {
    String finalLayerNm = "";
    if (layername == "PM2.5") {
      finalLayerNm = "PM25_SFC";
    } else if (layername == "O3") {
      finalLayerNm = "O3_TOTCOL";
    } else if (layername == "SO2") {
      finalLayerNm = "SO2_SFC";
    } else if (layername == "NO2") {
      finalLayerNm = "NO2_SFC";
    } else if (layername == "CO") {
      finalLayerNm = "CO_SFC";
    }
    Map<String, dynamic> parameter = {
      "DATADIR": forecastIdList,
      "LAYER": finalLayerNm,
      "wkt": "POINT($longitude $latitude)",
      "type": "Point"
    };

    await ApiServices.getForcastTimeSeriseModleData(parameter).then((response) {
      if (response != null) {
        dataSource.clear();
        dataList.clear();
        if (response['status'] == 200) {
          dataList.addAll(response['SeriesData']);
          String temp = response['XaxisLabel'];
          String startDate = temp.substring(5, 15);
          String endDate = temp.substring(19, 29);

          if (dataList.isNotEmpty) {
            for (var element in dataList) {
              List<dynamic> temp = element as List;
              final DateTime dateNow =
                  DateTime.fromMillisecondsSinceEpoch((temp[0]));
              double finalChartForecastValue = temp[1];
              ChartData chartData = ChartData(dateNow,
                  double.parse(finalChartForecastValue.round().toString()));
              dataSource.add(chartData);
              isLoading.value = false;
            }
            chartFromDate.value =
                DateFormat('MMMM-dd-yyyy').format(dataSource.first.dateTime);
            chartToDate.value =
                DateFormat('MMMM-dd-yyyy').format(dataSource.last.dateTime);
          } else {
            isLoading.value = false;
          }
        }
      } else {
        isLoading.value = false;
      }
    });
  }

  //// Get chart left title
  String chartLeftLable(String pollutantTypeNM) {
    String finalShowPollutantValue = "";
    if (pollutantTypeNM == "PM2.5") {
      finalShowPollutantValue = "ug/m3";
    } else if (pollutantTypeNM == "NO2") {
      finalShowPollutantValue = "ppb";
    } else if (pollutantTypeNM == "CO") {
      // finalShowPollutantValue = "ppm";
      finalShowPollutantValue = "ppb";
    } else if (pollutantTypeNM == "O3") {
      // finalShowPollutantValue = "ppm";
      finalShowPollutantValue = "ppb";
    } else if (pollutantTypeNM == "SO2") {
      finalShowPollutantValue = "ppb";
    } else if (pollutantTypeNM == "PM10") {
      finalShowPollutantValue = "ug/m3";
    }
    return finalShowPollutantValue;
  }

  //// Show Select statiopn screen in maximum AQI value
  showMAxAqiValue(List<Geo> pollutantList) async {
    List<Geo> tempPolutantList = pollutantList;
    //List tempMaxAqiValue = [];
    for (int i = 0; i < tempPolutantList.length; i++) {
      var aqiValue = aqiValueCalculation(
          tempPolutantList[i].value![1], tempPolutantList[i].name ?? "");
      tempPolutantList[i].aqiValue = aqiValue;
      //tempMaxAqiValue.add(aqiValue);

    }

    Geo highAQI = tempPolutantList.reduce((a, b) {
      if ((a.aqiValue ?? 0.0) > (b.aqiValue ?? 0.0)) {
        return a;
      } else {
        return b;
      }
    });

    savelocationMaximumPollutantValue.value = pollutantNmDecimalValue(
        pollutantNm: highAQI.name ?? "", pollutantValue: highAQI.value![1]);
    //var calculationMaxAqiValue = aqiValueCalculation(temp, tempPollutantTypeNM);
    finalCalculationAqiMeterValue.value = pollutantNmDecimalValue(
        pollutantNm: highAQI.name ?? "",
        pollutantValue: highAQI.aqiValue ?? 0.0);
    showMaxAqiPollutantNm.value =
        "${highAQI.name} ${chartLeftLable(highAQI.name ?? "")}";
  }

  //// Show pollutant Nm decimal value
  double pollutantNmDecimalValue(
      {required String pollutantNm, required double pollutantValue}) {
    double tempPollutantNM = 0.0;
    if (pollutantNm == "O3") {
      tempPollutantNM = double.parse(pollutantValue.toStringAsFixed(3));
    } else if (pollutantNm == "PM2.5") {
      tempPollutantNM = double.parse(pollutantValue.toStringAsFixed(1));
    } else if (pollutantNm == "CO") {
      tempPollutantNM = double.parse(pollutantValue.toStringAsFixed(1));
    } else if (pollutantNm == "PM10") {
      tempPollutantNM = pollutantValue.roundToDouble();
    } else if (pollutantNm == "SO2") {
      tempPollutantNM = pollutantValue.roundToDouble();
    } else if (pollutantNm == "NO2") {
      tempPollutantNM = pollutantValue.roundToDouble();
    }
    return tempPollutantNM;
  }
}
