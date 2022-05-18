import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guard/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/new_user_model.dart';
import '../../model/sensor_model.dart';
import '../custom_widgets/header_with_seachbox.dart';
import '../custom_widgets/sensors.dart';
import '../custom_widgets/title_with_more_bbtn.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var _collectionRef = FirebaseFirestore.instance.collection('users');
  String idValue = "";
  NewUser? newUser;
  List<SensorData>  list_sensor = [];


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
                list_sensor = newUser!.sensors!;
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
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              HeaderWithSearchBox(size: size, newUser: newUser),
              TitleWithMoreBtn(
                  title: "Sensors",
                  press: () {
                    print(" Hello print");
                  }),
              Sensors(),
              SizedBox(height: kDefaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}
