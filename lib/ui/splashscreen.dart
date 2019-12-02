import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geo_attendance_system_hr/constants/colors.dart';
import 'package:geo_attendance_system_hr/services/authentication.dart';
import 'package:geo_attendance_system_hr/ui/adduser.dart';
import 'package:geo_attendance_system_hr/ui/homepage.dart';
import 'package:geo_attendance_system_hr/ui/login.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class SplashScreenWidget extends StatefulWidget {
  SplashScreenWidget({this.auth});

  final BaseAuth auth;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenWidget> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () {
      widget.auth.getCurrentUser().then((user) {
        setState(() {
          if (user != null) {
            _userId = user?.uid;
          }

          authStatus = user?.uid == null
              ? AuthStatus.NOT_LOGGED_IN
              : AuthStatus.LOGGED_IN;

          MaterialPageRoute loginRoute = new MaterialPageRoute(
              builder: (BuildContext context) => LoginPage());
          MaterialPageRoute homePageRoute = new MaterialPageRoute(
              builder: (BuildContext context) => AddUser());

          if (authStatus == AuthStatus.LOGGED_IN) {
            Navigator.pushReplacement(context, homePageRoute);
          } else {
            if (authStatus == AuthStatus.NOT_LOGGED_IN)
              Navigator.pushReplacement(context, loginRoute);
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: const [splashScreenColorBottom, splashScreenColorTop],
            begin: Alignment.bottomCenter,
            end: Alignment.topRight,
          ),
        ),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              padding: const EdgeInsets.only(top: 80),
              child: SpinKitThreeBounce(
                color: Colors.white,
                size: 30.0,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}