import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:my_spending/databases/income_database.dart';
import 'package:my_spending/models/Income.dart';
import 'package:fluttertoast/fluttertoast.dart';

class IncomeBloc extends Bloc{
  List<Income> _incomeList;
  List<Income> _monthList;
  List<Income> _yearList;
  double _sumAll;
  int _id;


  StreamController<List<Income>> _incomeController = StreamController<List<Income>>.broadcast();
  Sink<List<Income>> get _inIncome => _incomeController.sink;
  Stream<List<Income>> get outIncome => _incomeController.stream;

  StreamController<double> _totalAllController = StreamController<double>.broadcast();
  Sink<double> get _inTotal => _totalAllController.sink;
  Stream<double> get outTotal => _totalAllController.stream;

  StreamController<List<Income>> _incomeMonthController = StreamController<List<Income>>.broadcast();
  Sink<List<Income>> get _inMonthIncome => _incomeMonthController.sink;
  Stream<List<Income>> get outMonthIncome => _incomeMonthController.stream;

  StreamController<double> _totalMonthController = StreamController<double>.broadcast();
  Sink<double> get _inMonth => _totalMonthController.sink;
  Stream<double> get outMonth => _totalMonthController.stream;

  StreamController<List<Income>> _incomeYearController = StreamController<List<Income>>.broadcast();
  Sink<List<Income>> get _inYearIncome => _incomeYearController.sink;
  Stream<List<Income>> get outYearIncome => _incomeYearController.stream;

  StreamController<double> _totalYearController = StreamController<double>.broadcast();
  Sink<double> get _inYear => _totalYearController.sink;
  Stream<double> get outYear => _totalYearController.stream;

  StreamController<int> _idIncomeController = StreamController<int>.broadcast();
  Sink<int> get _inIdIncome => _idIncomeController.sink;
  Stream<int> get outIdIncome => _idIncomeController.stream;

  StreamController<Income> _findIncomeController = StreamController<Income>.broadcast();
  Sink<Income> get _inFindIncome => _findIncomeController.sink;
  Stream<Income> get outFindIncome => _findIncomeController.stream;


  void getAllIncome(int idUser) async{
    _incomeList = await IncomeDB.icdb.getAllIncome(idUser);
    if(_incomeList.length>0){
      _inIncome.add(_incomeList);
    }
  }

  void getTotalAll(int idUser) async{
    _sumAll = await IncomeDB.icdb.getTotal(idUser);
    _inTotal.add(_sumAll);
  }

  void addIncome(String mDateShow, String mDateConvert, String mContent, double money, int mMonth, int mYear, int midUser, BuildContext context){
    Income income = new Income(dateShow: mDateShow, dateConvert: mDateConvert, content: mContent, income: money, month: mMonth, year: mYear, idUser: midUser);
    var result = IncomeDB.icdb.newIncome(income);
    result.then((value){
      if(value>0){
        _incomeList.add(income);
        _inIncome.add(_incomeList);
        if(_sumAll == null){
          _inTotal.add(money);
        }else{
          _inTotal.add(_sumAll + money);
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

  void updateIncome(int mId,String mDateShow, String mDateConvert, String mContent, double money, int mMonth, int mYear, int mIdUser, BuildContext context){
    Income income = new Income(id: mId, dateShow: mDateShow, dateConvert: mDateConvert, content: mContent, income: money, month: mMonth, year: mYear, idUser: mIdUser);
    var result = IncomeDB.icdb.updateIncome(income);
    result.then((value){
      if(value>0){
        print(money.toString());
        print(value.toString());
        new Timer(Duration(milliseconds: 500), () => Navigator.pop(context));
      }else{
        Fluttertoast.showToast(msg: 'Có lỗi trong quá trình update. Vui lòng thử lại!');
      }
    });
  }

  void deleteIncome(int mId, int idUser, BuildContext context){
    var result = IncomeDB.icdb.deleteIncome(mId, idUser);
    result.then((value){
      if(value>0){
        Navigator.pop(context);
      }else{
        Fluttertoast.showToast(msg: 'Có lỗi trong quá trình delete. Vui lòng thử lại!');
      }
    });
  }

  void findIncomeByMonth(int month, int year, int idUser) async{
    _monthList = await IncomeDB.icdb.getIncomeByMonth(month, year, idUser);

    if(_monthList.length>0){
      _inMonthIncome.add(_monthList);
    }else{
      _inMonthIncome.add(null);
    }
  }

  void getTotalMonth(int month, int year, int idUser){
    var result = IncomeDB.icdb.getTotalByMonth(month, year, idUser);
    result.then((value){
      if(value != null){
        _inMonth.add(value);
      }else{
        _inMonth.add(null);
      }
    });
  }


  void findIncomeByYear(int year, int idUser) async{
    _yearList = await IncomeDB.icdb.getIncomeByYear(year,idUser);

    if(_yearList.length>0){
      _inYearIncome.add(_yearList);
    }else{
      _inYearIncome.add(null);
    }
  }

  void getTotalYear(int year, int idUser){
    var result = IncomeDB.icdb.getTotalByYear(year, idUser);
    result.then((value){
      if(value != null){
        _inYear.add(value);
      }else{
        _inYear.add(null);
      }
    });
  }
  void getIdIncome(String dateShow, String content, double income, int idUser, BuildContext context){
    var result = IncomeDB.icdb.getIdByIncome(dateShow, content, income, idUser);
    result.then((value){
      if(value != null){
        _inIdIncome.add(value);
        print('bloc có: ' + value.toString());
        Navigator.pushNamed(context, '/edit_income_page');
      }else{
        _inIdIncome.add(null);
      }
    });

  }

  void findIncomeByContent(int idUser, String dateShow, String content, double mIncome, BuildContext context) async {
    Income income = await IncomeDB.icdb.getIncomeByContent(idUser, dateShow, content, mIncome);

      if(income != null){
        _inFindIncome.add(income);
        Navigator.pushNamed(context, '/edit_income_page');
      }else{
        _inFindIncome.add(income);
      }
  }






  @override
  void dispose() {
    _incomeController.close();
    _totalAllController.close();
    _totalMonthController.close();
    _incomeMonthController.close();
    _incomeYearController.close();
    _totalYearController.close();
    _idIncomeController.close();
    _findIncomeController.close();
  }

  @override

  get initialState => null;

  @override
  Stream mapEventToState(event) {

    return null;
  }
}