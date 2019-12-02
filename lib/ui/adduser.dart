import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geo_attendance_system_hr/models/employee.dart';
import 'package:geo_attendance_system_hr/services/authentication.dart';

class AddUser extends StatefulWidget {
  @override
  _AddUSerState createState() => _AddUSerState();
}

class _AddUSerState extends State<AddUser> {
  final _formKey = new GlobalKey<FormState>();

  String key;
  int UID;
  String Name;
  String UUID;
  String PhoneNumber;
  String Address;
  String allotted_office;
  String manager;

  String email, password;

  FirebaseDatabase db = FirebaseDatabase();
  DatabaseReference _managerRef, _officeRef, _userRef, _employeeIDRef;

  var dropdownValueOffice, dropdownValueManager;
  String managerHintText = "Loading ...", officeHintText = "Loading ...";

  Map<String, dynamic> officeList;
  List<String> officeKeys;

  Map<String, dynamic> managerList;
  List<String> managerKeys;

  String _errorMessage;

  Auth authObject = Auth();

  @override
  void initState() {
    _managerRef = db.reference().child('managers');
    _officeRef = db.reference().child('location');
    _userRef = db.reference().child('users');
    _employeeIDRef = db.reference().child('EmployeeID');

    _getOffices();
    _getManagers();

    super.initState();
  }

  void _getOffices() async {
    _officeRef.once().then((DataSnapshot snapshot) {
      setState(() {
        officeList = new Map<String, dynamic>.from(snapshot.value);
        officeKeys = officeList.keys.toList();
        officeHintText = "Choose Location";
      });
    });
  }

  void _getManagers() async {
    _managerRef.once().then((DataSnapshot snapshot) {
      setState(() {
        managerList = new Map<String, dynamic>.from(snapshot.value);
        managerKeys = managerList.keys.toList();
        managerHintText = "Choose Manager";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a new Employee"),
      ),
      body: Container(
        child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Employee ID",
                        hintStyle: TextStyle(color: Colors.grey[400])),
                    validator: (value) {
                      String ret;
                      ret =
                          value.isEmpty ? 'Employee ID can\'t be empty' : null;
                      try {
                        int.parse(value);
                      } catch (e) {
                        ret = "Enter numeric value only";
                      }
                      return ret;
                    },
                    onSaved: (value) => UID = int.parse(value),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Name",
                        hintStyle: TextStyle(color: Colors.grey[400])),
                    validator: (value) =>
                        value.isEmpty ? 'Name can\'t be empty' : null,
                    onSaved: (value) => Name = value,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Email",
                        hintStyle: TextStyle(color: Colors.grey[400])),
                    validator: (value) =>
                        value.isEmpty ? 'Email can\'t be empty' : null,
                    onSaved: (value) => email = value,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.grey[400])),
                    validator: (value) =>
                        value.isEmpty ? 'Password can\'t be empty' : null,
                    onSaved: (value) => password = value,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "UUID",
                        hintStyle: TextStyle(color: Colors.grey[400])),
                    validator: (value) =>
                        value.isEmpty ? 'UUID can\'t be empty' : null,
                    onSaved: (value) => UUID = value,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Phone Number",
                        hintStyle: TextStyle(color: Colors.grey[400])),
                    validator: (value) {
                      String ret;
                      ret =
                          value.isEmpty ? 'Phone Number can\'t be empty' : null;

                      if (value.length != 10)
                        ret = "Enter 10-digit phone number";

                      return ret;
                    },
                    onSaved: (value) => PhoneNumber = value,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Address",
                        hintStyle: TextStyle(color: Colors.grey[400])),
                    validator: (value) =>
                        value.isEmpty ? 'Address can\'t be empty' : null,
                    onSaved: (value) => Address = value,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: DropdownButton<String>(
                    hint: Text(officeHintText),
                    value: allotted_office,
                    iconSize: 24,
                    elevation: 16,
                    underline: Container(
                      height: 2,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        print(newValue);
                        allotted_office = newValue;
                      });
                    },
                    items: officeKeys != null
                        ? officeKeys
                            .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(officeList[value]["name"]),
                            );
                          }).toList()
                        : [],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: DropdownButton<String>(
                    hint: Text(managerHintText),
                    value: manager,
                    iconSize: 24,
                    elevation: 16,
                    underline: Container(
                      height: 2,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        print(newValue);
                        manager = newValue;
                      });
                    },
                    items: managerKeys != null
                        ? managerKeys
                            .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(managerList[value]["name"]),
                            );
                          }).toList()
                        : [],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: _errorMessage != null
                      ? (Text(_errorMessage))
                      : Container(),
                ),
                Container(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Center(
                        child: RaisedButton(
                      child: Text("Add Employee", style: TextStyle(color: Colors.white)),
                      onPressed: () => validateEmployee(context),
                      color: Colors.blue,
                    ))),
                     Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Center(
                        child: RaisedButton(
                      child: Text("Reset Form", style: TextStyle(color: Colors.white)),
                      onPressed: () { _errorMessage = null; _formKey.currentState.reset();},
                      color: Colors.red,
                    )))
              ],
            )),
      ),
    );
  }

  void validateEmployee(context) {
    //_formKey.currentState.reset();

    if (_formKey.currentState.validate()) {
      if (this.manager == null) {
        _errorMessage = "Please select a manager value";
        return;
      }

      if (this.allotted_office == null) {
        _errorMessage = "Please select an office value";
        return;
      }
    }

    _formKey.currentState.save();
    createUser(context);
  }

  void createUser(BuildContext context) async {
    Employee employee = Employee(this.UID, this.Name, this.UUID,
        this.PhoneNumber, this.Address, this.allotted_office, this.manager);

    try {
      print("in try");
      authObject
          .signUp(this.email, this.password)
          .then((Map<int, String> value) {

            print(value.keys.first);

        if (value.keys.first == 0) {
          _userRef.child(value[0]).set(employee.toJson());
          _employeeIDRef.child(this.UID.toString()).set(this.email);

          showDialog(
            context: context,
              child: AlertDialog(
            title: Text("User Added Successfully"),
            content: Text(
                "User can start using his account through his employee ID and password."),
          ));
        } else {
          setState(() {
            showDialog(
              context: context,
                child: AlertDialog(
              title: Text("Some Error Occured"),
              content: value[1]!=null ? Text(
                  value[1]):Text(" "),
            ));
          });
        }
      });
    } catch (e) {
      print("in catch");
      print(e.message);
    }
  }
}