import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:guard/screens/adding_sensors/adding_senor.dart';
import '../../constants.dart';

class TitleWithMoreBtn extends StatelessWidget {
  const TitleWithMoreBtn({
    Key? key,
    required this.title,
    required this.press,
  }) : super(key: key);
  final String title;
  final Function() press;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Row(
        children: <Widget>[
          TitleWithCustomUnderline(text: title),
          Spacer(),
          Container(
            height: 35,
            width: size / 3,
            child: FloatingActionButton.extended(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: Text("Add Sensor"),
              elevation: 20,
              backgroundColor: kPrimaryColor,
              onPressed: () async {
                // used to trigger a test anomaly
                //await  FirebaseDatabase.instance.reference().child("BME680").push().set({"time":"2022-01-30 22:54:11.548210","pressure":"1","gas":"30"});
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddSensorScreen()));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TitleWithCustomUnderline extends StatelessWidget {
  const TitleWithCustomUnderline({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: kDefaultPadding / 4),
            child: Text(
              text,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
