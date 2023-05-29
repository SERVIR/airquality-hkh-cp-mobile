// // To parse this JSON data, do
// //
// //     final pollutantTypeLayerResponseModel = pollutantTypeLayerResponseModelFromJson(jsonString);

// import 'dart:convert';

// PollutantTypeLayerResponseModel pollutantTypeLayerResponseModelFromJson(
//         String str) =>
//     PollutantTypeLayerResponseModel.fromJson(json.decode(str));

// String pollutantTypeLayerResponseModelToJson(
//         PollutantTypeLayerResponseModel data) =>
//     json.encode(data.toJson());

// class PollutantTypeLayerResponseModel {
//   PollutantTypeLayerResponseModel({
//     this.seriesData,
//     this.status,
//     this.xaxisLabel,
//     this.geom,
//   });

//   List<List<double>>? seriesData;
//   int? status;
//   String? xaxisLabel;
//   String? geom;

//   factory PollutantTypeLayerResponseModel.fromJson(Map<String, dynamic> json) =>
//       PollutantTypeLayerResponseModel(
//         seriesData: List<List<double>>.from(json["SeriesData"]
//             .map((x) => List<double>.from(x.map((x) => x?.toDouble())))),
//         status: json["status"],
//         xaxisLabel: json["XaxisLabel"],
//         geom: json["geom"],
//       );

//   Map<String, dynamic> toJson() => {
//         "SeriesData": List<dynamic>.from(
//             seriesData!.map((x) => List<dynamic>.from(x.map((x) => x)))),
//         "status": status,
//         "XaxisLabel": xaxisLabel,
//         "geom": geom,
//       };
// }

class SaveLocationPollutantModel {
  SaveLocationPollutantModel({
    this.locationName,
    this.latitude,
    this.longitude,
    this.source,
    this.stationId,
    this.pollutantLayerList,
  });
  String? locationName;
  double? latitude;
  double? longitude;
  String? source;
  String? stationId;
  List<PollutantType>? pollutantLayerList;
}

class PollutantType {
  PollutantType({this.pollutantTypeNm, this.pollutantValue = 0.0});
  String? pollutantTypeNm;
  double pollutantValue;
}
