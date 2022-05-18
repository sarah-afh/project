// To parse this JSON data, do
//
//     final sensorModel = sensorModelFromJson(jsonString);

import 'dart:convert';

SensorModel sensorModelFromJson(String str) =>
    SensorModel.fromJson(json.decode(str));

String sensorModelToJson(SensorModel data) => json.encode(data.toJson());

class SensorModel {
  SensorModel({
    this.description,
    this.id,
    this.location,
    this.name,
    this.status,
  });

  String? description;
  int? id;
  String? location;
  String? name;
  bool? status;

  factory SensorModel.fromJson(Map<String, dynamic> json) => SensorModel(
        description: json["Description"] == null ? null : json["Description"],
        id: json["ID"] == null ? null : json["ID"],
        location: json["Location"] == null ? null : json["Location"],
        name: json["Name"] == null ? null : json["Name"],
        status: json["Status"] == null ? null : json["Status"],
      );

  Map<String, dynamic> toJson() => {
        "Description": description == null ? null : description,
        "ID": id == null ? null : id,
        "Location": location == null ? null : location,
        "Name": name == null ? null : name,
        "Status": status == null ? null : status,
      };
}
