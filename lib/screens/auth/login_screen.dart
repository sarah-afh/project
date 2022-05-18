import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:guard/screens/auth/registration_screen.dart';
import 'package:guard/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ui/screens/main_screen .dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
//form key

  final _formKey = GlobalKey<FormState>();

// editing controller
  final TextEditingController emailController = new TextEditingController();

  //editing password
  final TextEditingController passwordController = new TextEditingController();

  //firebase call
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  void showSnackBar(BuildContext context, String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    // email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
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
        emailController.text = value!;
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
    //password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password Is Required To Login");
        }
        if (!regex.hasMatch(value)) {
          return ("Please Enter A Valid Password!");
        }
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: kPrimaryColor,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signIn(emailController.text, passwordController.text);
        },
        child: Text(
          "Login",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
        backgroundColor: Colors.white,
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
                          height: 200,
                          child: Image.asset(
                            "assets/images/logo-2.png",
                            fit: BoxFit.contain,
                          )),
                      SizedBox(height: 45),
                      emailField,
                      SizedBox(height: 25),
                      passwordField,
                      SizedBox(height: 35),
                      loginButton,
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Don't have an account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => register()));
                            },
                            child: Text("Sign Up!",
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                          ),
                          /*GestureDetector(onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => register()));
                        },
                          child: Text("\nForgot Password?", style: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.bold, fontSize: 15)),
                        )*/
                          //child: Text("Forgot Password?", style: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.bold, fontSize: 15),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  //login function
  void signIn(String email, String password) async {
    try {
      if (_formKey.currentState!.validate()) {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then(
          (idValue) async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String? idValue = prefs.getString("idValue");

            // showSnackBar(context, "Successfully login");
            final snackBar = SnackBar(
              content: Text("Successfully login"),
              backgroundColor: Colors.green,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => MainScreen()));
          },
        );
      }
    } on Exception catch (error) {
      // showSnackBar(context, "User not found");
      final snackBar = SnackBar(
        content: Text("User not found"),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
