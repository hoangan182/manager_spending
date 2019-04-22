import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:MySpending/blocs/income_bloc.dart';
import 'package:MySpending/models/Income.dart';
import 'package:MySpending/pickers/date_time_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditIncomePage extends StatefulWidget {
  Income income;

  EditIncomePage({this.income});

  @override
  _EditIncomePageState createState() => _EditIncomePageState();
}

class _EditIncomePageState extends State<EditIncomePage> {
  double widthDevice;
  String _content;
  double _money;

  String _curContent;
  double _curMoney;

  TextEditingController _contentController;
  TextEditingController _incomeController;

  DateTime _fromDate;

  SharedPreferences sharedPreferences;
  int _idUser, _id;
  String _dateShow;

  @override
  void initState() {
    super.initState();
    IncomeBloc incomeBloc = BlocProvider.of<IncomeBloc>(context);
    _content = widget.income.content;
    _money = widget.income.income;
    _idUser = widget.income.idUser;
    _dateShow = widget.income.dateShow;
    _curContent = widget.income.content;
    _curMoney = widget.income.income;
    _contentController = TextEditingController(text: _curContent);
    _incomeController = TextEditingController(text: _curMoney.toString());
    //getIdUser();
  }

  getIdUser() async {
    sharedPreferences = await SharedPreferences.getInstance();
    _idUser = sharedPreferences.getInt('idUser');
  }

  @override
  Widget build(BuildContext context) {
    IncomeBloc incomeBloc = BlocProvider.of<IncomeBloc>(context);
    _fromDate = DateTime.parse(widget.income.dateConvert);
    widthDevice = MediaQuery.of(context).size.width;
    _idUser = widget.income.idUser;
    _id = widget.income.id;

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
                              print(_content);
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
                    buttonEdit(incomeBloc, context, _id, _idUser, _fromDate, _content, _money),
                    buttonDelete(incomeBloc, context, _id, _idUser)
                  ],
                )
              ],
            )),
      ),
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
      },
    )
      ;
  }

  Widget _buildTitle(String title, double mWidth, double mHeight) {
    return Container(
      width: (mWidth - 30.0) / 3,
      height: mHeight,
      child: Text(
        title,
        style: TextStyle(fontSize: 16.0),
      ),
      alignment: AlignmentDirectional.bottomStart,
      padding: EdgeInsets.only(bottom: 10.0),
    );
  }

  Widget buttonEdit(IncomeBloc bloc, BuildContext context, int id, int idUser,
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
                bloc.updateIncome(id, dateShow, dateConvert, content, money,
                    month, year, idUser, context);
                bloc.getAllIncome(idUser);
                bloc.getTotalAll(idUser);
              }
            },
          ),
        );
      },
    );
  }

  Widget buttonDelete(
      IncomeBloc bloc, BuildContext context, int id, int idUser) {
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
              bloc.deleteIncome(id, idUser, context);
              bloc.getAllIncome(idUser);
              bloc.getTotalAll(idUser);
            },
          ),
        );
      },
    );
  }
}
