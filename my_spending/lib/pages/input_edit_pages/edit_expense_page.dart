
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_spending/blocs/expense_bloc.dart';
import 'package:my_spending/models/Expense.dart';
import 'package:my_spending/pickers/date_time_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';

class EditExpensePage extends StatefulWidget {
  @override
  _EditExpensePageState createState() => _EditExpensePageState();
}

class _EditExpensePageState extends State<EditExpensePage> {
  double widthDevice;
  String _content;
  double _money;

  TextEditingController _contentController;
  TextEditingController _incomeController;

  DateTime _fromDate = DateTime.now();

  SharedPreferences sharedPreferences;
  int idUser;

  @override
  void initState() {
    super.initState();
    ExpenseBloc expenseBloc = BlocProvider.of<ExpenseBloc>(context);
    getIdUser();
  }

  getIdUser() async{
    sharedPreferences = await SharedPreferences.getInstance();
    idUser = sharedPreferences.getInt('idUser');
  }
  @override
  Widget build(BuildContext context) {
    ExpenseBloc expenseBloc = BlocProvider.of<ExpenseBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Income'),
      ),
      body: Container(
          margin: EdgeInsets.only(left: 15.0, right: 15.0),
          child: StreamBuilder<Expense>(
              stream: expenseBloc.outFindExpense,
              builder: (context, snap) {
                print('data nhận: ' + snap.data.toString());
                if (snap.hasData) {
                  return ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        'Edit income below',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _buildTitle('Date', widthDevice, 50.0),
                          Container(
                            width: (widthDevice - 30) * 2 / 3,
                            height: 50.0,
                            child: DateTimePicker(
                              selectedDate: _fromDate,
                              selectDate: (DateTime date) {
                                setState(() {
                                  _fromDate = date;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _buildTitle('Income', widthDevice, 50.0),
                          Container(
                            width: (widthDevice - 30) * 2 / 3,
                            height: 50.0,
                            child: TextField(
                              controller: _contentController,
                              decoration: InputDecoration(
                                  hintText: 'Input income...',
                                  contentPadding: EdgeInsets.fromLTRB(
                                      10.0, 20.0, 10.0, 5.0)),
                              onChanged: (String value) {
                                setState(() {
                                  if (value != null) {
                                    _content = value;
                                  } else {
                                    _content = _content;
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _buildTitle('Money', widthDevice, 50.0),
                          Container(
                            width: (widthDevice - 30) * 2 / 3,
                            height: 50.0,
                            child: TextField(
                              controller: _incomeController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  hintText: 'Input money...',
                                  contentPadding: EdgeInsets.fromLTRB(
                                      10.0, 20.0, 10.0, 5.0)),
                              onChanged: (String value) {
                                setState(() {
                                  if (value != null) {
                                    _money = double.parse(value);
                                  } else {
                                    _money = _money;
                                  }
                                  print('tiền là: ' + _money.toString());
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget>[
//                      buttonEdit(incomeBloc, context, _idIncome, _fromDate, _content, _money),
//                      buttonDelete(incomeBloc, context, _idIncome)
//                    ],
//                  )
                    ],
                  );
                } else {
                  return Center(
                    child: Text('Không có dữ liệu'),
                  );
                }
              })),
    );
  }

  Widget _buildTitle(String title, double width, double mHeight) {
    return Container(
      width: (width - 30) / 3,
      height: mHeight,
      child: Text(
        title,
        style: TextStyle(fontSize: 16.0),
      ),
      alignment: AlignmentDirectional.bottomStart,
      padding: EdgeInsets.only(bottom: 10.0),
    );
  }

  Widget buttonEdit(ExpenseBloc bloc, BuildContext context, int id,
      DateTime date, String content, double money) {
    final f = new DateFormat('dd/MM/yyyy');
    final fC = new DateFormat('yyyyMMdd');
    return StreamBuilder<bool>(
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return Container(
          height: 44.0,
          width: widthDevice / 3,
          margin: EdgeInsets.only(left: 15.0, right: 15.0),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.5)),
            child: Text(
              'Edit',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blue[600],
            onPressed: () {
              if (date != null && content != null && money != null) {
                String dateShow = f.format(date);
                String dateConvert = fC.format(date);
                int month = date.month;
                int year = date.year;
//                bloc.updateIncome(id, dateShow, dateConvert, content, money,
//                    month, year, idUser, context);
              }
            },
          ),
        );
      },
    );
  }

  Widget buttonDelete(ExpenseBloc bloc, BuildContext context, int id) {
    final f = new DateFormat('dd/MM/yyyy');
    return StreamBuilder<bool>(
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return Container(
          height: 44.0,
          width: widthDevice / 3,
          margin: EdgeInsets.only(left: 15.0, right: 15.0),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.5)),
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blue[600],
            onPressed: () {
//              bloc.deleteIncome(id, idUser, context);
            },
          ),
        );
      },
    );
  }
}
