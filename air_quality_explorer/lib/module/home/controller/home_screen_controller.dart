import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:air_quality_explorer/core/enum.dart';
import 'package:air_quality_explorer/database/check_insertdata.dart';
import 'package:air_quality_explorer/database/database_helper.dart';
import 'package:air_quality_explorer/main.dart';
import 'package:air_quality_explorer/models/airnow_marker_data_model.dart';
import 'package:air_quality_explorer/models/chart_data.dart';
import 'package:air_quality_explorer/models/select_pollutantnm_model.dart';
import 'package:air_quality_explorer/module/savelocation/controller/save_location_screen_controller.dart';
import 'package:air_quality_explorer/services/api_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class HomeScreenController extends GetxController {
  var selectDropdownValue = 'Recent'.obs;
  var selectIndex = 1.obs;
  var selectDateBool = false.obs;
  var menuButtonSelect = false.obs;
  var isFullScreen = false.obs;
  var isLoading = false.obs;
  var isInsert = false.obs;
  var isMorBtnTap = false.obs;
  var isCheck = false.obs;
  var isSearch = false.obs;
  var ifChangeDate = false.obs;
  var fps = 1.obs;
  var searchCityList = [].obs;
  var isSearchLoading = false.obs;
  var lat = 28.297931290299058.obs;
  var long = 83.79782166247044.obs;
  var searchLocationLat = 0.0.obs;
  var searchLocationLong = 0.0.obs;
  var searchCityName = "".obs;
  var zoom = 5.0.obs;
  var rangeSlider = 0.obs;
  var startDate = DateTime.now().obs;
  var endDate = DateTime.now().obs;
  var placeId = ''.obs;
  var isPlay = false.obs;
  TextEditingController searchController = TextEditingController();

  var arrPlayTotalDay = [];
  var selectDropdownList = ['Archive', 'Recent', 'Forecast'].obs;
  var showFullMap = false.obs;
  var isForcastRangeSelect = false.obs;
  var isArchivAndRecentSelect = false.obs;
  var isRecentSelect = true.obs;
  MapController mapControllers = MapController();
  final DateTime now = DateTime.now();
  late Rx<DateTime> dateMin = DateTime(now.year, now.month, now.day - 6).obs;
  late Rx<DateTime> dateMax = DateTime(now.year, now.month, now.day + 2).obs;
  late Rx<SfRangeValues> dateValues = SfRangeValues(
    DateTime(now.year, now.month, now.day),
    DateTime.now(),
  ).obs;
  DateTime value = DateTime.now();
  late String currentDate = DateFormat("yyyy-MM-dd")
      .format(DateTime(now.year, now.month, now.day - 1));
  List<SelectPollutantModel> arrLayers = [];
  List<SelectPollutantModel> selectedArrLayers = [];
  var dynamicLatitude = 0.0.obs;
  var dynamicLongitude = 0.0.obs;
  SfRangeValues values =
      SfRangeValues(DateTime(2002, 01, 01), DateTime(2004, 01, 01));
  var dataList = [].obs;
  var dataSource = <ChartData>[].obs;
  static GlobalKey previewContainer = GlobalKey();
  Timer? storeTime;
  var aeronetDataList = <DataClass>[].obs;
  var airnowDataList = <DataClass>[].obs;
  final saveController = Get.put(SaveLocationScreenController());
  List<SelectPollutantModel> layers = [];

  @override
  void onInit() {
    super.onInit();
    var todatDate = DateFormat("yyyy-MM-dd")
        .format(DateTime(now.year, now.month, now.day - 1));
    getLayers(todatDate);
    getAirnowListData();
    getAeronetListData();
  }

  /// search place
  void fetchPlace(String searchValue) async {
    return ApiServices.searchPlace(searchValue).then((response) {
      List list = response;
      if (list.isNotEmpty) {
        for (var i = 0; i < list.length; i++) {
          searchCityList.add(list[i]);
        }
      } else {
        isLoading.value = false;
      }
    });
  }

  /// Fultter share
  // Future<void> share() async {
  //   await FlutterShare.share(
  //       title: "ICIMOD AQE",
  //       linkUrl: "http://smog.icimod.org/apps/airquality/recent/");
  // }

  /// add fps speed
  void add() {
    if (fps.value != 6) fps.value++;
  }

  /// minus fps speed
  void minus() {
    if (fps.value != 1) fps.value--;
  }

  Future getGroundObservationData(String stationID, String typeName) {
    saveController.isAddLocation.value = true;
    dataList.value = [];
    var startDates = DateFormat("yyyy-MM-dd").format(now);
    var endDates = DateFormat("yyyy-MM-dd").format(now);
    Map<String, dynamic> param = {
      "StartDate": startDates,
      "EndDate": "$endDates-23-59",
      "ModelClass": "UsEmbassyPm",
      "ModelClassDataList": "UsEmbassyDataList",
      "stId": stationID,
      "typeName": typeName
    };

    return ApiServices.getSelectStationData(param).then((response) {
      var pollutantvalue = 0.0;
      isInsert.value = true;
      if (response != null) {
        var responseData = response['SeriesData'];
        if (responseData != null) {
          dataList.addAll(response['SeriesData']);
          if (dataList.isNotEmpty) {
            for (var element in dataList) {
              List<dynamic> temp = element as List;
              final DateTime dateNow = DateTime.fromMillisecondsSinceEpoch(
                  (temp[0] as double).toInt());
              ChartData chartData = ChartData(dateNow, temp[1] as double);
              dataSource.add(chartData);
              pollutantvalue = temp[1] as double;
            }
            insertData(
                locationNm: saveController.addLocationController.text,
                lat: dynamicLatitude.value,
                long: dynamicLongitude.value,
                stationId: 2,
                pollutantType: "PM2.5",
                pollutantValue: pollutantvalue);
            isInsert.value = false;
          } else {
            isInsert.value = false;
          }
        }
      }
    });
  }

  void insertData({
    String? locationNm,
    double? lat,
    double? long,
    int? stationId,
    double? pollutantValue,
    String? pollutantType,
  }) async {
    await dbHelper.init();
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnStartDate: DateTime.now().millisecondsSinceEpoch,
      DatabaseHelper.columnEndDate: DateTime.now().millisecondsSinceEpoch,
      DatabaseHelper.columnLocationNm: locationNm,
      DatabaseHelper.columnLat: lat,
      DatabaseHelper.columnLong: long,
      DatabaseHelper.columnStationList: 'UsEmbassyPm',
      DatabaseHelper.columnPollutantTableNm: 'UsEmbassyDataList',
      DatabaseHelper.columnStationId: stationId,
      DatabaseHelper.columnStationPollutantValue: pollutantValue,
      DatabaseHelper.columnStationPollutantType: pollutantType
    };

    await dbHelper.insert(row).then((value) {
      // getSqliteStorageData();
      saveController.getSqlDbStoreData();
    });
  }

  /// Surface Observation
  SelectPollutantModel mSurfaceObservariobAOD = SelectPollutantModel(
    pollutantNm: 'Surface Observation-AOD (AERONET)',
    status: false,
    showOpacity: false,
    isLayerType: false,
    showLegends: false,
  );

  /// Ground observation
  SelectPollutantModel mGroundObservationPM2 = SelectPollutantModel(
    pollutantNm: 'Ground Observation-PM2.5 (AirNow)',
    status: true,
    showOpacity: false,
    defaultSelect: true,
    isLayerType: false,
    showLegends: false,
  );

  /// Terramodis True color
  SelectPollutantModel mTerraModisTrueColor = SelectPollutantModel(
      pollutantNm: 'TerraModis-TrueColor',
      status: true,
      showLegends: false,
      layerenum: SelectPollutantLayerNM.terraModisTrueColor);

  /// Geos pm2.5
  SelectPollutantModel mGEOSPM2 = SelectPollutantModel(
      pollutantNm: 'GEOS PM2.5',
      status: false,
      layerenum: SelectPollutantLayerNM.modelPM25GEOS);

  //// Static date
  //// Terra Modis AOD
  SelectPollutantModel mTerraModisAOD = SelectPollutantModel(
      pollutantNm: 'TerraModis-AOD',
      status: false,
      layerenum: SelectPollutantLayerNM.satelliteAODTERRAMODIS);

  //// GEOS O3
  SelectPollutantModel mGEOSO3 = SelectPollutantModel(
      pollutantNm: 'GEOS O3',
      status: false,
      layerenum: SelectPollutantLayerNM.modelO3GEOS);

  /// Static
  //// TROPOMI SO2 (TROPOMI-GEE)
  SelectPollutantModel mTropomiSo2 = SelectPollutantModel(
      pollutantNm: 'TROPOMI SO2(TROPOMI-GEE)',
      status: false,
      layerenum: SelectPollutantLayerNM.satelliteSO2TROPOMIGEE);

  /// Static data
  /// GEOS SO2
  SelectPollutantModel mGEOSsO2 = SelectPollutantModel(
      pollutantNm: 'GEOS SO2',
      status: false,
      layerenum: SelectPollutantLayerNM.modelSO2GEOS);

  /// static data
  /// TROPOMI NO2
  SelectPollutantModel mTropomiNo2ServirAst = SelectPollutantModel(
      pollutantNm: 'TROPOMI NO2 (TROPOMI-GEE)',
      status: false,
      layerenum: SelectPollutantLayerNM.satelliteNO2TROPOMIGEE);

  ///static data
  /// GEOS NO2
  SelectPollutantModel mGEOSNO2 = SelectPollutantModel(
      pollutantNm: 'GEOS NO2',
      status: false,
      layerenum: SelectPollutantLayerNM.modelNO2GEOS);

  /// static data
  //// TROPOMI CO (TROPOMI-GEE)
  SelectPollutantModel mTropomiCoTropomiGee = SelectPollutantModel(
      pollutantNm: 'TROPOMI CO(TROPOMI-GEE)',
      status: false,
      layerenum: SelectPollutantLayerNM.satelliteCOTROPOMIGEE);

  /// static data
  //// GEOS CO
  SelectPollutantModel mGeosCo = SelectPollutantModel(
      pollutantNm: 'GEOS CO',
      status: false,
      layerenum: SelectPollutantLayerNM.modelCOGEOS);

  //// satelliteSO2TROPOMISERVIRAST,
  SelectPollutantModel sateliiteSO2ServirAst = SelectPollutantModel(
      pollutantNm: 'Satellite-SO2(TROPOMI-SERVIR AST)',
      status: false,
      layerenum: SelectPollutantLayerNM.satelliteSO2TROPOMISERVIRAST);
  // satelliteNO2TROPOMISERVIRAST,
  SelectPollutantModel sateliiteNO2ServirAst = SelectPollutantModel(
      pollutantNm: 'Satellite-NO2(TROPOMI-SERVIR AST)',
      status: false,
      layerenum: SelectPollutantLayerNM.satelliteNO2TROPOMISERVIRAST);

  // satelliteCO2TROPOMISERVIRAST,
  SelectPollutantModel sateliiteCO2ServirAst = SelectPollutantModel(
      pollutantNm: 'Satellite-CO2(TROPOMI-SERVIR AST)',
      status: false,
      layerenum: SelectPollutantLayerNM.satelliteCOTROPOMISERVIRAST);

  /// modelPM25WRFCHEM,
  SelectPollutantModel modelPM25ErfChem = SelectPollutantModel(
      pollutantNm: 'Model-PM2.5(WRF-Chem)',
      status: false,
      layerenum: SelectPollutantLayerNM.modelPM25WRFCHEM);

  // modelO3WRFCHEM,
  SelectPollutantModel modelO3WrfChem = SelectPollutantModel(
      pollutantNm: 'Model-O3(WRF-Chem)',
      status: false,
      layerenum: SelectPollutantLayerNM.modelO3WRFCHEM);

  // modelSO2WRFCHEM,
  SelectPollutantModel modelSO2WrfChem = SelectPollutantModel(
      pollutantNm: 'Model-SO2(WRF-Chem)',
      status: false,
      layerenum: SelectPollutantLayerNM.modelSO2WRFCHEM);

  // modelNO2WRFCHEM,
  SelectPollutantModel modelNO2WrfChem = SelectPollutantModel(
      pollutantNm: 'Model-NO2(WRF-Chem)',
      status: false,
      layerenum: SelectPollutantLayerNM.modelNO2WRFCHEM);

  // modelCOWRFCHEM,
  SelectPollutantModel modelCOWrfChem = SelectPollutantModel(
      pollutantNm: 'Model-CO(WRF-Chem)',
      status: false,
      layerenum: SelectPollutantLayerNM.modelCOWRFCHEM);
  getLayers(String date) {
    // Add layer value in array.
    arrLayers.add(mGroundObservationPM2);
    arrLayers.add(mTerraModisTrueColor);
    arrLayers.add(mGEOSPM2);
    arrLayers.add(modelPM25ErfChem);
    arrLayers.add(mTropomiCoTropomiGee);
    arrLayers.add(mGeosCo);
    arrLayers.add(sateliiteCO2ServirAst);
    arrLayers.add(modelCOWrfChem);
    arrLayers.add(mGEOSO3);
    arrLayers.add(modelO3WrfChem);
    arrLayers.add(mTerraModisAOD);
    arrLayers.add(mTropomiNo2ServirAst);
    arrLayers.add(mGEOSNO2);
    arrLayers.add(sateliiteNO2ServirAst);
    arrLayers.add(modelNO2WrfChem);
    arrLayers.add(mSurfaceObservariobAOD);
    arrLayers.add(mTropomiSo2);
    arrLayers.add(sateliiteSO2ServirAst);
    arrLayers.add(modelSO2WrfChem);
    arrLayers.add(mGEOSsO2);
  }

  SelectPollutantModel getLayerForPlay() {
    int findPlayIndex = arrLayers.indexWhere((element) =>
        element.pollutantNm == CheckInsertdata().selectPlayAnimationName);
    return arrLayers[findPlayIndex];
  }

  /// Get aeronet marker data
  getAeronetListData() async {
    await ApiServices.getAeronetApiData().then((response) {
      if (response != null) {
        if (response['status'] == 200) {
          var aeronetResponseData =
              GetAirnowDataResponseModel.fromJson(response);
          aeronetDataList.value = aeronetResponseData.data ?? [];
        }
      }
    });
  }

  /// Get airnow marker data
  getAirnowListData() async {
    return ApiServices.getAirnowApiData().then((response) {
      if (response != null) {
        if (response['status'] == 200) {
          var airnowResponseData =
              GetAirnowDataResponseModel.fromJson(response);
          airnowDataList.value = airnowResponseData.data ?? [];
        }
      }
    });
  }

  // /// Get Sqlite Storage Data
  // getSqliteStorageData() async {
  //   await dbHelper.init();
  //   saveLocationList.clear();
  //   final allRows = await dbHelper.queryAllRows();
  //   for (final row in allRows) {
  //     saveLocationList.add(SaveLocationSqlDbResponseModel.fromJson(row));
  //   }
  //   arrMarker("GroundObservation");
  // }

  var groundObservationAirnowMarkers = <Marker>[].obs;
  var surfaceObservationAeronetMarkers = <Marker>[].obs;

  /// String convert hex color
  getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }

  /// Set groung observation marker
  List<Marker> setGroundObservationMarker() {
    for (int i = 0; i < airnowDataList.length; i++) {
      Color iconColor = getColorFromHex(airnowDataList[i].color ?? "");
      groundObservationAirnowMarkers.add(
        Marker(
          point: LatLng(airnowDataList[i].latitude ?? 0.0,
              airnowDataList[i].longitude ?? 0.0),
          builder: (context) => DecoratedIcon(
            icon: Icon(Icons.square, size: 25, color: iconColor),
            decoration: const IconDecoration(
              border: IconBorder(width: 3),
            ),
          ),
        ),
      );
    }
    return groundObservationAirnowMarkers;
  }

  /// Set groung observation marker
  List<Marker> setSurfaceObservationMarker() {
    for (int i = 0; i < aeronetDataList.length; i++) {
      Color iconColor = getColorFromHex(aeronetDataList[i].color ?? "");
      surfaceObservationAeronetMarkers.add(
        Marker(
          point: LatLng(aeronetDataList[i].latitude ?? 0.0,
              aeronetDataList[i].longitude ?? 0.0),
          builder: (context) => DecoratedIcon(
            icon: Icon(Icons.arrow_drop_up, size: 50, color: iconColor),
            decoration: const IconDecoration(
              border: IconBorder(width: 3),
            ),
          ),
        ),
      );
    }
    return surfaceObservationAeronetMarkers;
  }

  //// Remove Marker
  removeDaynemicMarker() {
    if (saveController.dynamicMarkers.isNotEmpty) {
      for (int i = 0; i < saveController.dynamicMarkers.length; i++) {
        saveController.dynamicMarkers.removeAt(i);
      }
    }
  }

  Future<void> gotoSearchLocation(double lati, double longi) async {
    mapControllers.move(LatLng(lati, longi), 10);
    // saveController.dynamicMarkers.add(
    //   Marker(
    //     point: LatLng(lati, longi),
    //     builder: (context) => const Icon(
    //       Icons.room,
    //       size: 40,
    //       color: AppColor.redColor,
    //     ),
    //   ),
    // );
  }

  var playDate = "".obs;
  Timer? timer;
  Duration duration = const Duration(milliseconds: 3000);
  getPlayNPauseTimeDurationAnimation() async {
    var formatedDate = "";
    arrPlayTotalDay.clear();
    DateTime start =
        DateTime.parse(DateFormat("yyyy-MM-dd").format(startDate.value));
    DateTime endDatee =
        DateTime.parse(DateFormat("yyyy-MM-dd").format(endDate.value));

    var i = 0;
    fps.value == 2
        ? 2500
        : fps.value == 3
            ? 2000
            : fps.value == 4
                ? 1500
                : fps.value == 5
                    ? 1200
                    : fps.value == 6
                        ? 1000
                        : 3000;

    timer = Timer.periodic(duration, (timer) {
      if (isForcastRangeSelect.value != true) {
        DateTime temps = DateTime(start.month, start.day + i);
        if (temps.isBefore(endDatee)) {
          DateTime date = DateTime(startDate.value.year, startDate.value.month,
              startDate.value.day + i);
          formatedDate = DateFormat("yyyy-MM-dd").format(date);
          playDate.value = formatedDate;
          if (endDatee.isAtSameMomentAs(date)) {
            timer.cancel();
            i = 0;
            isPlay.value = false;
          } else {
            i++;
          }
        }
      } else {
        DateTime temps = DateTime(start.month, start.day, start.hour + i);
        if (endDatee.isAfter(temps)) {
          DateTime date = DateTime(startDate.value.year, startDate.value.month,
              startDate.value.day + 1, startDate.value.hour + i);
          formatedDate = DateFormat("yyyy-MM-dd HH:mm").format(date);
          playDate.value = formatedDate;
          if (endDatee.isAtSameMomentAs(date)) {
            timer.cancel();
            i = 0;
            isPlay.value = false;
          } else {
            i++;
          }
        }
      }
    });
  }

  GlobalKey globalKey = GlobalKey();
  //// Share screen shot
  captureScreenShot() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData =
        await (image.toByteData(format: ui.ImageByteFormat.png));
    writeByteToImageFile(byteData!);
  }

  writeByteToImageFile(ByteData byteData) async {
    Directory? dir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    File imageFile = File(
        "${dir?.path}/flutter/${DateTime.now().millisecondsSinceEpoch}.png");
    imageFile.createSync(recursive: true);
    imageFile.writeAsBytesSync(byteData.buffer.asUint8List(0));
    ShareExtend.share(imageFile.path, "file");
  }

  /*  getSliceApiPm2p5DataAeronet() async {
    surfaceObservationAeronetMarkers.value = [];
    isMapLoding.value = true;
    for (int i = 0; i < aeronetDataList.length; i++) {
      var startDates = DateFormat("yyyy-MM-dd").format(now);
      var endDates = DateFormat("yyyy-MM-dd").format(now);
      Map<String, dynamic> param = {
        "StartDate": startDates,
        "EndDate": "$endDates-23-59",
        "ModelClass": "UsEmbassyPm",
        "ModelClassDataList": "UsEmbassyDataList",
        "stId": aeronetDataList[i].stId.toString(),
        "typeName": "pm"
      };
      await ApiServices.getSelectStationData(param).then((response) async {
        if (response != null) {
          List responseData = response['SeriesData'];
          if (responseData.isNotEmpty) {
            var tempData = responseData[0][1];
            finalAqiValue.value = saveController.getAqiValueEquation(
                cp: tempData, pollutantType: "PM2.5");
            Color color = saveController.colorCodeAqiRange(finalAqiValue.value);
            surfaceObservationAeronetMarkers.add(Marker(
              height: 45,
              width: 45,
              point: LatLng(aeronetDataList[i].latitude ?? 0.0,
                  aeronetDataList[i].longitude ?? 0.0),
              builder: (context) => const Icon(Icons.arrow_drop_up,
                  color: Colors.green, size: 50),
            ));
          } else {
            surfaceObservationAeronetMarkers.add(Marker(
              height: 45,
              width: 45,
              point: LatLng(aeronetDataList[i].latitude ?? 0.0,
                  aeronetDataList[i].longitude ?? 0.0),
              builder: (context) =>
                  const Icon(Icons.arrow_drop_up, color: Colors.red, size: 50),
            ));
            return;
          }
        }
      });
    }
    isMapLoding.value = false;
  }

  getSliceApiPm2p5DataAirnow() async {
    groundObservationAirnowMarkers.value = [];
    isMapLoding.value = true;
    for (int i = 0; i < airnowDataList.length; i++) {
      var startDates = DateFormat("yyyy-MM-dd").format(now);
      var endDates = DateFormat("yyyy-MM-dd").format(now);
      Map<String, dynamic> param = {
        "StartDate": startDates,
        "EndDate": "$endDates-23-59",
        "ModelClass": "UsEmbassyPm",
        "ModelClassDataList": "UsEmbassyDataList",
        "stId": airnowDataList[i].stId.toString(),
        "typeName": "pm"
      };
      await ApiServices.getSelectStationData(param).then((response) async {
        if (response != null) {
          List responseData = response['SeriesData'];
          if (responseData.isNotEmpty) {
            var tempData = responseData[0][1];
            finalAqiValue.value = saveController.getAqiValueEquation(
                cp: tempData, pollutantType: "PM2.5");
            Color color = saveController.colorCodeAqiRange(finalAqiValue.value);
            List<Marker> temp = [];
            temp.add(Marker(
              height: 45,
              width: 45,
              point: LatLng(airnowDataList[i].latitude ?? 0.0,
                  airnowDataList[i].longitude ?? 0.0),
              builder: (context) => Icon(Icons.square, size: 25, color: color),
            ));
            groundObservationAirnowMarkers.addAll(temp);
          } else {
            return;
          }
        }
      });
    }
    isMapLoding.value = false;
  }
 */
}
