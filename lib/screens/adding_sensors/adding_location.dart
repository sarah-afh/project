import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guard/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../../model/new_user_model.dart';

class AddLocationScreen extends StatefulWidget {
  const AddLocationScreen({Key? key}) : super(key: key);

  @override
  State<AddLocationScreen> createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController locationController = new TextEditingController();
  var _collectionRef = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    getData();
  }
  String idValue = "";
  NewUser? newUser;
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

              });
              // newUser = newUser;
            }
          });
        });
      });
      return newUser!;
    } catch (e) {
      print("Hello Janu data : ${e.toString()}");
      // return newUser;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            " Location of sensor:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          TextFormField(
            autofocus: false,
            controller: locationController,
            // keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Please Enter location of sensor");
              }
              //reg expression for email validation
              if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                  .hasMatch(value)) {
                return ("Please Enter a Valid Email");
              }
              return null;
            },
            onSaved: (value) {
              locationController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.location_pin),
              contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: "Bed Room etc",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red)),
                onPressed: () {

                },
                child: Text("Add")),
          ),
        ],
      ),
    );
  }
}

AppBar buildAppBar() {
  return AppBar(
    backgroundColor: kPrimaryColor.withOpacity(0.5),
    elevation: 0,
    centerTitle: true,
    title: Text("  Add Location "),
  );
}
