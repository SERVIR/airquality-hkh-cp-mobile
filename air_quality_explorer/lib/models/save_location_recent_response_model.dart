// To parse this JSON data, do
//
//     final saveLocationApiResponseModel = saveLocationApiResponseModelFromJson(jsonString);

import 'dart:convert';

SaveLocationRecentApiResponseModel saveLocationApiResponseModelFromJson(
        String str) =>
    SaveLocationRecentApiResponseModel.fromJson(json.decode(str));

String saveLocationApiResponseModelToJson(
        SaveLocationRecentApiResponseModel data) =>
    json.encode(data.toJson());

class SaveLocationRecentApiResponseModel {
  SaveLocationRecentApiResponseModel({
    this.message,
    this.status,
    this.data,
  });

  String? message;
  int? status;
  List<RecentAndArchiveData>? data;

  factory SaveLocationRecentApiResponseModel.fromJson(
          Map<String, dynamic> json) =>
      SaveLocationRecentApiResponseModel(
        message: json["message"],
        status: json["status"],
        data: List<RecentAndArchiveData>.from(
            json["data"].map((x) => RecentAndArchiveData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class RecentAndArchiveData {
  RecentAndArchiveData({
    this.pollutantName,
    this.source,
    this.site,
    this.latitude,
    this.longitude,
    this.pollutantId,
    this.savedLocation,
    this.stId,
    this.enabled,
    this.id,
    this.geos,
  });

  dynamic pollutantName;
  String? source;
  String? site;
  double? latitude;
  double? longitude;
  dynamic pollutantId;
  bool? savedLocation;
  int? stId;
  bool? enabled;
  int? id;
  List<Geo>? geos;

  factory RecentAndArchiveData.fromJson(Map<String, dynamic> json) =>
      RecentAndArchiveData(
        pollutantName: json["pollutant__name"],
        source: json["source"],
        site: json["site"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        pollutantId: json["pollutant__id"],
        savedLocation: json["saved_location"],
        stId: json["StId"],
        enabled: json["enabled"],
        id: json["id"],
        geos: List<Geo>.from(json["geos"].map((x) => Geo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pollutant__name": pollutantName,
        "source": source,
        "site": site,
        "latitude": latitude,
        "longitude": longitude,
        "pollutant__id": pollutantId,
        "saved_location": savedLocation,
        "StId": stId,
        "enabled": enabled,
        "id": id,
        "geos": List<dynamic>.from(geos!.map((x) => x.toJson())),
      };
}

class Geo {
  Geo({this.name, this.latitude, this.longitude, this.value, this.aqiValue});

  String? name;
  double? latitude;
  double? longitude;
  List<double>? value;
  double? aqiValue;

  factory Geo.fromJson(Map<String, dynamic> json) => Geo(
      name: json["name"],
      value: List<double>.from(json["value"].map((x) => x?.toDouble())),
      aqiValue: 0.0);

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": List<dynamic>.from(value!.map((x) => x)),
        "aquValue": aqiValue
      };

  String getDecimalValue() {
    String decimal = "";
    if (value != null) {
      decimal = value![1].round().toString();
    } else {
      decimal = "0.0";
    }
    return decimal;
  }

  String getSourceType() {
    String source = "";
    if (name == "PM2.5") {
      source = "AirNow";
    } else {
      source = "GEOS";
    }
    return source;
  }
}
