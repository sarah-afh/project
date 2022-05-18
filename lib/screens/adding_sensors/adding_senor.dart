import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guard/notification/notification_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../../model/new_user_model.dart';

class AddSensorScreen extends StatefulWidget {
  const AddSensorScreen({Key? key}) : super(key: key);

  @override
  State<AddSensorScreen> createState() => _AddSensorScreenState();
}

enum Sensors { AirQuality, Motion, Spectrum, ColorAndLuminance }

Sensors? fromString(String value) {
  switch (value) {
    case "BME680":
      return Sensors.AirQuality;
    case "LSM303D":
      return Sensors.Motion;
    case "AS7262":
      return Sensors.Spectrum;
    case "BH1745":
      return Sensors.ColorAndLuminance;
    default:
      return null;
  }
}

extension SensorsUtils on Sensors {
  String toSensorCode() {
    switch (this) {
      case Sensors.AirQuality:
        return "BME680";
      case Sensors.Motion:
        return "LSM303D";
      case Sensors.Spectrum:
        return "AS7262";
      case Sensors.ColorAndLuminance:
        return "BH1745";
    }
  }
}

class _AddSensorScreenState extends State<AddSensorScreen> {
  Sensors? _sensors = Sensors.AirQuality;

  var _collectionRef = FirebaseFirestore.instance.collection('users');

  var sens;
  NewUser? newUser;
  String idValue = "";
  bool isDataLoaded = false;
  TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<dynamic> getData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      idValue = prefs.getString("idValue") ?? "";

