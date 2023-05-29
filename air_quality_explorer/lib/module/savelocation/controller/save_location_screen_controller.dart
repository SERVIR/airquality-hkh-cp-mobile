import 'dart:developer';

import 'package:air_quality_explorer/database/check_insertdata.dart';
import 'package:air_quality_explorer/database/database_helper.dart';
import 'package:air_quality_explorer/models/equation_model.dart';
import 'package:air_quality_explorer/models/pollutant_type_layer_response.dart';
import 'package:air_quality_explorer/models/save_location_recent_response_model.dart';
import 'package:air_quality_explorer/models/save_location_sql_db_response_model.dart';
import 'package:air_quality_explorer/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

class SaveLocationScreenController extends GetxController {
  // Database
  final dbHelper = DatabaseHelper();

  var isDeleteSaveLocationSelectBtn = false.obs;
  var isSelectIndex = 0.obs;
  var isLoading = false.obs;
  var nowDate = DateTime.now();
  var isSelectedsaveLocationValue = <int>[].obs;
  var stationId = "".obs;
  var addGroundObservationData = [];
  var saveLocationSqlDbList = <SaveLocationSqlDbResponseModel>[].obs;
  var saveLocationRecenteApiDataList = <RecentAndArchiveData>[].obs;
  var saveLocationForecastApiDataList = <RecentAndArchiveData>[].obs;
  var startDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  var endDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  TabController? tabController;
  var tabIndex = 0.obs;
  var pollutantTypeList = ["CO", "NO2", "O3", "PM", "SO2"].obs;
  var pollutantTypeIndex = 0.obs;
  var saveLocationApiList = <SaveLocationPollutantModel>[].obs;
  var checkCount = true;
  List<PollutantType> tempPollutantTypeArr = [];
  var equationCalculationTableArr = <EquationCalculationTableModel>[].obs;
  final Geolocator geolocator = Geolocator();
  var currentLatitude = 0.0.obs;
  var currentLongitude = 0.0.obs;
  ScrollController scrollController = ScrollController();
  var userAddRecentLocationList = <RecentAndArchiveData>[].obs;
  var userAddForecastLocationList = <RecentAndArchiveData>[].obs;
  var deleteLocationLoading = false.obs;
  var isForecastTabSelect = false.obs;
  var isMapLoding = false.obs;
  var saveSqlDataListToApiArr = <RecentAndArchiveData>[].obs;
  var addUserSqlliteDbMarkers = <Marker>[].obs;
  TextEditingController addLocationController = TextEditingController();
  var isAddLocation = false.obs;
  var finalAqiValue = 0.0.obs;
  var savelocationSelected = false.obs;
  List<Marker> dynamicMarkers = [];

  /// Get All List
  getAllList() async {
    tabIndex.value = 0;
    getCurrentPosition();
    await getSqlDbStoreData();
    getAllSqlListRecent();
    isDeleteSaveLocationSelectBtn.value = false;
    isSelectedsaveLocationValue.clear();
  }

  //// Delete Sqlite data
  void delete(int id) async {
    await dbHelper.delete(id).then((value) async {
      isDeleteSaveLocationSelectBtn.value = false;
      isSelectedsaveLocationValue.clear();

      await getSqlDbStoreData();

      // homecntrl.addUserSqlliteDbMarkers.removeWhere((element) =>
      //     element.point.latitude == deleteLocationlati &&
      //     element.point.longitude == deleteLocationlongi);

      if (isForecastTabSelect.value != true) {
        getAllSqlListRecent();
      } else {
        getAllSqlListForecast();
      }
    });
  }

