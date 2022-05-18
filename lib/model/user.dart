// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  User({
    this.uid,
    this.email,
    this.firstname,
    this.lastname,
    this.sensors,
  });

  int? uid;
  String? email;
  String? firstname;
  String? lastname;
  List<Sensor>? sensors;

  factory User.fromJson(Map<String, dynamic> json) => User(
        uid: json["uid"] == null ? null : json["uid"],
        email: json["email"] == null ? null : json["email"],
        firstname: json["firstname"] == null ? null : json["firstname"],
        lastname: json["lastname"] == null ? null : json["lastname"],
        sensors: json["sensors"] == null
            ? null
            : List<Sensor>.from(json["sensors"].map((x) => Sensor.fromJson(x))),
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

class Sensor {
  Sensor({
    this.id,
    this.name,
    this.status,
    this.location,
    this.description,
  });

  int? id;
  String? name;
  bool? status;
  String? location;
  String? description;

  factory Sensor.fromJson(Map<String, dynamic> json) => Sensor(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        status: json["status"] == null ? null : json["status"],
        location: json["location"] == null ? null : json["location"],
        description: json["description"] == null ? null : json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "status": status == null ? null : status,
        "location": location == null ? null : location,
        "description": description == null ? null : description,
      };
}
