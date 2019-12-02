import 'package:firebase_database/firebase_database.dart';

class Employee{
  String key;
  int UID;
  String Name;
  String UUID;
  String PhoneNumber;
  String Address;
  String allotted_office;
  String manager;

  Employee(this.UID, this.Name, this.UUID, this.PhoneNumber, this.Address, this.allotted_office, this.manager);

  Employee.fromSnapshot(DataSnapshot snapshot) :
    key = snapshot.key,
    UID = snapshot.value["UID"],
    Name = snapshot.value["Name"],
    PhoneNumber = snapshot.value["PhoneNumber"],
    Address = snapshot.value["Address"],
    allotted_office = snapshot.value["allotted_office"],
    manager = snapshot.value["manager"];

  toJson() {
    return {
      "UID": UID, 
      "Name": Name,
      "UUID": UUID,
      "PhoneNumber": PhoneNumber,
      "Address": Address,
      "allotted_office": allotted_office,
      "manager": manager,
    };
  }
}