  //// Insert Sqlite data
  Future insert(
      {String? locationNm,
      double? lat,
      double? long,
      int? stationId,
      String? pollutantType,
      double? pollutantValue}) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnStartDate: nowDate.millisecondsSinceEpoch,
      DatabaseHelper.columnEndDate: nowDate.millisecondsSinceEpoch,
      DatabaseHelper.columnLocationNm: locationNm,
      DatabaseHelper.columnLat: lat,
      DatabaseHelper.columnLong: long,
      DatabaseHelper.columnStationList: 'UsEmbassyPm',
      DatabaseHelper.columnPollutantTableNm: 'UsEmbassyDataList',
      DatabaseHelper.columnStationId: stationId,
      DatabaseHelper.columnStationPollutantType: pollutantType,
      DatabaseHelper.columnStationPollutantValue: pollutantValue
    };
    await dbHelper.insert(row);
  }

  //// Get Sqlite Data
  getSqlDbStoreData() async {
    await dbHelper.init();
    saveLocationSqlDbList.clear();
    saveLocationApiList.clear();
    final allRows = await dbHelper.queryAllRows();
    for (final row in allRows) {
      saveLocationSqlDbList.add(SaveLocationSqlDbResponseModel.fromJson(row));
    }
    arrMarker("GroundObservation");
  }

  /// Marker add
  arrMarker(String source) async {
    isMapLoding.value = true;
    var temp = [];
    for (int i = 0; i < saveLocationSqlDbList.length; i++) {
      temp.add([
        saveLocationSqlDbList[i].locationLat,
        saveLocationSqlDbList[i].locationLong,
        saveLocationSqlDbList[i].locationName
      ]);
    }

    Map<String, dynamic> param = {"points": temp};
    return ApiServices.getUserAddLocationRecentApi(param)
        .then((response) async {
      if (response != null) {
        SaveLocationRecentApiResponseModel userAddLocationResponseData =
            SaveLocationRecentApiResponseModel.fromJson(response);
        if (userAddLocationResponseData.status == 200) {
          saveSqlDataListToApiArr.value =
              userAddLocationResponseData.data ?? [];
          addUserSqlliteDbMarkers.value =
              setSqlDataListSurfaceObservationMarker("GroundObservation");
        }
        addLocationController.clear();
        Get.back();
        isAddLocation.value = false;
      }
    });
    // }
  }

  List<Marker> setSqlDataListSurfaceObservationMarker(String? source) {
    List<Marker> tempMarker = [];
    for (int i = 0; i < saveSqlDataListToApiArr.length; i++) {
      var tempData = saveSqlDataListToApiArr[i].geos?.first.value?[1];
      finalAqiValue.value =
          getAqiValueEquation(cp: tempData ?? 0.0, pollutantType: "PM2.5");
      Color color = colorCodeAqiRange(finalAqiValue.value);
      dynamicMarkers.clear();
      tempMarker.add(
        Marker(
          point: LatLng(saveSqlDataListToApiArr[i].latitude ?? 0.0,
              saveSqlDataListToApiArr[i].longitude ?? 0.0),
          builder: (context) {
            Widget? iconWidget;
            if (source == "SureFaceObservation") {
              iconWidget = DecoratedIcon(
                icon: Icon(Icons.arrow_drop_up, size: 50, color: color),
                decoration: const IconDecoration(
                  border: IconBorder(width: 3),
                ),
              );
            } else {
              iconWidget = DecoratedIcon(
                icon: Icon(Icons.square, size: 25, color: color),
                decoration: const IconDecoration(
                  border: IconBorder(width: 3),
                ),
              );
            }
            return iconWidget;
          },
        ),
      );
    }
    isMapLoding.value = false;
    return tempMarker;
  }

  /// Get User current location permission
  //// Get User current location lat and long
  Future<void> getCurrentPosition() async {
    final hasPermission =
        await CheckInsertdata().handleDevicesLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      currentLatitude.value = position.latitude;
      currentLongitude.value = position.longitude;
      getSaveRecentApiResponse(position.latitude, position.longitude);
    }).catchError((e) {
      log(e);
    });
  }

  //// Get Savelocation Recent Api Response
  getSaveRecentApiResponse(double latitude, double longitude) {
    isLoading.value = true;

    Map<String, dynamic> param = {"lat": latitude, "long": longitude};
    return ApiServices.getSaveLocationRecente(param).then((response) async {
      if (response != null) {
        isLoading.value = false;
        SaveLocationRecentApiResponseModel
            saveNearestRecentLocatonApiResponseModel =
            SaveLocationRecentApiResponseModel.fromJson(response);
        if (saveNearestRecentLocatonApiResponseModel.status == 200) {
          saveLocationRecenteApiDataList.value =
              addSaveLocationListData(saveNearestRecentLocatonApiResponseModel);
        }
      }
    });
  }

  //// Get Savelocation Forecast Api Response
  getSaveForcasteApiResponse(double latitude, double longitude) {
    isLoading.value = true;

    Map<String, dynamic> param = {"lat": latitude, "long": longitude};
    return ApiServices.getSaveLocationForecaste(param).then((response) async {
      if (response != null) {
        isLoading.value = false;
        SaveLocationRecentApiResponseModel
            saveNearestForecastLocatonApiResponseModel =
            SaveLocationRecentApiResponseModel.fromJson(response);
        if (saveNearestForecastLocatonApiResponseModel.status == 200) {
          saveLocationForecastApiDataList.value = addSaveLocationListData(
              saveNearestForecastLocatonApiResponseModel);
        }
      }
    });
  }

