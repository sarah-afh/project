import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:guard/main.dart';
import 'package:guard/screens/adding_sensors/adding_senor.dart';
import 'package:guard/ui/screens/main_screen%20.dart';

const topicPrefix = "_topic";

class NotificationManager {
  static Future initialize() async {
    await FirebaseMessaging.instance.getToken();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
          settings: RouteSettings(name: "Home"),
          builder: (context) => MainScreen(InitialPage: 0)));
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      showDialog(
          context: navigatorKey.currentContext!,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Anomaly Detected"),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                  child: Text("Check"),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        settings: RouteSettings(name: "Home"),
                        builder: (context) => MainScreen(InitialPage: 0)));
                  },
                )
              ],
            );
          });
    });
  }

  static Future<void> subscribeToSensorNotifications(Sensors sensor) async {
    await FirebaseMessaging.instance.subscribeToTopic(topicName(sensor));
  }

  static Future<void> unSubscribeToSensorNotifications(Sensors sensor) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(topicName(sensor));
  }

  static String topicName(Sensors sensor) {
    return sensor.toSensorCode() + topicPrefix;
  }
}
