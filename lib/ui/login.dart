import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geo_attendance_system_hr/animations/loginanimation.dart';
import 'package:geo_attendance_system_hr/services/authentication.dart';
import 'package:geo_attendance_system_hr/ui/homepage.dart';
import 'package:geo_attendance_system_hr/ui/widgets/loader_dialog.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final _formKey = new GlobalKey<FormState>();
  String _employeeID;
  String password;
  Auth authObject;

  FirebaseDatabase db = new FirebaseDatabase();
  DatabaseReference _empIdRef, _userRef;

  String _username;
  String _password;
  String _errorMessage;

  FirebaseUser _user;

   @override
    void initState() {
      _userRef = db.reference().child("users");
      _empIdRef = db.reference().child('EmployeeID');
      print(_userRef.toString());
      authObject = new Auth();

      super.initState();
    }

  @override
  Widget build(BuildContext context) {

    final emailField = TextField(
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordField = TextField(
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {},
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.fill
                )
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 30,
                    width: 80,
                    height: 200,
                    child: FadeAnimation(1, Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/light-1.png')
                        )
                      ),
                    )),
                  ),
                  Positioned(
                    left: 140,
                    width: 80,
                    height: 150,
                    child: FadeAnimation(1.3, Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/light-2.png')
                        )
                      ),
                    )),
                  ),
                  Positioned(
                    right: 40,
                    top: 30,
                    width: 80,
                    height: 150,
                    child: FadeAnimation(1.5, Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/clock.png')
                        )
                      ),
                    )),
                  ),
                  Positioned(
                    child: FadeAnimation(1.6, Container(
                      margin: EdgeInsets.only(top: 60),
                      child: Center(
                        child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),),
                      ),
                    )),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  FadeAnimation(1.8, 
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(143, 148, 251, .2),
                          blurRadius: 20.0,
                          offset: Offset(0, 10)
                        )
                      ]
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey[100]))
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Employee ID",
                              hintStyle: TextStyle(color: Colors.grey[400])
                            ),
                            validator: (value) => value.isEmpty ? 'Employee ID can\'t be empty' : null,
                            onSaved: (value) => _username = value,
                          ),

                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.grey[400])
                            ),
                            validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
                            onSaved: (value) => _password = value,
                          ),
                        )
                      ],
                    ),
                  )
                  )),
                  SizedBox(height: 60,
                  child: (_errorMessage!=null)?(Container(padding: const EdgeInsets.fromLTRB(5, 10, 5, 10), child: Text(_errorMessage, style: TextStyle(color: Colors.red)))):Container()),
                  FadeAnimation(2, InkWell(
                    onTap: () { 
                      if(_formKey.currentState.validate()){
                        _formKey.currentState.save();
                        onLoadingDialog(context);
                        validateAndSubmit();
                    }},
                    child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(33, 150, 253, 1),
                          Color.fromRGBO(33, 150, 253, .6),
                        ]
                      )
                    ),
                    child: Center(
                      child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    ),
                  )),),
                  SizedBox(height: 20,),
                  FadeAnimation(2,  InkWell(
                    onTap: () { _formKey.currentState.reset(); setState(() {
                     _errorMessage = null; 
                    });
                    },
                    child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(255, 171, 64, 1),
                          Color.fromRGBO(255, 171, 64, .6),
                        ]
                      )
                    ),
                    child: Center(
                      child: Text("Reset", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    ),
                  )),),
                  SizedBox(height: 70,),
                  /*FadeAnimation(1.5, Text("Forgot Password?", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),)),*/
                  
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void validateAndSubmit() async {
  
      String email;
      try {
        _empIdRef.child('hr').child(_username).once().then((DataSnapshot snapshot) {
          if (snapshot == null) {
            print("popped");
            _errorMessage = "Invalid Login Details";
          } else {
            email = snapshot.value;
          }
          loginUser(email);
        });
      } catch (e) {
        print(e);
      }
    }

    void loginUser(String email) async {
    if (email != null) {
      try {
        _user = await authObject.signIn(email, _password);
        Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
      } catch (e) {
        Navigator.of(context).pop();
        print("Error" + e.toString());
        setState(() {
          _errorMessage = e.message.toString();
          _formKey.currentState.reset();
        });
      }
    } else {
      setState(() {
        _errorMessage = "Invalid Login Details";
        _formKey.currentState.reset();
        Navigator.of(context).pop();
      });
    }
  }
}
