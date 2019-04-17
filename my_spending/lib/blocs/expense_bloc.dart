

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_spending/databases/expense_database.dart';
import 'package:my_spending/models/Expense.dart';

class ExpenseBloc extends Bloc{

  List<Expense> _expenseList;
  List<Expense> _monthList;
  List<Expense> _yearList;
  double _sumAll;

  StreamController<List<Expense>> _expenseListController = StreamController<List<Expense>>.broadcast();
  Sink<List<Expense>> get _inExpenseList => _expenseListController.sink;
  Stream<List<Expense>> get outExpenseList => _expenseListController.stream;

  StreamController<double> _expenseTotalController = StreamController<double>.broadcast();
  Sink<double> get _inExpenseTotal => _expenseTotalController.sink;
  Stream<double> get outExpenseTotal => _expenseTotalController.stream;

  StreamController<List<Expense>> _expenseMonthListController = StreamController<List<Expense>>.broadcast();
  Sink<List<Expense>> get _inExpenseListMonth => _expenseMonthListController.sink;
  Stream<List<Expense>> get outExpenseListMonth => _expenseMonthListController.stream;

  StreamController<double> _expenseMonthController = StreamController<double>.broadcast();
  Sink<double> get _inExpenseMonth => _expenseMonthController.sink;
  Stream<double> get outExpenseMonth => _expenseMonthController.stream;

  StreamController<List<Expense>> _expenseYearListController = StreamController<List<Expense>>.broadcast();
  Sink<List<Expense>> get _inExpenseListYear => _expenseYearListController.sink;
  Stream<List<Expense>> get outExpenseListYear => _expenseYearListController.stream;

  StreamController<double> _expenseYearController = StreamController<double>.broadcast();
  Sink<double> get _inExpenseYear => _expenseYearController.sink;
  Stream<double> get outExpenseYear => _expenseYearController.stream;

  StreamController<Expense> _findExpenseController = StreamController<Expense>.broadcast();
  Sink<Expense> get _inFindExpense => _findExpenseController.sink;
  Stream<Expense> get outFindExpense => _findExpenseController.stream;


  void getAllExpense(int idUser) async{
    print(idUser.toString());
    _expenseList = await ExpenseDB.exdb.getAllExpense(idUser);
    if(_expenseList.length > 0){
      print('Co ta: '+_expenseList.length.toString());
      _inExpenseList.add(_expenseList);
    }
  }

  void getTotalExpense(int idUser) async {
    _sumAll = await ExpenseDB.exdb.getTotal(idUser);
    _inExpenseTotal.add(_sumAll);
  }

  getMonthExpense(int month, int year, int idUser) async {
    _monthList = await ExpenseDB.exdb.getExpenseByMonth(month, year, idUser);
    if(_monthList.length>0){
      _inExpenseListMonth.add(_monthList);
    }else{
      _inExpenseListMonth.add(null);
    }
  }

  getMonthTotalExpense(int month, int year, int idUser){
    var result= ExpenseDB.exdb.getTotalByMonth(month, year, idUser);
    result.then((value){
      if(value>0){
        _inExpenseMonth.add(value);
      }else{
        _inExpenseMonth.add(null);
      }
    });
  }

  getYearExpense(int year, int idUser) async{
    _yearList = await ExpenseDB.exdb.getExpenseByYear(year, idUser);
    if(_yearList.length>0){
      _inExpenseListYear.add(_yearList);
    }else{
      _inExpenseListYear.add(null);
    }
  }

  getYearTotalExpense(int year, int idUser){
    double _totalYear;
    var result = ExpenseDB.exdb.getTotalByYear(year);
    result.then((value){
      if(value > 0){
        _totalYear = value;
      }else{
        _totalYear = null;
      }
    });
    _inExpenseYear.add(_totalYear);
  }

  findExpenseByContent(String dateShow, String content,double money, int idUser, BuildContext context) async{
    Expense expense = await ExpenseDB.exdb.getExpenseByContent(dateShow, content, money, idUser);

      if(expense != null){
        _inFindExpense.add(expense);
        Navigator.pushNamed(context, '/edit_expense_page');
      }else{
        _inFindExpense.add(expense);
      }

  }

  void addExpense(String mDateShow, String mDateConvert, String mContent, double money,int mDay, int mMonth, int mYear, int midUser, BuildContext context){
    Expense expense = new Expense(date: mDateShow, dateCon: mDateConvert, content: mContent, expense: money, day: mDay, month: mMonth, year: mYear, idUser: midUser);
    var result = ExpenseDB.exdb.newExpense(expense);
    result.then((value){
      if(value>0){
        print('value là: ' + value.toString());
        _expenseList.add(expense);
        print(_expenseList.length.toString());
        _inExpenseList.add(_expenseList);
        if(_sumAll == null){
          _inExpenseTotal.add(money);
        }else{
          _inExpenseTotal.add(_sumAll + money);
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

  void updateExpense(int mId,String mDateShow, String mDateConvert, String mContent, double money, int mDay, int mMonth, int mYear, int mIdUser, BuildContext context){
    Expense expense = new Expense(id: mId, date: mDateShow, dateCon: mDateConvert, content: mContent, day: mDay, expense: money, month: mMonth, year: mYear, idUser: mIdUser);
    var result = ExpenseDB.exdb.updateExpense(expense);
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

  void deleteExpense(int mId, int idUser, BuildContext context){
    var result = ExpenseDB.exdb.deleteExpense(mId, idUser);
    result.then((value){
      if(value>0){
        Navigator.pop(context);
      }else{
        Fluttertoast.showToast(msg: 'Có lỗi trong quá trình delete. Vui lòng thử lại!');
      }
    });
  }


  @override
  void dispose() {
    _expenseListController.close();
    _expenseTotalController.close();
    _expenseMonthListController.close();
    _expenseMonthController.close();
    _expenseYearListController.close();
    _expenseYearController.close();
    _findExpenseController.close();
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