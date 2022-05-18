import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guard/notification/notification_manager.dart';
import 'package:guard/screens/adding_sensors/adding_senor.dart';
import 'package:guard/screens/details/details_screen1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import '../../model/new_user_model.dart';
import '../../screens/details/details_screen3.dart';
import '../../screens/details/details_screen4.dart';
import '../../screens/details/details_screen5.dart';

class Sensors extends StatefulWidget {
  @override
  State<Sensors> createState() => _SensorsState();
}

class _SensorsState extends State<Sensors> {
  TextEditingController locationController = TextEditingController();

  var _collectionRef = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    getData();
  }

  NewUser? newUser;
  bool isVisible = true;
  bool isDataLoad = false;
  String idValue = "";

  Future<dynamic> getData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      idValue = prefs.getString("idValue") ?? "";

      QuerySnapshot querySnapshot = await _collectionRef.get();
      setState(() {
        _collectionRef.snapshots().forEach((first_element) {
          first_element.docs.forEach((element) {
            if (element.id == idValue) {
              setState(() {
                newUser = NewUser.fromJson(element.data());
                isDataLoad = true;
              });
            }
          });
        });
      });
      return newUser;
    } catch (e) {
      print("Exception : ${e.toString()}");
    }
  }

  final String name1 = "BME688";
  final String name2 = "LTR-559";
  final String name3 = "AS7262";
  final String name4 = "LSM303D";
  final String name5 = "BH1745";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          height: 250,
          child: isDataLoad
              ? newUser!.sensors!.every((element) => element.location == '')
                  ? Center(
                      child: Text("Add sensor to monitor your home ^_^"),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: newUser!.sensors!.length,
                      itemBuilder: (context, iindex) {
                        var doc = newUser!.sensors![iindex];
                        return Visibility(
                          visible: newUser!.sensors![iindex].location == ""
                              ? false
                              : true,
                          child: GestureDetector(
                            onTap: () {
                              var loc =
                                  newUser!.sensors![iindex].location.toString();
                              if (newUser!.sensors![iindex] ==
                                  newUser!.sensors![0]) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailsScreen(
                                      status: newUser!.sensors![0].status!,
                                      location: loc,
                                      name: name1,
                                    ),
                                  ),
                                );
                              } else if (newUser!.sensors![iindex] ==
                                  newUser!.sensors![1]) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailsScreenM(
                                      status: newUser!.sensors![1].status!,
                                      location: loc,
                                      name: name5,
                                    ),
                                  ),
                                );
                              } else if (newUser!.sensors![iindex] ==
                                  newUser!.sensors![2]) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailsScreenS(
                                      status: newUser!.sensors![2].status!,
                                      location: loc,
                                      name: name5,
                                    ),
                                  ),
                                );
                              } else if (newUser!.sensors![iindex] ==
                                  newUser!.sensors![3]) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailsScreenC(
                                      status: newUser!.sensors![3].status!,
                                      location: loc,
                                      name: name5,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                left: kDefaultPadding,
                                top: kDefaultPadding / 2,
                                bottom: kDefaultPadding * 0.5,
                              ),
                              width: size.width * 0.4,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 10),
                                    blurRadius: 50,
                                    color: kPrimaryColor.withOpacity(0.23),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 100,
                                    width: double.infinity,
                                    child: Image.network(
                                      "${doc.imgUrl.toString()}",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.all(kDefaultPadding / 2.3),
                                    width: double.infinity,
                                    color: Colors.transparent,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${doc.name.toString()}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "${doc.location.toString()}",
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(),
                                  Container(
                                      // color: Colors.grey,
                                      child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            locationController.text =
                                                doc.location.toString();
                                            showDialog(
                                                context: context,
                                                builder: (context) => Dialog(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 40,
                                                                bottom: 40,
                                                                left: 15,
                                                                right: 15),
                                                        child: ListView(
                                                          shrinkWrap: true,
                                                          children: [
                                                            TextFormField(
                                                              autofocus: false,
                                                              controller:
                                                                  locationController,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .emailAddress,
                                                              validator:
                                                                  (value) {
                                                                if (value!
                                                                    .isEmpty) {
                                                                  return ("Please Enter Your location");
                                                                }
                                                                return null;
                                                              },
                                                              onSaved: (value) {
                                                                locationController
                                                                        .text =
                                                                    value!;
                                                              },
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .next,
                                                              decoration:
                                                                  InputDecoration(
                                                                      prefixIcon:
                                                                          Icon(Icons
                                                                              .location_city),
                                                                      contentPadding:
                                                                          EdgeInsets.fromLTRB(
                                                                              20,
                                                                              15,
                                                                              20,
                                                                              15),
                                                                      hintText:
                                                                          "Location",
                                                                      border:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                      )),
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            Material(
                                                              elevation: 5,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30),
                                                              color:
                                                                  kPrimaryColor,
                                                              child:
                                                                  MaterialButton(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            20,
                                                                            15,
                                                                            20,
                                                                            15),
                                                                minWidth:
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                onPressed:
                                                                    () async {
                                                                  NewUser
                                                                      nnewUser =
                                                                      newUser!;

                                                                  nnewUser
                                                                          .sensors![
                                                                              iindex]
                                                                          .location =
                                                                      locationController
                                                                          .text
                                                                          .toString();

                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'users')
                                                                      .doc(
                                                                          '$idValue')
                                                                      .set(nnewUser
                                                                          .toJson())
                                                                      .then(
                                                                          (value) {
                                                                    final snackBar =
                                                                        SnackBar(
                                                                      content: Text(
                                                                          "Successfully Updated"),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .green,
                                                                    );
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                            snackBar);

                                                                    Navigator.pop(
                                                                        context);
                                                                  });
                                                                },
                                                                child: Text(
                                                                  "Update Location",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ));
                                          },
                                          icon: Icon(Icons.edit)),
                                      IconButton(
                                        onPressed: () {
                                          showDialog<void>(
                                            context: context,
                                            barrierDismissible: false,
                                            // user must tap button!
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                title:
                                                    Text('Delete Confirmation'),
                                                content: Text(
                                                    'Are you sure you want to delete this sensor?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text('Confirm'),
                                                    onPressed: () {
                                                      print('Confirmed');
                                                      final snackBar = SnackBar(
                                                        content: Text(
                                                            "Successfully deleted"),
                                                        backgroundColor:
                                                            Colors.green,
                                                      );
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);

                                                      newUser!.sensors![iindex]
                                                          .location = "";
                                                      FirebaseFirestore.instance
                                                          .collection('users')
                                                          .doc('$idValue')
                                                          .set(
                                                              newUser!.toJson())
                                                          .then((value) {});
                                                      NotificationManager
                                                          .unSubscribeToSensorNotifications(
                                                              fromString(newUser!
                                                                  .sensors![
                                                                      iindex]
                                                                  .name!)!);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      )
                                    ],
                                  ))
                                ],
                              ),
                            ),
                          ),
                        );
                      })
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ],
    );
  }
}