/*   moveToNextCall({int? index}) {
    if (saveLocationSqlDbList.length > index!) {
      for (int i = index; i < saveLocationSqlDbList.length; i++) {
        if (checkCount) {
          getSliceCataLogApi(
              latitude: saveLocationSqlDbList[i].locationLat,
              longitude: saveLocationSqlDbList[i].locationLong,
              locationName: saveLocationSqlDbList[i].locationName,
              // source: saveLocationSqlDbList[i].s,
              stationId: saveLocationSqlDbList[i].stationId.toString(),
              index: index);
          checkCount = false;
          pollutantTypeIndex.value = 0;
        }
      }
    } else {
      isLoading.value = false;
    }
  } */

  //// Get Aqi data api call
  Future<double> getAqiData(
      {required String stationId,
      required String pollutantNM,
      required String modelClass,
      required String modelClassList}) async {
    double? tempAqiValue;
    //// Get Aqi value in fetch get data api
    Map<String, dynamic> param = {
      "StartDate": startDate,
      "EndDate": "$endDate-23-59",
      "ModelClass": modelClass,
      "ModelClassDataList": modelClassList,
      "stId": stationId,
      "typeName": pollutantNM
    };

    await ApiServices.getSelectStationData(param).then((response) {
      if (response != null) {
        List temp = response['SeriesData'];
        tempAqiValue = temp.isEmpty ? 0.0 : temp[0][1];
      }
    });
    return tempAqiValue!;
  }

  /* //// Get Recent And Archive Slice From Catalog
  Future getSliceCataLogApi(
      {double? latitude,
      double? longitude,
      String? locationName,
      int? index,
      String? source,
      String? stationId}) async {
    var tempPollutantType = pollutantTypeList[pollutantTypeIndex.value];
    String pollutantLayerNm = tempPollutantType == "CO"
        ? "CO/GEOS-CO"
        : tempPollutantType == "NO2"
            ? "NO2/GEOS-NO2"
            : tempPollutantType == "O3"
                ? "O3/GEOS-O3"
                : tempPollutantType == "PM"
                    ? "PM/GEOS-PM2p5"
                    : tempPollutantType == "SO2"
                        ? "SO2/GEOS-SO2"
                        : "";

    Map<String, dynamic> parameter = {
      "url":
          "http://smog.spatialapps.net:8080/thredds/catalog/HKHAirQualityWatch/RecentAndArchive/$pollutantLayerNm/catalog.xml",
      "data_ext": ".nc",
      "startDate": "2023-04-04",
      "endDate": "2023-04-05"
    };
    await ApiServices.getSlicedFromCatalog(parameter).then((response) {
      if (response != null) {
        if (response['status'] == 200) {
          List sliceCatalog = response['data'];
          getTimeSeriseApi(
              sliceCatalog.last,
              pollutantLayerNm,
              latitude ?? 0.0,
              longitude ?? 0.0,
              locationName ?? "",
              index ?? 0,
              source ?? "",
              stationId ?? "");
        }
      }
    });
  }

  //// Get Time Series Api
  /// third  Api
  getTimeSeriseApi(
      String urlEndPoint,
      String pollutantLayerType,
      double latitude,
      double longitude,
      String locationName,
      int index,
      String source,
      String stationId) async {
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
      "DATADIR": [
        "HKHAirQualityWatch/RecentAndArchive/$pollutantLayerType/$urlEndPoint"
      ],
      "LAYER": pollutantLayer,
      "wkt": "POINT($latitude $longitude)",
      "type": "Point"
    };
    
    await ApiServices.getTimeSeriseModleData(parameter).then((response) {
      if (response != null) {
        if (response['status'] == 200) {
          var seriesData = response['SeriesData'][0][1];
          tempPollutantTypeArr.add(PollutantType(
              pollutantTypeNm: pollutantLayer, pollutantValue: seriesData));
          if (pollutantTypeIndex.value == 4) {
            checkCount = true;
            moveToNextCall(index: index + 1);
            saveLocationApiList.add(SaveLocationPollutantModel(
                locationName: locationName,
                source: source,
                stationId: stationId,
                pollutantLayerList: tempPollutantTypeArr));

            tempPollutantTypeArr = [];
          } else {
            pollutantTypeIndex += 1;
            getSliceCataLogApi(
                index: index,
                locationName: locationName,
                stationId: stationId,
                source: source);
          }
        }
      }
    });
  } */

  //// Store Equation Table
  storeEuationTable() {
    equationCalculationTableArr.clear();
    /********* Good *********/
    EquationCalculationTableModel o3Good = EquationCalculationTableModel(
        id: 1,
        pollutantLayerType: "O3",
        bpLo: 0.000,
        bpHi: 0.054,
        iLo: 0,
        iHi: 50,
        hour: 8,
        category: "Good",
        message: "None");
    EquationCalculationTableModel pm2p5Good = EquationCalculationTableModel(
        id: 2,
        pollutantLayerType: "PM2.5",
        bpLo: 0.0,
        bpHi: 12.0,
        iLo: 0,
        iHi: 50,
        hour: 24,
        category: "Good",
        message: "None");
    EquationCalculationTableModel pm10Good = EquationCalculationTableModel(
        id: 3,
        pollutantLayerType: "Pm10",
        bpLo: 0,
        bpHi: 54,
        iLo: 0,
        iHi: 50,
        hour: 24,
        category: "Good",
        message: "None");
    EquationCalculationTableModel cOGood = EquationCalculationTableModel(
        id: 4,
        pollutantLayerType: "CO",
        bpLo: 0.0,
        bpHi: 4.4,
        iLo: 0,
        iHi: 50,
        hour: 8,
        category: "Good",
        message: "None");
    EquationCalculationTableModel sO2Good = EquationCalculationTableModel(
        id: 5,
        pollutantLayerType: "SO2",
        bpLo: 0,
        bpHi: 35,
        iLo: 0,
        iHi: 50,
        hour: 1,
        category: "Good",
        message: "None");
    EquationCalculationTableModel nO2Good = EquationCalculationTableModel(
        id: 6,
        pollutantLayerType: "NO2",
        bpLo: 0,
        bpHi: 53,
        iLo: 0,
        iHi: 50,
        hour: 1,
        category: "Good",
        message: "None");

    /******* Moderate ********/
    EquationCalculationTableModel o3Moderate = EquationCalculationTableModel(
        id: 7,
        pollutantLayerType: "O3",
        bpLo: 0.055,
        bpHi: 0.070,
        iLo: 51,
        iHi: 100,
        hour: 8,
        category: "Moderate",
        message:
            "Unusually sensitive people should consider reducing prolonged or heavy outdoor exertion");
    EquationCalculationTableModel pm2p5Moderate = EquationCalculationTableModel(
        id: 8,
        pollutantLayerType: "PM2.5",
        bpLo: 12.1,
        bpHi: 35.4,
        iLo: 51,
        iHi: 100,
        hour: 24,
        category: "Moderate",
        message:
            "Unusually sensitive people should consider reducing prolonged or heavy exertion.");
    EquationCalculationTableModel pm10Moderate = EquationCalculationTableModel(
        id: 9,
        pollutantLayerType: "PM10",
        bpLo: 55,
        bpHi: 154,
        iLo: 51,
        iHi: 100,
        hour: 24,
        category: "Moderate",
        message:
            "Unusually sensitive people should consider reducing prolonged or heavy exertion.");
    EquationCalculationTableModel cOModerate = EquationCalculationTableModel(
        id: 10,
        pollutantLayerType: "CO",
        bpLo: 4.5,
        bpHi: 9.4,
        iLo: 51,
        iHi: 100,
        hour: 8,
        category: "Moderate",
        message: "None");
    EquationCalculationTableModel sO2Moderate = EquationCalculationTableModel(
        id: 11,
        pollutantLayerType: "SO2",
        bpLo: 36,
        bpHi: 75,
        iLo: 51,
        iHi: 100,
        hour: 1,
        category: "Moderate",
        message: "None");
    EquationCalculationTableModel nO2Moderate = EquationCalculationTableModel(
        id: 12,
        pollutantLayerType: "NO2",
        bpLo: 54,
        bpHi: 100,
        iLo: 51,
        iHi: 100,
        hour: 1,
        category: "Moderate",
        message:
            "Unusually sensitive consider limiting prolonged exertion especially near busy roads.");

    /******* Unhealthy For Sensitive Groups *********/
    EquationCalculationTableModel o3UnhealthyForSensiGrp =
        EquationCalculationTableModel(
            id: 13,
            pollutantLayerType: "O3",
            bpLo: 0.071,
            bpHi: 0.085,
            iLo: 101,
            iHi: 150,
            hour: 8,
            category: "Unhealthy for Sensitive Groups",
            message:
                "People with lung disease (such as asthma), children, older adults, people who are active outdoors (including outdoor workers), people with certain genetic variants, and people with diets limited in certain nutrients should reduce prolonged or heavy outdoor exertion.");
    EquationCalculationTableModel o3UnhealthyForSensiGrp1Hour =
        EquationCalculationTableModel(
            id: 14,
            pollutantLayerType: "O3",
            bpLo: 0.125,
            bpHi: 0.164,
            iLo: 101,
            iHi: 150,
            hour: 1,
            category: "Unhealthy for Sensitive Groups",
            message:
                "People with lung disease (such as asthma), children, older adults, people who are active outdoors (including outdoor workers), people with certain genetic variants, and people with diets limited in certain nutrients should reduce prolonged or heavy outdoor exertion.");
    EquationCalculationTableModel pm2p5UnhealthyForSensiGrp =
        EquationCalculationTableModel(
            id: 15,
            pollutantLayerType: "PM2.5",
            bpLo: 35.5,
            bpHi: 55.4,
            iLo: 101,
            iHi: 150,
            hour: 24,
            category: "Unhealthy for Sensitive Groups",
            message:
                "People with heart or lung disease, older adults, children. and peoole or lower socioeconomic status should reduce prolonged or heavy exertion.");
    EquationCalculationTableModel pm10UnhealthyForSensiGrp =
        EquationCalculationTableModel(
            id: 16,
            pollutantLayerType: "PM10",
            bpLo: 155,
            bpHi: 254,
            iLo: 101,
            iHi: 150,
            hour: 24,
            category: "Unhealthy for Sensitive Groups",
            message:
                "People with heart or lung disease, older adults, children. and peoole or lower socioeconomic status should reduce prolonged or heavy exertion.");
    EquationCalculationTableModel cOUnhealthyForSensiGrp =
        EquationCalculationTableModel(
            id: 17,
            pollutantLayerType: "CO",
            bpLo: 9.5,
            bpHi: 12.4,
            iLo: 101,
            iHi: 150,
            hour: 8,
            category: "Unhealthy for Sensitive Groups",
            message:
                "People with heart disease, such as angina, should limit heavv exertion and avoid sources of CO, such as heavy traffic.");
    EquationCalculationTableModel sO2UnhealthyForSensiGrp =
        EquationCalculationTableModel(
            id: 18,
            pollutantLayerType: "SO2",
            bpLo: 76,
            bpHi: 185,
            iLo: 101,
            iHi: 150,
            hour: 1,
            category: "Unhealthy for Sensitive Groups",
            message:
                "People with asthma should consider limiting outdoor exertion.");
    EquationCalculationTableModel nO2UnhealthyForSensiGrp =
        EquationCalculationTableModel(
            id: 19,
            pollutantLayerType: "NO2",
            bpLo: 101,
            bpHi: 360,
            iLo: 101,
            iHi: 150,
            hour: 1,
            category: "Unhealthy for Sensitive Groups",
            message:
                "People with asthma, children and older adults should limit roogeo exeon especial near busv roads.");

    /******* Unhealthy *********/
    EquationCalculationTableModel o3Unhealthy = EquationCalculationTableModel(
        id: 20,
        pollutantLayerType: "O3",
        bpLo: 0.086,
        bpHi: 0.105,
        iLo: 151,
        iHi: 200,
        hour: 8,
        category: "Unhealthy",
        message:
            "People with lung disease (such as asthma), children, older adults, people who are active outdoors (including outdoor workers), people with certain genetic variants, and people with I diets limited in certain nutrients should avoid prolonged or heavy outdoor exertion everyone else should reduce prolonged or heavy outdoor exertion");
    EquationCalculationTableModel o3Unhealthy1Hour = EquationCalculationTableModel(
        id: 21,
        pollutantLayerType: "O3",
        bpLo: 0.165,
        bpHi: 0.204,
        iLo: 151,
        iHi: 200,
        hour: 1,
        category: "Unhealthy",
        message:
            "People with lung disease (such as asthma), children, older adults, people who are active outdoors (including outdoor workers), people with certain genetic variants, and people with I diets limited in certain nutrients should avoid prolonged or heavy outdoor exertion everyone else should reduce prolonged or heavy outdoor exertion");
    EquationCalculationTableModel pm2p5Unhealthy = EquationCalculationTableModel(
        id: 22,
        pollutantLayerType: "PM2.5",
        bpLo: 55.5,
        bpHi: 150.4,
        iLo: 151,
        iHi: 200,
        hour: 24,
        category: "Unhealthy",
        message:
            "People with heart or lung disease, older adults, children, and people of lower socioeconomic status I should avoid prolonged or heavy exertion: everyone else should reduce prolonged or heavy exertion.");
    EquationCalculationTableModel pm10Unhealthy = EquationCalculationTableModel(
        id: 23,
        pollutantLayerType: "PM10",
        bpLo: 255,
        bpHi: 354,
        iLo: 151,
        iHi: 200,
        hour: 24,
        category: "Unhealthy",
        message:
            "People with heart or lung disease, older adults, children, and people of lower socioeconomic status I should avoid prolonged or heavy exertion: everyone else should reduce prolonged or heavy exertion.");
    EquationCalculationTableModel cOUnhealthy = EquationCalculationTableModel(
        id: 24,
        pollutantLayerType: "CO",
        bpLo: 12.5,
        bpHi: 15.4,
        iLo: 151,
        iHi: 200,
        hour: 8,
        category: "Unhealthy",
        message:
            "People with heart disease. such as angina, should limit moderate exertion and avoid sources of CO, I such as heavy traffic");
    EquationCalculationTableModel sO2Unhealthy = EquationCalculationTableModel(
        id: 25,
        pollutantLayerType: "SO2",
        bpLo: 186,
        bpHi: 304,
        iLo: 151,
        iHi: 200,
        hour: 1,
        category: "Unhealthy",
        message:
            "Children, people with asthma, or other lung diseases should limit outdoor exertion");
    EquationCalculationTableModel nO2Unhealthy = EquationCalculationTableModel(
        id: 26,
        pollutantLayerType: "NO2",
        bpLo: 361,
        bpHi: 649,
        iLo: 151,
        iHi: 200,
        hour: 1,
        category: "Unhealthy",
        message:
            "People with asthma, children and older adults should avoid prolonged exertion near roadways; everyone else chould limit prolonged exertion especially near Dusv roade");

    /******* Very unhealthy *********/
    EquationCalculationTableModel o3VeryUnhealthy = EquationCalculationTableModel(
        id: 27,
        pollutantLayerType: "O3",
        bpLo: 0.106,
        bpHi: 0.200,
        iLo: 201,
        iHi: 300,
        hour: 8,
        category: "Very Unhealthy",
        message:
            "People with lung disease (such as asthma), children, older adults. people who are active outdoors (including outdoor workers). people with certain genetic variants and neonle with dote limited in certain nutrient chauld avaid all outdoor exertion: evervone else should reduce outdoor exertion");
    EquationCalculationTableModel o3VeryUnhealthy1Hour =
        EquationCalculationTableModel(
            id: 28,
            pollutantLayerType: "O3",
            bpLo: 0.205,
            bpHi: 0.404,
            iLo: 201,
            iHi: 300,
            hour: 1,
            category: "Very Unhealthy",
            message:
                "People with lung disease (such as asthma), children, older adults. people who are active outdoors (including outdoor workers). people with certain genetic variants and neonle with dote limited in certain nutrient chauld avaid all outdoor exertion: evervone else should reduce outdoor exertion");
    EquationCalculationTableModel pm2p5VeryUnhealthy =
        EquationCalculationTableModel(
            id: 29,
            pollutantLayerType: "PM2.5",
            bpLo: 150.5,
            bpHi: 250.4,
            iLo: 201,
            iHi: 300,
            hour: 24,
            category: "Very Unhealthy",
            message:
                "Peoole with heart or lung disease older adults children, and people of lower socioeconomic status should avoid all physical activity outdoors. Everyone else should avoid prolonged or heavy exertion.");
    EquationCalculationTableModel pm10VeryUnhealthy = EquationCalculationTableModel(
        id: 30,
        pollutantLayerType: "PM10",
        bpLo: 355,
        bpHi: 424,
        iLo: 201,
        iHi: 300,
        hour: 24,
        category: "Very Unhealthy",
        message:
            "Peoole with heart or lung disease older adults children, and people of lower socioeconomic status should avoid all physical activity outdoors. Everyone else should avoid prolonged or heavy exertion.");
    EquationCalculationTableModel cOVeryUnhealthy = EquationCalculationTableModel(
        id: 31,
        pollutantLayerType: "CO",
        bpLo: 15.5,
        bpHi: 30.4,
        iLo: 201,
        iHi: 300,
        hour: 8,
        category: "Very Unhealthy",
        message:
            "People with heart disease, such as angina, should avoid exertion and sources of CO, such as heavytraffic.");
    EquationCalculationTableModel sO2VeryUnhealthy = EquationCalculationTableModel(
        id: 32,
        pollutantLayerType: "SO2",
        bpLo: 305,
        bpHi: 604,
        iLo: 201,
        iHi: 300,
        hour: 1,
        category: "Very Unhealthy",
        message:
            "Children, people with asthma, or other lung diseases should avoid outdoor exertion everyone else should reduce outdoor exertion");
    EquationCalculationTableModel nO2VeryUnhealthy = EquationCalculationTableModel(
        id: 33,
        pollutantLayerType: "NO2",
        bpLo: 650,
        bpHi: 1249,
        iLo: 201,
        iHi: 300,
        hour: 1,
        category: "Very Unhealthy",
        message:
            "People with asthma, children and older adults should avoid all outdoor exertion everyone else should avoid prolonged exertion especially near busv roads");

    /******* Hazardous *********/
    EquationCalculationTableModel o3Hazardous1Hour =
        EquationCalculationTableModel(
            id: 34,
            pollutantLayerType: "O3",
            bpLo: 0.405,
            bpHi: 0.504,
            iLo: 301,
            iHi: 400,
            hour: 1,
            category: "Hazardous",
            message: "Evervone should avoid all outdoor exertion.");
    EquationCalculationTableModel pm2p5Hazardous = EquationCalculationTableModel(
        id: 35,
        pollutantLayerType: "PM2.5",
        bpLo: 250.5,
        bpHi: 350.4,
        iLo: 301,
        iHi: 400,
        hour: 24,
        category: "Hazardous",
        message:
            "Evervone should avoid all ohysical activity outdoors: people with heart or lung disease, older adults children, and people of lower socioeconomic status should remain indoors and keep activity levels low.");
    EquationCalculationTableModel pm10Hazardous = EquationCalculationTableModel(
        id: 36,
        pollutantLayerType: "PM10",
        bpLo: 425,
        bpHi: 504,
        iLo: 301,
        iHi: 400,
        hour: 24,
        category: "Hazardous",
        message:
            "Evervone should avoid all ohysical activity outdoors: people with heart or lung disease, older adults children, and people of lower socioeconomic status should remain indoors and keep activity levels low.");
    EquationCalculationTableModel cOHazardous = EquationCalculationTableModel(
        id: 37,
        pollutantLayerType: "CO",
        bpLo: 30.5,
        bpHi: 40.4,
        iLo: 301,
        iHi: 400,
        hour: 8,
        category: "Hazardous",
        message:
            "People with heart disease, such as angina, should avoid avortion and coureos of CO. such as heavy traffic everyone else should limit heavy exertion");
    EquationCalculationTableModel sO2Hazardous = EquationCalculationTableModel(
        id: 38,
        pollutantLayerType: "SO2",
        bpLo: 605,
        bpHi: 804,
        iLo: 301,
        iHi: 400,
        hour: 1,
        category: "Hazardous",
        message:
            "Children. people with asthma, or other lung diseases, should remain indoors, everyone else should avoid outdoor exertion");
    EquationCalculationTableModel nO2Hazardous = EquationCalculationTableModel(
        id: 39,
        pollutantLayerType: "NO2",
        bpLo: 1250,
        bpHi: 1649,
        iLo: 301,
        iHi: 400,
        hour: 1,
        category: "Hazardous",
        message:
            "People with asthma. children and older adults should remain indoors everyone else should avoid all outdoor exertion");

/******* Hazardous Two *********/
    EquationCalculationTableModel o3Hazardous21Hour =
        EquationCalculationTableModel(
            id: 40,
            pollutantLayerType: "O3",
            bpLo: 0.505,
            bpHi: 0.604,
            iLo: 401,
            iHi: 500,
            hour: 1,
            category: "Hazardous Two",
            message: "Evervone should avoid all outdoor exertion.");
    EquationCalculationTableModel pm2p5Hazardous2 = EquationCalculationTableModel(
        id: 41,
        pollutantLayerType: "PM2.5",
        bpLo: 350.5,
        bpHi: 500.4,
        iLo: 401,
        iHi: 500,
        hour: 24,
        category: "Hazardous Two",
        message:
            "Evervone should avoid all ohysical activity outdoors: people with heart or lung disease, older adults children, and people of lower socioeconomic status should remain indoors and keep activity levels low.");
    EquationCalculationTableModel pm10Hazardous2 = EquationCalculationTableModel(
        id: 42,
        pollutantLayerType: "PM10",
        bpLo: 505,
        bpHi: 604,
        iLo: 401,
        iHi: 500,
        hour: 24,
        category: "Hazardous Two",
        message:
            "Evervone should avoid all ohysical activity outdoors: people with heart or lung disease, older adults children, and people of lower socioeconomic status should remain indoors and keep activity levels low.");
    EquationCalculationTableModel cOHazardous2 = EquationCalculationTableModel(
        id: 43,
        pollutantLayerType: "CO",
        bpLo: 40.5,
        bpHi: 50.5,
        iLo: 401,
        iHi: 500,
        hour: 8,
        category: "Hazardous Two",
        message:
            "People with heart disease, such as angina, should avoid avortion and coureos of CO. such as heavy traffic everyone else should limit heavy exertion");
    EquationCalculationTableModel sO2Hazardous2 = EquationCalculationTableModel(
        id: 44,
        pollutantLayerType: "SO2",
        bpLo: 805,
        bpHi: 1004,
        iLo: 401,
        iHi: 500,
        hour: 1,
        category: "Hazardous Two",
        message:
            "Children. people with asthma, or other lung diseases, should remain indoors, everyone else should avoid outdoor exertion");
    EquationCalculationTableModel nO2Hazardous2 = EquationCalculationTableModel(
        id: 45,
        pollutantLayerType: "NO2",
        bpLo: 1650,
        bpHi: 2049,
        iLo: 401,
        iHi: 500,
        hour: 1,
        category: "Hazardous Two",
        message:
            "People with asthma. children and older adults should remain indoors everyone else should avoid all outdoor exertion");

    /********* Good *********/
    equationCalculationTableArr.add(o3Good);
    equationCalculationTableArr.add(pm2p5Good);
    equationCalculationTableArr.add(pm10Good);
    equationCalculationTableArr.add(cOGood);
    equationCalculationTableArr.add(sO2Good);
    equationCalculationTableArr.add(nO2Good);
    /********* Moderate *********/
    equationCalculationTableArr.add(o3Moderate);
    equationCalculationTableArr.add(pm2p5Moderate);
    equationCalculationTableArr.add(pm10Moderate);
    equationCalculationTableArr.add(cOModerate);
    equationCalculationTableArr.add(sO2Moderate);
    equationCalculationTableArr.add(nO2Moderate);
    /******* Unhealthy For Sensitive Groups *********/
    equationCalculationTableArr.add(o3UnhealthyForSensiGrp);
    equationCalculationTableArr.add(o3UnhealthyForSensiGrp1Hour);
    equationCalculationTableArr.add(pm2p5UnhealthyForSensiGrp);
    equationCalculationTableArr.add(pm10UnhealthyForSensiGrp);
    equationCalculationTableArr.add(cOUnhealthyForSensiGrp);
    equationCalculationTableArr.add(sO2UnhealthyForSensiGrp);
    equationCalculationTableArr.add(nO2UnhealthyForSensiGrp);
    /******* Unhealthy *********/
    equationCalculationTableArr.add(o3Unhealthy);
    equationCalculationTableArr.add(o3Unhealthy1Hour);
    equationCalculationTableArr.add(pm2p5Unhealthy);
    equationCalculationTableArr.add(pm10Unhealthy);
    equationCalculationTableArr.add(cOUnhealthy);
    equationCalculationTableArr.add(sO2Unhealthy);
    equationCalculationTableArr.add(nO2Unhealthy);
    /******* Very Unhealthy *********/
    equationCalculationTableArr.add(o3VeryUnhealthy);
    equationCalculationTableArr.add(o3VeryUnhealthy1Hour);
    equationCalculationTableArr.add(pm2p5VeryUnhealthy);
    equationCalculationTableArr.add(pm10VeryUnhealthy);
    equationCalculationTableArr.add(cOVeryUnhealthy);
    equationCalculationTableArr.add(sO2VeryUnhealthy);
    equationCalculationTableArr.add(nO2VeryUnhealthy);
    /******* Hazardous *********/
    equationCalculationTableArr.add(o3Hazardous1Hour);
    equationCalculationTableArr.add(pm2p5Hazardous);
    equationCalculationTableArr.add(pm10Hazardous);
    equationCalculationTableArr.add(cOHazardous);
    equationCalculationTableArr.add(sO2Hazardous);
    equationCalculationTableArr.add(nO2Hazardous);
    /******* Hazardous Two  *********/
    equationCalculationTableArr.add(o3Hazardous21Hour);
    equationCalculationTableArr.add(pm2p5Hazardous2);
    equationCalculationTableArr.add(pm10Hazardous2);
    equationCalculationTableArr.add(cOHazardous2);
    equationCalculationTableArr.add(sO2Hazardous2);
    equationCalculationTableArr.add(nO2Hazardous2);
  }

  double getAqiValueEquation(
      {required double cp, required String pollutantType}) {
    double cpValue = 0.0;

    /// static value
    for (int i = 0; i < equationCalculationTableArr.length; i++) {
      var temp = equationCalculationTableArr[i];

      if (cp.clamp(temp.bpLo, temp.bpHi) == cp &&
          temp.pollutantLayerType == pollutantType) {
        cpValue = getFinalAqiValue(temp, cp);
      }
    }
    return cpValue;
  }

  double getFinalAqiValue(EquationCalculationTableModel temps, double cp) {
    int iHi = temps.iHi;
    int iLo = temps.iLo;
    double bpHi = temps.bpHi;
    double bpLo = temps.bpLo;

    /// Equation calculation
    var temp = iHi - iLo;
    var temp1 = bpHi - bpLo;
    var temp3 = cp - bpLo;
    var finalValue = temp / temp1 * temp3 + iLo;

    return finalValue;
  }

  //// Aqi range color
  Color colorCodeAqiRange(double data) {
    Color markerColor = Colors.black;
    if (data <= 0.00) {
      markerColor = Colors.white;
    } else if (data <= 50.0) {
      markerColor = Colors.green;
    } else if (data <= 100.0) {
      markerColor = Colors.yellow;
    } else if (data <= 150.0) {
      markerColor = Colors.orange;
    } else if (data <= 200.0) {
      markerColor = Colors.red;
    } else if (data <= 300.0) {
      markerColor = Colors.purple;
    } else if (data <= 500.0) {
      markerColor = const Color(0xFF800000);
    }
    return markerColor;
  }

  getAllSqlListRecent() {
    deleteLocationLoading.value = true;
    List temp = [];
    for (int i = 0; i < saveLocationSqlDbList.length; i++) {
      temp.add([
        saveLocationSqlDbList[i].locationLat,
        saveLocationSqlDbList[i].locationLong,
        saveLocationSqlDbList[i].locationName
      ]);
    }
    userAddRecentAndArchiveApi(temp);
  }

  getAllSqlListForecast() {
    deleteLocationLoading.value = true;
    List temp = [];
    for (int i = 0; i < saveLocationSqlDbList.length; i++) {
      temp.add([
        saveLocationSqlDbList[i].locationLat,
        saveLocationSqlDbList[i].locationLong,
        saveLocationSqlDbList[i].locationName
      ]);
    }
    userAddForecastApi(temp);
  }

  //// User add location recent and archive api
  userAddRecentAndArchiveApi(List latiLongiArr) {
    Map<String, dynamic> param = {"points": latiLongiArr};
    return ApiServices.getUserAddLocationRecentApi(param).then((response) {
      if (response != null) {
        SaveLocationRecentApiResponseModel userAddLocationRecentResponseData =
            SaveLocationRecentApiResponseModel.fromJson(response);
        if (userAddLocationRecentResponseData.status == 200) {
          userAddRecentLocationList.value =
              addSaveLocationListData(userAddLocationRecentResponseData);
          deleteLocationLoading.value = false;
        }
        deleteLocationLoading.value = false;
      }
    });
  }

  //// User add location forecast  api
  userAddForecastApi(List latiLongiArr) {
    Map<String, dynamic> param = {"points": latiLongiArr};
    return ApiServices.getUserAddLocationForecastApi(param).then((response) {
      if (response != null) {
        SaveLocationRecentApiResponseModel userAddLocationForecastResponseData =
            SaveLocationRecentApiResponseModel.fromJson(response);
        if (userAddLocationForecastResponseData.status == 200) {
          userAddForecastLocationList.value =
              addSaveLocationListData(userAddLocationForecastResponseData);
          // userAddForecastLocationList.value =
          //     userAddLocationResponseData.data ?? [];
          for (int i = 0; i < userAddForecastLocationList.length; i++) {}
          deleteLocationLoading.value = false;
        }
        deleteLocationLoading.value = false;
      }
    });
  }

  //// Add Save Location Screen List All data
  List<RecentAndArchiveData> addSaveLocationListData(
      SaveLocationRecentApiResponseModel responseModelData) {
    List<RecentAndArchiveData> temp = responseModelData.data ?? [];
    List<RecentAndArchiveData> temp1 = [];

    for (int i = 0; i < temp.length; i++) {
      temp1.add(
        RecentAndArchiveData(
            pollutantName: temp[i].pollutantName,
            source: temp[i].source,
            site: temp[i].site,
            latitude: temp[i].latitude,
            longitude: temp[i].longitude,
            pollutantId: temp[i].pollutantId,
            savedLocation: temp[i].savedLocation,
            stId: temp[i].stId,
            enabled: temp[i].enabled,
            id: temp[i].id,
            geos: [
              for (int j = 0; j < temp[i].geos!.length; j++)
                Geo(
                    name: temp[i].geos?[j].name,
                    latitude: temp[i].latitude,
                    longitude: temp[i].longitude,
                    value: temp[i].geos?[j].value),
            ]),
      );
    }
    return temp1;
  }
}
