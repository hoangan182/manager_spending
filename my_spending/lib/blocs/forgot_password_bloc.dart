import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_spending/databases/user_database.dart';

class ForgotPasswordBloc extends Bloc{
  StreamController<String> _userForgotController = StreamController<String>.broadcast();
  StreamController<String> _passForgotController = StreamController<String>.broadcast();
  StreamController<String> _phoneForgotController = StreamController<String>.broadcast();

  Sink<String> get _inUser => _userForgotController.sink;
  Sink<String> get _inPass => _passForgotController.sink;
  Sink<String> get _inPhone => _phoneForgotController.sink;

  Stream<String> get outUser => _userForgotController.stream;
  Stream<String> get outPass => _passForgotController.stream;
  Stream<String> get outPhone => _phoneForgotController.stream;

  void getPass(String userForgot, String phoneForgot){
    var user = UserDB.db.findPassword(userForgot, phoneForgot);
    user.then((value){
      if(value != null){
        _inPass.add(value.passWord);
      }
      else{
        Fluttertoast.showToast(msg: 'Username does not exist or check again username and phone number');
      }

    });
  }

  @override
  void dispose() {
    _passForgotController.close();
    _phoneForgotController.close();
    _userForgotController.close();
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