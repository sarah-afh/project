import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guard/model/new_user_model.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';

class HeaderWithSearchBox extends StatefulWidget {

  NewUser? newUser;
   HeaderWithSearchBox({Key? key, required this.size, required this.newUser}) : super(key: key);
  final Size size;

  @override
  _header createState() => _header();
}

class _header extends State<HeaderWithSearchBox> {

 bool isDataLoad = false;
  @override
  void initState() {
    super.initState();
    getData();
  }
  var _collectionRef = FirebaseFirestore.instance.collection('users');

  NewUser newUser = NewUser();

  Future<dynamic> getData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? idValue = prefs.getString("idValue");

      QuerySnapshot querySnapshot = await _collectionRef.get();
      setState(() {
        _collectionRef.snapshots().forEach((first_element) {
          first_element.docs.forEach((element) {
            if (element.id == idValue) {
              setState(() {

                newUser = NewUser.fromJson(element.data());
                 isDataLoad = true;
              });

              // newUser = newUser;
            }
          });
        });
      });
      return newUser;
    } catch (e) {
      print("Hello Janu data : ${e.toString()}");
      // return newUser;
    }
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: kDefaultPadding * 2.5),
      // It will cover 20% of our total height
      height: size.height * 0.2,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              left: kDefaultPadding,
              right: kDefaultPadding,
              bottom: 36 + kDefaultPadding,
            ),
            height: size.height * 0.2 - 27,
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.5),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
            ),
            child: Row(
              children: <Widget>[

                isDataLoad ?  Text(
                  "  Hi ${newUser.firstname.toString()}!",
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ) : Container(),
                Spacer(),
                Image.asset("assets/images/logo-2.png")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
