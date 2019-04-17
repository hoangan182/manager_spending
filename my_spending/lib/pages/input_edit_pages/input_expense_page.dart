
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_spending/blocs/expense_bloc.dart';
import 'package:my_spending/pickers/date_time_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputExpensePage extends StatefulWidget {
  @override
  _InputExpensePageState createState() => _InputExpensePageState();
}

class _InputExpensePageState extends State<InputExpensePage> {

  double widthDevice;

  double _money;
  String _content;

  TextEditingController controller = new TextEditingController();

  DateTime _fromDate = DateTime.now();

  SharedPreferences sharedPreferences;
  int idUser;

  @override
  void initState() {
    super.initState();
    getIdUser();
  }

  getIdUser() async{
    sharedPreferences = await SharedPreferences.getInstance();
    idUser = sharedPreferences.getInt('idUser');
  }

  @override
  Widget build(BuildContext context) {
    final ExpenseBloc expenseBloc = BlocProvider.of<ExpenseBloc>(context);

    widthDevice = MediaQuery.of(context).size.width;


    return Scaffold(
      appBar: AppBar(title: Text('Input Expense'),),
      body: Container(
        margin: EdgeInsets.only(left: 15.0, right: 15.0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 20.0,),
            Text('Input expense below',style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
            SizedBox(height: 15.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildTitle('Date', widthDevice, 50.0),
                Container(
                  width: (widthDevice-30)*2/3,
                  height: 50.0,
                  child: DateTimePicker(
                    selectedDate: _fromDate,
                    selectDate: (DateTime date){
                      setState(() {
                        _fromDate = date;
                      });
                    },
                  ),
                )
              ],
            ),
            SizedBox(height: 15.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildTitle('Expense', widthDevice, 50.0),
                Container(
                  width: (widthDevice-30)*2/3,
                  height: 50.0,
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Input expense...',
                        contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 5.0)
                    ),
                    onChanged: (String value){
                      setState(() {
                        _content = value;
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
                  width: (widthDevice-30)*2/3,
                  height: 50.0,
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Input money...',
                        contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 5.0)
                    ),
                    onChanged: (String value){
                      setState(() {
                        _money = double.parse(value);
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0,),
            submitButton(expenseBloc, context)
          ],
        ),
      )
      ,
    );
  }

  Widget _buildTitle(String title, double width, double mHeight){
    return Container(
      width: (width-30)/3,
      height: mHeight,
      child: Text(title, style: TextStyle(fontSize: 16.0),),
      alignment: AlignmentDirectional.bottomStart,
      padding: EdgeInsets.only(bottom: 10.0),
    );
  }

  Widget submitButton(ExpenseBloc bloc, BuildContext context) {
    final f = new DateFormat('dd/MM/yyyy');
    final fC = new DateFormat('yyyyMMdd');
    return StreamBuilder<bool>(
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return Container(
          height: 44.0,
          width: widthDevice,
          margin: EdgeInsets.only(left: 15.0, right: 15.0),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.5)),
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blue[600],
            onPressed: () {
              if(_fromDate != null && _content != null && _money != null){
                String date = f.format(_fromDate);
                String dateCon = fC.format(_fromDate);
                int day = _fromDate.day;
                int month = _fromDate.month;
                int year = _fromDate.year;
                bloc.addExpense(date, dateCon, _content, _money, day, month, year, idUser, context);
              }
            },
          ),
        );
      },
    );
  }
}
