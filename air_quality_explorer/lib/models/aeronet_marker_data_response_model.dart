// To parse this JSON data, do
//
//     final getAeronetAndAirnowDataResponseModel = getAeronetAndAirnowDataResponseModelFromJson(jsonString);

import 'dart:convert';

GetAeronetDataResponseModel getAeronetAndAirnowDataResponseModelFromJson(
        String str) =>
    GetAeronetDataResponseModel.fromJson(json.decode(str));

String getAeronetAndAirnowDataResponseModelToJson(
        GetAeronetDataResponseModel data) =>
    json.encode(data.toJson());

class GetAeronetDataResponseModel {
  GetAeronetDataResponseModel({
    this.message,
    this.status,
    this.data,
  });

  String? message;
  int? status;
  List<AeronetDataClass>? data;

  factory GetAeronetDataResponseModel.fromJson(Map<String, dynamic> json) =>
      GetAeronetDataResponseModel(
        message: json["message"],
        status: json["status"],
        data: List<AeronetDataClass>.from(
            json["data"].map((x) => AeronetDataClass.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class AeronetDataClass {
  AeronetDataClass({
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

  factory AeronetDataClass.fromJson(Map<String, dynamic> json) =>
      AeronetDataClass(
        pollutantName: json["pollutant__name"],
        source: json["source"],
        site: json["site"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        pollutantId: json["pollutant__id"],
        savedLocation: json["saved_location"],
        stId: json["StId"],
        enabled: json["enabled"],
        id: json["id"],
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
      };
}
