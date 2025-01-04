import 'dart:ffi';

import 'package:flutter/material.dart';
import '../Entidades.dart';
//import '../widgets/customOutputs.dart';

class UserProvider with ChangeNotifier {
  User _user = User();

  User get user => _user;

  bool isTutor() {
    return _user.isTutor;
  }

  String getId() {
    return _user.id;
  }

  User getUser() {
    return _user;
  }

  void setIsTutor(String type) {
    if (type == 'student') {
      _user.isTutor = false;
    } else {
      _user.isTutor = true;
    }
    Future.microtask(() {
      notifyListeners();
    });
  }

  void setTutor(Map<String, dynamic> data) {
    if (data['Mail'] != null) {
      _user.myTutor = Tutor(
          "${data['Name']} ${data['FirstSurname']} ${data['SecondSurname']}",
          data['Mail']);
    }
  }

  bool getIsTutor() {
    return user.isTutor;
  }

  Tutor getTutor() {
    return _user.myTutor!;
  }

  bool hasTutor() {
    return _user.hasTutor();
  }

  void insertMail(String mail) {
    _user.mail = mail;
  }

  bool insertData(Map<String, dynamic> data) {
    _user.name = data['Name'];
    //_user.id = data['ID'];
    _user.lastnameA = data['FirstSurname'];
    _user.lastnameB = data['SecondSurname'];
    _user.mail = data['Mail'];
    if (_user.mail.contains('@alumnos')) {
      _user.isTutor = false;
      if (data.containsKey("Tutor")) {
        setTutor(data["Tutor"]);
      }
    } else {
      _user.isTutor = true;
    }
    _user.code = data['Code'];
    /*Future.microtask(() {
      notifyListeners();
    });*/
    return true;
  }
}
