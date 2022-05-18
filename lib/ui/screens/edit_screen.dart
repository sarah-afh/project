import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guard/database.dart';

import '../../constants.dart';

class EditScreen extends StatefulWidget {
  EditScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();

  //editing password
  final TextEditingController locationController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          TextFormField(
            autofocus: false,
            controller: locationController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Please Enter Your location");
              }
              return null;
            },
            onSaved: (value) {
              locationController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.location_city),
                contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                hintText: "Location",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
          ),
          SizedBox(
            height: 20,
          ),
          Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(30),
            color: kPrimaryColor,
            child: MaterialButton(
              padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              minWidth: MediaQuery.of(context).size.width,
              onPressed: () {},
              child: Text(
                "Update",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
