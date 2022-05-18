// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:guard/components/my_bottom_nav_bar.dart';
// import 'package:guard/model/user_model.dart';
// import 'package:guard/screens/main_screen/components/home.dart';
//
// //import 'package:guard/screens/sidebar.dart';
// import '../../../constants.dart';
// import 'components/header_with_seachbox.dart';
// import 'components/sensors.dart';
// import 'components/title_with_more_bbtn.dart';
//
// class MainScreen extends StatefulWidget {
//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen> {
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: buildAppBar(),
//        body:  null,
//       // body: Column(
//       //   crossAxisAlignment: CrossAxisAlignment.start,
//       //   children: <Widget>[
//       //     HeaderWithSearchBox(size: size),
//       //     TitleWithMoreBtn(title: "Sensors", press: () {}),
//       //     sensors(),
//       //     SizedBox(height: kDefaultPadding),
//       //   ],
//       // ),
//
//       bottomNavigationBar: MyBottomNavBar(),
//     );
//   }
//

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guard/screens/testing.dart';
import 'package:guard/screens/uprofile/user_profile.dart';

import '../../constants.dart';
import 'home.dart';

class MainScreen extends StatefulWidget {
  final int InitialPage;

  const MainScreen({this.InitialPage = 1, Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _pages = [
    const Testing(),
    Home(),
    UserProfile(),
  ];
  int _selectedPageIndex = 1;

  @override
  void initState() {
    _selectedPageIndex = widget.InitialPage;
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print("received $message");
      if (message == null) {
        return;
      }
      WidgetsBinding.instance!.scheduleFrameCallback((timeStamp) {
        _selectPage(0);
      });
    });
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: _selectPage,
          backgroundColor: kPrimaryColor.withOpacity(0.5),
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.black,
          currentIndex: _selectedPageIndex,
          showUnselectedLabels: true,
          unselectedFontSize: 12,
          selectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.warning), label: "Warning"),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
              label: "Profile",
              icon: Icon(Icons.person),
            ),
          ]),
    );
  }
}

AppBar buildAppBar() {
  return AppBar(
    backgroundColor: kPrimaryColor.withOpacity(0.5),
    elevation: 0,
    leading: IconButton(
      icon: SvgPicture.asset("assets/icons/menu.svg"),
      onPressed: () {},
    ),
  );
}
