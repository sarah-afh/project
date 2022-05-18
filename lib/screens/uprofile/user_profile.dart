import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guard/components/my_bottom_nav_bar.dart';
import 'package:guard/constants.dart';
import 'package:guard/model/new_user_model.dart';
import 'package:guard/model/user_model.dart';
import 'package:guard/screens/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);


  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool isDataLoad = false;
  // User? user = FirebaseAuth.instance.currentUser;
  // NewUser loggedInUser = NewUser();

  @override
  void initState() {
    super.initState();
    // FirebaseFirestore.instance
    //     .collection("users")
    //     .doc(user?.uid)
    //     .get()
    //     .then((value) {
    //       loggedInUser =NewUser.fromJson(value.data()!);
    //   setState(() {});
    // });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: buildAppBar(),
      body: Center(
          child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 120,
                    child: Image.asset("assets/images/user_white.png"),
                  ),
                  SizedBox(height: 50),

                  isDataLoad ? Text(
                     "${newUser.firstname} ${newUser.lastname}",
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ):Container(),
                  isDataLoad ?   Text(
                    "${newUser.email}",
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ):Container(),
                  SizedBox(
                    height: 300,
                  ),
                  ActionChip(
                    label: Text("Logout"),
                    onPressed: () {
                      logout(context);
                    },
                    elevation: 5,
                    backgroundColor: reddish,
                  ),
                ],
              ))),
      // bottomNavigationBar: MyBottomNavBar(),
      //bottomNavigationBar: ,
    );
  }

  /*final logoutButton = Material(
    elevation: 0,
    borderRadius: BorderRadius.circular(30),
    color: reddish,
    child: MaterialButton(
    padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
    minWidth: 350,
    onPressed: () {
      logout(context);
    },
    child: Text(
    "Logout",
    textAlign: TextAlign.center,
    style: TextStyle(
    fontSize: 20,
    color: Colors.white,
    fontWeight: FontWeight.bold),



    ),),
    );*/

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => login()));
  }
}
