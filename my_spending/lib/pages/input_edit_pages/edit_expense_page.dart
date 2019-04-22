import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:MySpending/blocs/expense_bloc.dart';
import 'package:MySpending/models/Expense.dart';
import 'package:MySpending/pickers/date_time_picker.dart';


class EditExpensePage extends StatefulWidget {
  Expense expense;

  EditExpensePage({this.expense});

  @override
  _EditExpensePageState createState() => _EditExpensePageState();
}

class _EditExpensePageState extends State<EditExpensePage> {
  double widthDevice;
  String _content, _curContent;
  double _money, _curMoney;

  TextEditingController _contentController;
  TextEditingController _expenseController;

  DateTime _fromDate;
  int _idUser, _id;

  @override
  void initState() {
    super.initState();
    ExpenseBloc expenseBloc = BlocProvider.of<ExpenseBloc>(context);
    _content = widget.expense.content;
    _money = widget.expense.expense;
    _curContent = widget.expense.content;
    _curMoney = widget.expense.expense;
    _fromDate = DateTime.parse(widget.expense.dateCon);
    _id = widget.expense.id;
    _idUser = widget.expense.idUser;
    _contentController = TextEditingController(text: _curContent);
    _expenseController = TextEditingController(text: _curMoney.toString());
    //getIdUser();
  }

  @override
  Widget build(BuildContext context) {
    widthDevice = MediaQuery.of(context).size.width;
    ExpenseBloc expenseBloc = BlocProvider.of<ExpenseBloc>(context);

    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Income'),
        ),
        body: Container(
          margin: EdgeInsets.only(left: 15.0, right: 15.0),
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Text(
                'Edit income below',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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
                          contentPadding:
                          EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 5.0)),
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
                      controller: _expenseController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: 'Input money...',
                          contentPadding:
                          EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 5.0)),
                      onChanged: (String value) {
                        setState(() {
                          if (value != null) {
                            _money = double.parse(value);
                          } else {
                            _money = _money;
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  buttonEdit(expenseBloc, context, _id, _idUser, _fromDate, _content, _money),
                  buttonDelete(expenseBloc, context, _id, _idUser)
                ],
              )
            ],
          ),
        ),
      ),
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
      },
    )
      ;
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

  Widget buttonEdit(ExpenseBloc bloc, BuildContext context, int id, int idUser, DateTime date, String content, double money) {
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
                bloc.updateExpense(id, dateShow, dateConvert, content, money, month, year, idUser, context);
                bloc.getAllExpense(idUser);
                bloc.getTotalExpense(idUser);
              }
            },
          ),
        );
      },
    );
  }

  Widget buttonDelete(ExpenseBloc bloc, BuildContext context, int id, int idUser) {
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
               bloc.deleteExpense(id, idUser, context);
               bloc.getAllExpense(idUser);
               bloc.getTotalExpense(idUser);
            },
          ),
        );
      },
    );
  }
}
