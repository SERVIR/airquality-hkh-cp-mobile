// To parse this JSON data, do
//
//     final saveLocationScreenModel = saveLocationScreenModelFromJson(jsonString);

import 'dart:convert';

SaveLocationSqlDbResponseModel saveLocationScreenModelFromJson(String str) =>
    SaveLocationSqlDbResponseModel.fromJson(json.decode(str));

String saveLocationScreenModelToJson(SaveLocationSqlDbResponseModel data) =>
    json.encode(data.toJson());

class SaveLocationSqlDbResponseModel {
  SaveLocationSqlDbResponseModel({
    this.id,
    this.startDate,
    this.endDate,
    this.locationName,
    this.locationLat,
    this.locationLong,
    this.stationModelClass,
    this.stationModelClassDataList,
    this.stationId,
    this.stationPollutantType,
    this.stationPollutantValue,
  });

  int? id;
  int? startDate;
  int? endDate;
  String? locationName;
  double? locationLat;
  double? locationLong;
  String? stationModelClass;
  String? stationModelClassDataList;
  int? stationId;
  String? stationPollutantType;
  double? stationPollutantValue;
  // List<StationPollutantName>? stationPollutantName;

  factory SaveLocationSqlDbResponseModel.fromJson(Map<String, dynamic> json) =>
      SaveLocationSqlDbResponseModel(
        id: json["id"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        locationName: json["location_name"],
        locationLat: json["location_lat"]?.toDouble(),
        locationLong: json["location_long"]?.toDouble(),
        stationModelClass: json["station_model_class"],
        stationModelClassDataList: json["station_model_class_data_list"],
        stationId: json["station_id"],
        stationPollutantType: json["station_pollutant_type"],
        stationPollutantValue: json["station_pollutant_value"] ?? 0.0,
        // stationPollutantName: List<StationPollutantName>.from(
        //     json["station_pollutant_name"]
        //         .map((x) => StationPollutantName.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "start_date": startDate,
        "end_date": endDate,
        "location_name": locationName,
        "location_lat": locationLat,
        "location_long": locationLong,
        "station_model_class": stationModelClass,
        "station_model_class_data_list": stationModelClassDataList,
        "station_id": stationId,
        "station_pollutant_type": stationPollutantType,
        "station_pollutant_value": stationPollutantValue
        // "station_pollutant_name":
        //     List<dynamic>.from(stationPollutantName!.map((x) => x.toJson())),
      };
}

class StationPollutantName {
  StationPollutantName({
    this.pm10,
    this.pm25,
    this.nOx,
    this.so2,
    this.o3,
    this.co,
  });

  int? pm10;
  String? pm25;
  String? nOx;
  String? so2;
  String? o3;
  String? co;

  factory StationPollutantName.fromJson(Map<String, dynamic> json) =>
      StationPollutantName(
        pm10: json["PM10"],
        pm25: json["PM25"],
        nOx: json["NOx"],
        so2: json["SO2"],
        o3: json["O3"],
        co: json["CO"],
      );

  Map<String, dynamic> toJson() => {
        "PM10": pm10,
        "PM25": pm25,
        "NOx": nOx,
        "SO2": so2,
        "O3": o3,
        "CO": co,
      };
}
