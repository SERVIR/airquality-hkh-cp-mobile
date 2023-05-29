// To parse this JSON data, do
//
//     final xmlToJsonForecastResponseModel = xmlToJsonForecastResponseModelFromJson(jsonString);

import 'dart:convert';

XmlToJsonForecastResponseModel xmlToJsonForecastResponseModelFromJson(
        String str) =>
    XmlToJsonForecastResponseModel.fromJson(json.decode(str));

String xmlToJsonForecastResponseModelToJson(
        XmlToJsonForecastResponseModel data) =>
    json.encode(data.toJson());

class XmlToJsonForecastResponseModel {
  XmlToJsonForecastResponseModel({
    this.catalog,
  });

  Catalog? catalog;

  factory XmlToJsonForecastResponseModel.fromJson(Map<String, dynamic> json) =>
      XmlToJsonForecastResponseModel(
        catalog: Catalog.fromJson(json["catalog"]),
      );

  Map<String, dynamic> toJson() => {
        "catalog": catalog?.toJson(),
      };
}

class Catalog {
  Catalog({
    this.service,
    this.dataset,
  });

  Service? service;
  CatalogDataset? dataset;

  factory Catalog.fromJson(Map<String, dynamic> json) => Catalog(
        service: Service.fromJson(json["service"]),
        dataset: CatalogDataset.fromJson(json["dataset"]),
      );

  Map<String, dynamic> toJson() => {
        "service": service?.toJson(),
        "dataset": dataset?.toJson(),
      };
}

class CatalogDataset {
  CatalogDataset({
    this.property,
    this.metadata,
    this.dataset,
  });

  dynamic property;
  Metadata? metadata;
  List<DatasetElement>? dataset;

  factory CatalogDataset.fromJson(Map<String, dynamic> json) => CatalogDataset(
        property: json["property"],
        metadata: Metadata.fromJson(json["metadata"]),
        dataset: List<DatasetElement>.from(
            json["dataset"].map((x) => DatasetElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "property": property,
        "metadata": metadata?.toJson(),
        "dataset": List<dynamic>.from(dataset!.map((x) => x.toJson())),
      };
}

class DatasetElement {
  DatasetElement({
    required this.dataSize,
    required this.date,
  });

  String dataSize;
  DateTime date;

  factory DatasetElement.fromJson(Map<String, dynamic> json) => DatasetElement(
        dataSize: json["dataSize"],
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "dataSize": dataSize,
        "date": date.toIso8601String(),
      };
}

class Metadata {
  Metadata({
    required this.serviceName,
    required this.dataType,
  });

  String serviceName;
  String dataType;

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        serviceName: json["serviceName"],
        dataType: json["dataType"],
      );

  Map<String, dynamic> toJson() => {
        "serviceName": serviceName,
        "dataType": dataType,
      };
}

class Service {
  Service({
    this.service,
  });

  dynamic service;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        service: json["service"],
      );

  Map<String, dynamic> toJson() => {
        "service": service,
      };
}
