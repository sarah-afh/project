// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guard/components/sensor_status_switcher.dart';
import 'package:guard/constants.dart';
import 'package:guard/database.dart';
import 'package:guard/riverpod/sensor_status_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/new_user_model.dart';

class DetailsScreen2 extends ConsumerStatefulWidget {
  const DetailsScreen2({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  DetailsScreen3 createState() => DetailsScreen3();
}

class DetailsScreen3 extends ConsumerState<DetailsScreen2> {
  var _collectionRef = FirebaseFirestore.instance.collection('users');

  NewUser? newUser;
  String idValue = "";
  bool isDataLoaded = false;
  bool status = true;

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
              setState(() {
                newUser = NewUser.fromJson(element.data());

                isDataLoaded = true;
              });
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return Scaffold(
        appBar: buildAppBar(),
        body: isDataLoaded
            ?
            // final data = snapshot.data!;
            // final light = data["light"];
            // final proximity = data["Proximity"];
            SafeArea(
                child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.05),
                    child: Column(children: [
                      SizedBox(height: size.height * 0.02),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Icon(
                      //       Icons.arrow_back,
                      //       size: 30,
                      //       color: kPrimaryColor2,
                      //     ),
                      //     Text(
                      //       'Home',
                      //       style: TextStyle(
                      //         color: Colors.black87,
                      //         fontWeight: FontWeight.bold,
                      //         fontSize: 20,
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      SizedBox(height: size.height * 0.03),
                      Row(
                        children: [
                          Container(
                            height: 120,
                            width: 120,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                "assets/images/light.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: size.width * 0.05),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 35,
                                child: FloatingActionButton.extended(
                                    onPressed: () {
                                      if (newUser!.sensors![0].status! ==
                                          true) {
                                        setState(() {
                                          newUser!.sensors![0].status = false;
                                        });
                                      } else if (newUser!.sensors![0].status! ==
                                          false) {
                                        setState(() {
                                          newUser!.sensors![0].status = true;
                                        });
                                      }
                                      ;

                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc('$idValue')
                                          .set(newUser!.toJson())
                                          .then((value) {
                                        print("${newUser!.sensors![0].status}");
                                        setState(() {
                                          status = newUser!.sensors![0].status!;
                                        });
                                      });
                                    },
                                    // extendedPadding: EdgeInsets.only(bottom: 10),
                                    label: status
                                        ? const Text("On")
                                        : const Text("Off"),
                                    backgroundColor:
                                        status ? kPrimaryColor2 : Colors.grey,
                                    icon: Icon(
                                      status
                                          ? Icons.toggle_on
                                          : Icons.toggle_off,
                                    )),
                              ),
                              // SensorStatusSwitcher(
                              //     sensorName: widget.name),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Light & Proximity',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                              Text(
                                'Measures the light and proximity ',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                'percentages in your room',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.05),
                      newUser!.sensors![0].status == true
                          ? Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'proximity ........',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        'PROXIMITY',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'light .......',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        'LIGHT',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              child: Text(
                                'Sensor is turned off',
                                style:
                                    TextStyle(fontSize: 20, color: Colors.red),
                              ),
                            ),
                    ])))
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.indigo,
      elevation: 0,
      centerTitle: true,
      title: Text("MY ROOM"),
      actions: [
        // IconButton(
        //   icon: Icon(Icons.edit),
        //   onPressed: () {},
        // ),
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {},
        ),
      ],
    );
  }
}