      setState(() {
        _collectionRef.snapshots().forEach((first_element) {
          first_element.docs.forEach((element) {
            if (element.id == idValue) {
              newUser = NewUser.fromJson(element.data());
              isDataLoaded = true;
              if (mounted) setState(() {});
              // newUser = newUser;
            }
          });
        });
      });
      return newUser;
    } catch (e) {
      print("Exception : ${e.toString()}");
      // return newUser;
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: isDataLoaded
          ? SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height / 1.1,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (newUser!.sensors![0].location == '') ...[
                      Column(
                        children: [
                          RadioListTile<Sensors>(
                            title: Text(
                              'Air Quality',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                            subtitle: Text(
                              "Measures the air humidity, pressure and gas room through temperature,  quality of your ",
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                            activeColor: kPrimaryColor.withOpacity(0.5),
                            value: Sensors.AirQuality,
                            groupValue: _sensors,
                            onChanged: (Sensors? value) {
                              setState(() {
                                _sensors = value;
                                print("objectobject : _sensor = $_sensors");
                              });
                            },
                          ),
                          Divider(),
                        ],
                      ),
                    ] else ...[
                      Container(),
                    ],
                    if (newUser!.sensors![1].location == '') ...[
                      Column(
                        children: [
                          RadioListTile<Sensors>(
                            title: Text(
                              'Motion',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                            subtitle: Text(
                              "Measures the movements done in your room",
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                            activeColor: kPrimaryColor.withOpacity(0.5),
                            value: Sensors.Motion,
                            groupValue: _sensors,
                            onChanged: (Sensors? value) {
                              setState(() {
                                _sensors = value;
                                print("objectobject : _sensor = $_sensors");
                              });
                            },
                          ),
                          Divider(),
                        ],
                      ),
                    ] else ...[
                      Container()
                    ],
                    if (newUser!.sensors![2].location == '') ...[
                      Column(
                        children: [
                          RadioListTile<Sensors>(
                            title: Text(
                              'Spectrum',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                            subtitle: Text(
                              "Spectrum a band of colours, as seen in a rainbow, produced by separation of the components of light by their different degrees of refraction according to wavelength.",
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                            activeColor: kPrimaryColor.withOpacity(0.5),
                            value: Sensors.Spectrum,
                            groupValue: _sensors,
                            onChanged: (Sensors? value) {
                              setState(() {
                                _sensors = value;
                                print("objectobject : _sensor = $_sensors");
                              });
                            },
                          ),
                          Divider(),
                        ],
                      ),
                    ] else ...[
                      Container()
                    ],
                    if (newUser!.sensors![3].location == '') ...[
                      Column(
                        children: [
                          RadioListTile<Sensors>(
                            title: Text(
                              'Color and Luminance',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                            subtitle: Text(
                              "Measures the colors and luminance percentages in your room (Red ,Green , Blue ) Light Concentration",
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                            activeColor: kPrimaryColor.withOpacity(0.5),
                            value: Sensors.ColorAndLuminance,
                            groupValue: _sensors,
                            onChanged: (Sensors? value) {
                              setState(() {
                                _sensors = value;
                                print("objectobject : _sensor = ${_sensors}");
                              });
                            },
                          ),
                          Divider(),
                        ],
                      ),
                    ] else ...[
                      Container()
                    ],
                    if (newUser!.sensors!
                        .any((element) => element.location == '')) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          "Add Location",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: locationController,
                            autofocus: false,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return ("Please Enter location of sensor");
                              }

                              return null;
                            },
                            onSaved: (value) {
                              locationController.text = value!;
                            },
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.location_pin),
                              contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              hintText: "Bed Room etc",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 20.0, left: 20),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: kPrimaryColor.withOpacity(0.5),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                ),
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 20.0,
                              right: 20,
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: kPrimaryColor.withOpacity(0.5),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (_sensors == Sensors.AirQuality) {
                                    try {
                                      if (newUser!
                                          .sensors![0].location!.isEmpty) {
                                        newUser!.sensors![0].location =
                                            "${locationController.text.toString()}";
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc('$idValue')
                                            .set(newUser!.toJson())
                                            .then((value) {
                                          final snackBar = SnackBar(
                                            content: Text("Sensor added"),
                                            backgroundColor: Colors.green,
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);

                                          // showSnackBar(context, "Successfully Created");
                                          NotificationManager
                                              .subscribeToSensorNotifications(
                                                  _sensors!);
                                          Navigator.pop(context);
                                        });
                                      } else {
                                        print("Abc");
                                        final snackBar = SnackBar(
                                          content:
                                              Text("Sensor already exists"),
                                          backgroundColor: Colors.red,
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    } catch (e) {
                                      print(e.toString());
                                    }
                                  } else if (_sensors == Sensors.Motion) {
                                    try {
                                      if (newUser!
                                          .sensors![1].location!.isEmpty) {
                                        newUser!.sensors![1].location =
                                            "${locationController.text.toString()}";
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc('$idValue')
                                            .set(newUser!.toJson())
                                            .then((value) {
                                          // showSnackBar(context, "Successfully Created");
                                          final snackBar = SnackBar(
                                            content: Text("Sensor added"),
                                            backgroundColor: Colors.green,
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                          NotificationManager
                                              .subscribeToSensorNotifications(
                                                  _sensors!);
                                          Navigator.pop(context);
                                        });
                                      } else {
                                        final snackBar = SnackBar(
                                          content:
                                              Text("Sensor already created"),
                                          backgroundColor: Colors.red,
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    } catch (e) {
                                      print(e.toString());
                                    }
                                  } else if (_sensors == Sensors.Spectrum) {
                                    try {
                                      if (newUser!
                                          .sensors![2].location!.isEmpty) {
                                        newUser!.sensors![2].location =
                                            "${locationController.text.toString()}";
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc('$idValue')
                                            .set(newUser!.toJson())
                                            .then((value) {
                                          // showSnackBar(context, "Successfully Created");
                                          final snackBar = SnackBar(
                                            content: Text("Sensor added"),
                                            backgroundColor: Colors.green,
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                          NotificationManager
                                              .subscribeToSensorNotifications(
                                                  _sensors!);
                                          Navigator.pop(context);
                                        });
                                      } else {
                                        final snackBar = SnackBar(
                                          content:
                                              Text("sensor already created"),
                                          backgroundColor: Colors.red,
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    } catch (e) {
                                      print(e);
                                    }
                                  } else if (_sensors ==
                                      Sensors.ColorAndLuminance) {
                                    try {
                                      if (newUser!
                                          .sensors![3].location!.isEmpty) {
                                        newUser!.sensors![3].location =
                                            "${locationController.text.toString()}";
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc('$idValue')
                                            .set(newUser!.toJson())
                                            .then((value) {
                                          // showSnackBar(context, "Successfully Created");

                                          final snackBar = SnackBar(
                                            content: Text("Sensor added"),
                                            backgroundColor: Colors.green,
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                          NotificationManager
                                              .subscribeToSensorNotifications(
                                                  _sensors!);
                                          Navigator.pop(context);
                                        });
                                      } else {
                                        final snackBar = SnackBar(
                                          content:
                                              Text("Sensors already created"),
                                          backgroundColor: Colors.red,
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    } catch (e) {}
                                  }
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                ),
                                child: Text(
                                  "Add",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Container(
                        height: MediaQuery.of(context).size.height / 1.2,
                        width: MediaQuery.of(context).size.width,
                        // color: Colors.red,
                        child: Center(
                          child: Text("All Sensors are added successfully"),
                        ),
                      )
                    ],
                  ],
                ),
              ),
            )
          : Container(),
    );
  }
}

AppBar buildAppBar() {
  return AppBar(
    backgroundColor: kPrimaryColor.withOpacity(0.5),
    elevation: 0,
    centerTitle: true,
    title: Text("Add Sensor"),
  );
}
