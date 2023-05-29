// // To parse this JSON data, do
// //
// //     final getAeronetAndAirnowDataResponseModel = getAeronetAndAirnowDataResponseModelFromJson(jsonString);

// import 'dart:convert';

// GetAirnowDataResponseModel getAeronetAndAirnowDataResponseModelFromJson(
//         String str) =>
//     GetAirnowDataResponseModel.fromJson(json.decode(str));

// String getAeronetAndAirnowDataResponseModelToJson(
//         GetAirnowDataResponseModel data) =>
//     json.encode(data.toJson());

// class GetAirnowDataResponseModel {
//   GetAirnowDataResponseModel({
//     this.message,
//     this.status,
//     this.data,
//   });

//   String? message;
//   int? status;
//   List<AirnowDataClass>? data;

//   factory GetAirnowDataResponseModel.fromJson(Map<String, dynamic> json) =>
//       GetAirnowDataResponseModel(
//         message: json["message"],
//         status: json["status"],
//         data: List<AirnowDataClass>.from(
//             json["data"].map((x) => AirnowDataClass.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "message": message,
//         "status": status,
//         "data": List<dynamic>.from(data!.map((x) => x.toJson())),
//       };
// }

// class AirnowDataClass {
//   AirnowDataClass({
//     this.pollutantName,
//     this.source,
//     this.site,
//     this.latitude,
//     this.longitude,
//     this.pollutantId,
//     this.savedLocation,
//     this.stId,
//     this.enabled,
//     this.id,
//   });

//   dynamic pollutantName;
//   String? source;
//   String? site;
//   double? latitude;
//   double? longitude;
//   dynamic pollutantId;
//   bool? savedLocation;
//   int? stId;
//   bool? enabled;
//   int? id;

//   factory AirnowDataClass.fromJson(Map<String, dynamic> json) =>
//       AirnowDataClass(
//         pollutantName: json["pollutant__name"],
//         source: json["source"],
//         site: json["site"],
//         latitude: json["latitude"]?.toDouble(),
//         longitude: json["longitude"]?.toDouble(),
//         pollutantId: json["pollutant__id"],
//         savedLocation: json["saved_location"],
//         stId: json["StId"],
//         enabled: json["enabled"],
//         id: json["id"],
//       );

//   Map<String, dynamic> toJson() => {
//         "pollutant__name": pollutantName,
//         "source": source,
//         "site": site,
//         "latitude": latitude,
//         "longitude": longitude,
//         "pollutant__id": pollutantId,
//         "saved_location": savedLocation,
//         "StId": stId,
//         "enabled": enabled,
//         "id": id,
//       };
// }

// To parse this JSON data, do
//
//     final getAirnowDataResponseModel = getAirnowDataResponseModelFromJson(jsonString);

import 'dart:convert';

GetAirnowDataResponseModel getAirnowDataResponseModelFromJson(String str) =>
    GetAirnowDataResponseModel.fromJson(json.decode(str));

String getAirnowDataResponseModelToJson(GetAirnowDataResponseModel data) =>
    json.encode(data.toJson());

class GetAirnowDataResponseModel {
  GetAirnowDataResponseModel({
    this.message,
    this.status,
    this.data,
  });

  String? message;
  int? status;
  List<DataClass>? data;

  factory GetAirnowDataResponseModel.fromJson(Map<String, dynamic> json) =>
      GetAirnowDataResponseModel(
        message: json["message"],
        status: json["status"],
        data: List<DataClass>.from(
            json["data"].map((x) => DataClass.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DataClass {
  DataClass({
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
    this.color,
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
  List<double>? geos;
  String? color;

  factory DataClass.fromJson(Map<String, dynamic> json) => DataClass(
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
        geos: List<double>.from(json["geos"] == null
            ? [0.0]
            : json["geos"].map((x) => x?.toDouble())),
        color: json["color"],
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
        "geos": List<dynamic>.from(geos!.map((x) => x)),
        "color": color,
      };
}
