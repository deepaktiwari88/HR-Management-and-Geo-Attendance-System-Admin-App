import 'package:flutter/material.dart';
import 'package:geo_attendance_system_hr/services/authentication.dart';
import 'package:geo_attendance_system_hr/ui/splashscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter login demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:  SplashScreenWidget(auth: new Auth()));
  }
}