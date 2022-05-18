// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

List<NewUser> userFromJson(String str) =>
    List<NewUser>.from(json.decode(str).map((x) => NewUser.fromJson(x)));

String userToJson(List<NewUser> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NewUser {
  NewUser({
    this.uid,
    this.email,
    this.firstname,
    this.lastname,
    this.sensors,
  });

  String? uid;
  String? email;
  String? firstname;
  String? lastname;
  List<SensorData>? sensors;

  factory NewUser.fromJson(Map<String, dynamic> json) => NewUser(
        uid: json["uid"] == null ? null : json["uid"],
        email: json["email"] == null ? null : json["email"],
        firstname: json["firstname"] == null ? null : json["firstname"],
        lastname: json["lastname"] == null ? null : json["lastname"],
        sensors: json["sensors"] == null
            ? null
            : List<SensorData>.from(json["sensors"].map((x) => SensorData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "uid": uid == null ? null : uid,
        "email": email == null ? null : email,
        "firstname": firstname == null ? null : firstname,
        "lastname": lastname == null ? null : lastname,
        "sensors": sensors == null
            ? null
            : List<dynamic>.from(sensors!.map((x) => x.toJson())),
      };
}

class SensorData {
  SensorData({
    this.id,
    this.name,
    this.status,
    this.location,
    this.imgUrl,
    this.description,
  });

  String? id;
  String? name;
  bool? status;
  String? location;

  String? imgUrl;
  String? description;

  factory SensorData.fromJson(Map<String, dynamic> json) => SensorData(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        status: json["status"] == null ? null : json["status"],
        location: json["location"] == null ? null : json["location"],
    imgUrl: json["imgUrl"] == null ? null : json["imgUrl"],
        description: json["description"] == null ? null : json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "status": status == null ? null : status,
        "location": location == null ? null : location,
        "imgUrl": imgUrl == null ? null : imgUrl,
        "description": description == null ? null : description,
      };
}
