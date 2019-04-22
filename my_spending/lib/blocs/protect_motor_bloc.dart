import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:MySpending/databases/motor_database.dart';
import 'dart:async';
import 'package:MySpending/models/Motor.dart';

class ProtectMotorBloc extends Bloc{
  List<Motor> _motorList;
  List<Motor> _yearList;
  double _sumAll;

  StreamController<List<Motor>> _motorListController = StreamController<List<Motor>>.broadcast();
  Sink<List<Motor>> get _inMotorList => _motorListController.sink;
  Stream<List<Motor>> get outMotorList => _motorListController.stream;

  StreamController<double> _motorTotalController = StreamController<double>.broadcast();
  Sink<double> get _inMotorTotal => _motorTotalController.sink;
  Stream<double> get outMotorTotal => _motorTotalController.stream;

  StreamController<List<Motor>> _motorListYearController = StreamController<List<Motor>>.broadcast();
  Sink<List<Motor>> get _inMotorListYear => _motorListYearController.sink;
  Stream<List<Motor>> get outMotorListYear => _motorListYearController.stream;

  StreamController<double> _motorYearTotalController = StreamController<double>.broadcast();
  Sink<double> get _inMotorYearTotal => _motorYearTotalController.sink;
  Stream<double> get outMotorYearTotal => _motorYearTotalController.stream;

  void getAllMotor(int idUser) async{
    _motorList = await MotorDB.mtdb.getAllMotor(idUser);
    if(_motorList.length > 0){
      _inMotorList.add(_motorList);
    }
  }

  void getTotalMotor(int idUser) async {
    _sumAll = await MotorDB.mtdb.getTotal(idUser);
    _inMotorTotal.add(_sumAll);
  }

  getYearMotor(int year, int idUser) async{
    _yearList = await MotorDB.mtdb.getMotorByYear(year, idUser);
    if(_yearList.length>0){
      _inMotorListYear.add(_yearList);
    }else{
      _inMotorListYear.add(null);
    }
  }

  getYearTotalMotor(int year, int idUser){
    double _totalYear;
    var result = MotorDB.mtdb.getTotalByYear(year);
    result.then((value){
      if(value > 0){
        _totalYear = value;
      }else{
        _totalYear = null;
      }
    });
    _inMotorYearTotal.add(_totalYear);
  }


  void addMotor(int midUser, String mDateShow, String mDateCon, String mDateNext, int mYear, String mContent, String mKind, double money, BuildContext context){
    Motor motor = new Motor(idUser: midUser, dateShow: mDateShow, dateCon: mDateCon, dateNext: mDateNext, year: mYear, content: mContent, kind: mKind, money: money);
    var result = MotorDB.mtdb.newMotor(motor);
    result.then((value){
      if(value>0){
        _motorList.add(motor);
        _inMotorList.add(_motorList);
        if(_sumAll == null){
          _inMotorTotal.add(money);
        }else{
          _inMotorTotal.add(_sumAll + money);
        }

        final snackBar = SnackBar(
          content: Text('Thêm thành công : ' + mContent),
        );
        Scaffold.of(context).showSnackBar(snackBar);
        new Timer(Duration(seconds: 1), () => Navigator.pop(context));

      }else{
        print('Không được đâu, thử lại đi');
      }
    });
  }

  void updateMotor(int mId, int midUser, String mDateShow, String mDateCon, String mDateNext, int mYear, String mContent, String mKind, double money, BuildContext context){
    Motor motor = new Motor(id: mId, idUser: midUser, dateShow: mDateShow, dateCon: mDateCon, dateNext: mDateNext, year: mYear, content: mContent, kind: mKind, money: money);
    var result = MotorDB.mtdb.updateMotor(motor);
    result.then((value){
      if(value>0){
        final snackBar = SnackBar(
          content: Text('Sửa thành công : ' + mContent),
        );
        Scaffold.of(context).showSnackBar(snackBar);
        new Timer(Duration(milliseconds: 500), () => Navigator.pop(context));
      }else{
        Fluttertoast.showToast(msg: 'Có lỗi trong quá trình update. Vui lòng thử lại!');
      }
    });
  }

  void deleteMotor(int mId, int idUser, BuildContext context){
    var result = MotorDB.mtdb.deleteMotor(mId, idUser);
    result.then((value){
      if(value>0){
        final snackBar = SnackBar(
          content: Text('Xóa thành công'),
        );
        Scaffold.of(context).showSnackBar(snackBar);
        new Timer(Duration(milliseconds: 500), () => Navigator.pop(context));
      }else{
        Fluttertoast.showToast(msg: 'Có lỗi trong quá trình delete. Vui lòng thử lại!');
      }
    });
  }


  @override
  void dispose() {
    _motorListController.close();
    _motorTotalController.close();
    _motorListYearController.close();
    _motorYearTotalController.close();
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