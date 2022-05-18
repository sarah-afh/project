import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guard/constants.dart';
import 'package:guard/ui/screens/main_screen%20.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/new_user_model.dart';

class register extends StatefulWidget {
  const register({Key? key}) : super(key: key);

  @override
  _registerState createState() => _registerState();
}

class _registerState extends State<register> {
  //connection to database
  final _auth = FirebaseAuth.instance;

  // our form key
  final _formKey = GlobalKey<FormState>();

  //editing controller
  final firstNameEditingController = new TextEditingController();
  final secondNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final hubNumberEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();

  ///
  /// snacbar funcation
  void showSnackBar(BuildContext context, String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  ///

  @override
  Widget build(BuildContext context) {
    // first name field
    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("First Name cannot be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter a Valid Name with a Minimum of 3 Characters");
        }
        return null;
      },
      onSaved: (value) {
        firstNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "First Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    // second name field
    final secondNameField = TextFormField(
      autofocus: false,
      controller: secondNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Second Name cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        secondNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Second Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    // email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Your Email");
        }
        //reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a Valid Email");
        }
        return null;
      },
      onSaved: (value) {
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //hub number field added
    final hubNumberField = TextFormField(
      autofocus: false,
      controller: hubNumberEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = new RegExp("A2803");
        if (value!.isEmpty) {
          return ("Hub Number cannot be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter a Valid Hub Number");
        }
        return null;
      },
      onSaved: (value) {
        hubNumberEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.numbers),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Hub Number",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      obscureText: true,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password Is Required To Sign Up");
        }
        if (!regex.hasMatch(value)) {
          return ("Please Enter A Valid Password (Min. 6 Characters");
        }
      },
      onSaved: (value) {
        passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    // confirm password field
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordEditingController,
      obscureText: true,
      validator: (value) {
        if (confirmPasswordEditingController.text !=
            passwordEditingController.text) {
          return ("Passwords don't match");
        }
        return null;
      },
      onSaved: (value) {
        confirmPasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    final signupButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: kPrimaryColor,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signUp(emailEditingController.text, passwordEditingController.text);
        },
        child: Text(
          "Sign Up",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            //going back to the root
            icon: Icon(Icons.arrow_back, color: kPrimaryColor),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                          height: 180,
                          child: Image.asset(
                            "assets/images/logo-2.png",
                            fit: BoxFit.contain,
                          )),
                      SizedBox(height: 45),
                      firstNameField,
                      SizedBox(height: 20),
                      secondNameField,
                      SizedBox(height: 20),
                      emailField,
                      SizedBox(height: 20),
                      passwordField,
                      SizedBox(height: 20),
                      confirmPasswordField,
                      SizedBox(height: 20),
                      signupButton,
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  void signUp(String email, String password) async {
    try {
      if (_formKey.currentState!.validate()) {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => postDetailsToFirestore());
        final snackBar = SnackBar(
          content: Text("User Successfully Created"),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } on Exception catch (error) {
      final snackBar = SnackBar(
        content: Text("User already exists"),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  postDetailsToFirestore() {
    final firestore = FirebaseFirestore.instance;
    List<SensorData> sensors = [
      SensorData(
          imgUrl: "https://www.cairsensors.com/img/air-quality/icon-2.png",
          id: "BME680",
          name: "Air Quality",
          status: false,
          location: "",
          description:
              "Measures the air humidity, pressure and gas room through temperature,  quality of your room."),
      SensorData(
          imgUrl:
              "https://st3.depositphotos.com/1393072/36123/v/600/depositphotos_361233230-stock-illustration-runner-line-and-solid-icon.jpg",
          id: "LSM303D",
          name: "Motion",
          status: false,
          location: "",
          description: "Measures the movements done in your room"),
      SensorData(
          imgUrl:
              "https://cutewallpaper.org/23/abstract-wallpaper-raindow-vertical-lines/373718198.jpg",
          id: "AS7262",
          name: "Spectrum",
          status: false,
          location: "",
          description:
              "Spectrum a band of colours, as seen in a rainbow, produced by separation of the components of light by their different degrees of refraction according to wavelength."),
      SensorData(
          imgUrl:
              "https://thumbs.dreamstime.com/b/artist-s-palette-paints-brushes-black-white-vector-illustration-posters-coloring-books-other-items-isolated-object-155249998.jpg",
          id: "BH1745",
          name: "Color and Luminous",
          status: false,
          location: "",
          description:
              "Measures the colors and luminance percentages in your room (Red ,Green , Blue ) Light Concentration"),
    ];

    NewUser user = NewUser(
        uid: _auth.currentUser!.uid,
        firstname: firstNameEditingController.text.toString(),
        lastname: secondNameEditingController.text.toString(),
        email: emailEditingController.text.toString(),
        sensors: sensors);

    firestore.collection("users").add(user.toJson()).then((value) async {
      ///  for storing id in shared prefrences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('idValue', value.id);

      ///

      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(builder: (context) => MainScreen()),
          (route) => false);
    });
  }
}
