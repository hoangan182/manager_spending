import 'dart:async';
import 'package:bloc/bloc.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:MySpending/databases/user_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBloc extends Bloc {
  StreamController<String> _userController =
      StreamController<String>.broadcast();
  StreamController<String> _passController =
      StreamController<String>.broadcast();

  Sink<String> get _inUser => _userController.sink;

  Sink<String> get _inPass => _passController.sink;

  Stream<String> get outUser => _userController.stream;

  Stream<String> get outPass => _passController.stream;

  SharedPreferences sharedPreferences;

  void login(BuildContext context, String user, String pass, bool isCheck) {
//    var exits = UserDB.db.findUser(user, pass);
//    exits.then((value) {
//      if(value){
//        saveAccount(user, pass, isCheck);
//        Navigator.pushReplacementNamed(context, '/choose_page');
//      } else{
//        Fluttertoast.showToast(msg: 'Please check email and password again!');
//      }
//    });
    var result = UserDB.db.findUserLogin(user, pass);
    result.then((value) {
      if (value != null) {
        int id = value.id;
        saveAccount(user, pass, isCheck, id);
        Navigator.pushReplacementNamed(context, '/choose_page');
      } else {
        Fluttertoast.showToast(msg: 'Please check username and password again!');
      }
    });
  }

  saveAccount(String user, String pass, bool isCheck, int id) async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('username', user);
    sharedPreferences.setString('password', pass);
    sharedPreferences.setBool('check', isCheck);
    sharedPreferences.setInt('idUser', id);
  }

  @override
  void dispose() {
    _userController.close();
    _passController.close();
  }

  @override
  // TODO: implement initialState
  get initialState => null;

  @override
  Stream mapEventToState(event) {
    // TODO: implement mapEventToState
    return null;
  }
}
