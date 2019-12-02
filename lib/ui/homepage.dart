import 'package:flutter/material.dart';
import 'package:geo_attendance_system_hr/services/authentication.dart';
import 'package:geo_attendance_system_hr/ui/login.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Auth authObj = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text("LOGOT"),
          onPressed: _logOut,))
    );
  }

  void _logOut() async{
    await authObj.signOut();
    Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false);
  }
}