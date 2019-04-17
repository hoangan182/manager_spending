import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_spending/databases/user_database.dart';
import 'package:my_spending/models/User.dart';

class RegisterBloc extends Bloc{
  StreamController<String> _userRegController = StreamController<String>.broadcast();
  StreamController<String> _phoneRegController = StreamController<String>.broadcast();
  StreamController<String> _passRegController = StreamController<String>.broadcast();
  StreamController<String> _rePassController = StreamController<String>.broadcast();

  Sink<String> get _inUserReg => _userRegController.sink;
  Sink<String> get _inPhoneReg => _passRegController.sink;
  Sink<String> get _inPassReg => _passRegController.sink;
  Sink<String> get _inResReg => _rePassController.sink;

  Stream<String> get outUserReg => _userRegController.stream;
  Stream<String> get outPhoneReg => _phoneRegController.stream;
  Stream<String> get outPassReg => _passRegController.stream;
  Stream<String> get outRePassReg => _rePassController.stream;


  void register(BuildContext context, String userReg, String phoneReg, String passReg, String rePassReg){
    if(passReg == rePassReg){
      var exits = UserDB.db.findExistUser(userReg);
      exits.then((value) {
        if (value) {
          Fluttertoast.showToast(msg: 'Username exist!');
        } else {
          User user = new User(userName: userReg, passWord: passReg, phoneNumber: phoneReg);
          UserDB.db.newUser(user);
          Fluttertoast.showToast(msg: 'Register success!');
          Navigator.pop(context);
        }
      });

    }else{
      Fluttertoast.showToast(msg: 'Please check password again');
    }

  }

  @override
  void dispose() {
    _userRegController.close();
    _phoneRegController.close();
    _passRegController.close();
    _rePassController.close();
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