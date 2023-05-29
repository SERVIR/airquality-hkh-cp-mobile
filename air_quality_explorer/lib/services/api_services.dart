// ignore_for_file: invalid_return_type_for_catch_error

import 'dart:convert';
import 'dart:developer';
import 'package:air_quality_explorer/core/base_url.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static Future searchPlace(String searchValue) async {
    return http
        .post(Uri.parse(
            "https://nominatim.openstreetmap.org/search?q=$searchValue&format=json&polygon_geojson=1"))
        .then((response) => jsonDecode(response.body))
        .catchError(
          (error) => log("Search place error : $error"),
        );
  }

  static Future getSelectStationData(Map<String, dynamic> parameter) {
    return http
        .post(Uri.parse(ApiUrl.groundObservation), body: parameter)
        .then((response) {
      return response.statusCode == 200 ? jsonDecode(response.body) : null;
    }).catchError((error) => log("Ground Observation Data Error : $error"));
  }

  /// Save Location Recente data
  static Future getSaveLocationRecente(Map<String, dynamic> parameter) {
    var headers = {'Content-Type': 'application/json'};
    return http
        .post(Uri.parse(ApiUrl.getRecentSaveLocation),
            body: json.encode(parameter), headers: headers)
        .then((response) {
      return response.statusCode == 200 ? jsonDecode(response.body) : null;
    }).catchError((error) => log("save location api response error : $error"));
  }

  /// Save Location Forecaste data
  static Future getSaveLocationForecaste(Map<String, dynamic> parameter) {
    var headers = {'Content-Type': 'application/json'};
    return http
        .post(Uri.parse(ApiUrl.getForecastSaveLocation),
            body: json.encode(parameter), headers: headers)
        .then((response) {
      return response.statusCode == 200 ? jsonDecode(response.body) : null;
    }).catchError((error) => log("save location api response error : $error"));
  }

  // Get Aeronet Data List
  static Future getAeronetApiData() {
    return http.get(Uri.parse(ApiUrl.getAeronetList)).then((response) {
      return response.statusCode == 200 ? jsonDecode(response.body) : null;
    }).catchError(
        (error) => log("Surface Aeronet Observation Data Error : $error"));
  }

  // Get Aeronet Data List
  static Future getAirnowApiData() {
    return http.get(Uri.parse(ApiUrl.getAirnowList)).then((response) {
      return response.statusCode == 200 ? jsonDecode(response.body) : null;
    }).catchError(
        (error) => log("Ground Airnow Observation Data Error : $error"));
  }

  //// Get Recent And Archive Url End Point
  static Future getSlicedFromCatalog(Map<String, dynamic> parameter) {
    return http
        .post(Uri.parse(ApiUrl.getSlicefromCatalog), body: parameter)
        .then((response) {
      return response.statusCode == 200 ? jsonDecode(response.body) : null;
    }).catchError((error) => log("Sliced Form Catalog Error : $error"));
  }

  //// Get Recent and Archive timeseriesmodeldata
  static Future getTimeSeriseModleData(Map<String, dynamic> parameter) {
    var headers = {'Content-Type': 'application/json'};
    return http
        .post(Uri.parse(ApiUrl.getTimeseriesModeldata),
            body: json.encode(parameter), headers: headers)
        .then((response) {
      return response.statusCode == 200 ? jsonDecode(response.body) : null;
    }).catchError((error) => log("Time Series Api Error : $error"));
  }

  //// Get Forcast Url end point
  static Future getSlicedForcastCatalog(Map<String, dynamic> parameter) {
    return http
        .post(Uri.parse(ApiUrl.getSlicefromCatalog), body: parameter)
        .then((response) {
      return response.statusCode == 200 ? jsonDecode(response.body) : null;
    }).catchError((error) => log("Forcast Sliced Form Catalog Error : $error"));
  }

  //// Get Forcast timeseriesmodeldata
  static Future getForcastTimeSeriseModleData(Map<String, dynamic> parameter) {
    var headers = {'Content-Type': 'application/json'};
    return http
        .post(Uri.parse(ApiUrl.getTimeseriesModeldata),
            body: json.encode(parameter), headers: headers)
        .then((response) {
      return response.statusCode == 200 ? jsonDecode(response.body) : null;
    }).catchError((error) => log("Forcast Time Series Api Error : $error"));
  }

  //// Add user location recent and archive api
  static Future getUserAddLocationRecentApi(Map<String, dynamic> parameter) {
    var headers = {'Content-Type': 'application/json'};
    return http
        .post(Uri.parse(ApiUrl.getUserAddLocationRecentApi),
            body: json.encode(parameter), headers: headers)
        .then((response) {
      return response.statusCode == 200 ? jsonDecode(response.body) : null;
    }).catchError((error) => log("User Add Recent Api Error : $error"));
  }

  //// Add user location recent and archive api
  static Future getUserAddLocationForecastApi(Map<String, dynamic> parameter) {
    var headers = {'Content-Type': 'application/json'};
    return http
        .post(Uri.parse(ApiUrl.getUserAddLocationForecastApi),
            body: json.encode(parameter), headers: headers)
        .then((response) {
      return response.statusCode == 200 ? jsonDecode(response.body) : null;
    }).catchError((error) => log("User Add Forecast Api Error : $error"));
  }

  //// Xml parse to json data
  static Future getForecastXmlData(String date) {
    return http.get(
        Uri.parse(ApiUrl.forecastChartDataApiUrl.replaceFirst("date", date)),
        headers: {'Accept': 'application/xml'}).then((response) {
      return response.statusCode == 200 ? response.body : null;
    }).catchError((error) => log("User Add Forecast Api Error : $error"));
  }
}
