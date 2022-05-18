import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:guard/constants.dart';
import 'package:guard/notification/notification_manager.dart';
import 'package:guard/screens/auth/login_screen.dart';
import 'package:guard/ui/screens/main_screen%20.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final navigatorKey = GlobalKey<NavigatorState>();
SharedPreferences? _sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationManager.initialize();
  _sharedPreferences = await SharedPreferences.getInstance();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Guard',
      theme: ThemeData(
        scaffoldBackgroundColor: kBackgroundColor,
        primaryColor: kPrimaryColor,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: login(),
    );
  }
}
