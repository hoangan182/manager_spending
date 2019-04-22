import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:MySpending/blocs/protect_motor_bloc.dart';
import 'package:MySpending/models/Motor.dart';
import 'package:MySpending/pickers/date_time_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditMotorPage extends StatefulWidget {
  Motor motor;


  EditMotorPage({this.motor});

  @override
  _EditMotorPageState createState() => _EditMotorPageState();
}

class _EditMotorPageState extends State<EditMotorPage> {
  double widthDevice;
  String _content;
  double _money;

  String _curContent;
  double _curMoney;

  TextEditingController _contentController;
  TextEditingController _motorController;

  DateTime _fromDate;

  SharedPreferences sharedPreferences;
  int _idUser, _id;
  String _dateShow;
  String _dropdownValue;

  final List<String> _actions = <String>['Thay dầu máy', 'Thay dầu lap', 'Khác'];
  List<DropdownMenuItem<String>> _dropDownMenuActions;

  @override
  void initState() {
    super.initState();
    ProtectMotorBloc protectMotorBloc = BlocProvider.of<ProtectMotorBloc>(context);
    _dropdownValue = widget.motor.kind;
    _content = widget.motor.content;
    _money = widget.motor.money;
    _idUser = widget.motor.idUser;
    _dateShow = widget.motor.dateShow;
    _curContent = widget.motor.content;
    _curMoney = widget.motor.money;
    _contentController = TextEditingController(text: _curContent);
    _motorController = TextEditingController(text: _curMoney.toString());

  }


  getIdUser() async {
    sharedPreferences = await SharedPreferences.getInstance();
    _idUser = sharedPreferences.getInt('idUser');
  }

  @override
  Widget build(BuildContext context) {
    ProtectMotorBloc protectMotorBloc = BlocProvider.of<ProtectMotorBloc>(context);
    _fromDate = DateTime.parse(widget.motor.dateCon);
    widthDevice = MediaQuery.of(context).size.width;
    _idUser = widget.motor.idUser;
    _id = widget.motor.id;

    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Protect Motor'),
        ),
        body: Container(
            margin: EdgeInsets.only(left: 15.0, right: 15.0),
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Edit protect motor below',
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
                    _buildTitle('Content', widthDevice, 50.0),
                    Container(
                      width: (widthDevice - 30) * 2 / 3,
                      height: 50.0,
                      child: TextField(
                        controller: _contentController,
                        decoration: InputDecoration(
                            hintText: 'Input content...',
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
                    _buildTitle('Kind', widthDevice, 50.0),
                    Container(
                      width: (widthDevice - 30) * 2 / 3,
                      height: 50.0,
                      decoration: BoxDecoration(
                          border:
                          Border(bottom: BorderSide(color: Colors.black38))),
                      child: new DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _dropdownValue,
                            onChanged: (String newValue) {
                              setState(() {
                                _dropdownValue = newValue;
                              });
                            },
                            items: <String>['Thay dầu máy', 'Thay dầu lap', 'Khác']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Container(
                                    padding: EdgeInsets.only(left: 7.5),
                                    child: Text(value)),
                              );
                            }).toList(),
                          )),
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
                        controller: _motorController,
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
                    buttonEdit(protectMotorBloc, context, _id, _idUser, _fromDate, _content, _dropdownValue, _money),
                    buttonDelete(protectMotorBloc, context, _id, _idUser)
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

  Widget buttonEdit(ProtectMotorBloc bloc, BuildContext context, int id, int idUser, DateTime date, String content, String kind, double money) {
    print(kind);
    final f = new DateFormat('dd/MM/yy');
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
                DateTime next;
                if (kind == 'Thay dầu máy') {
                  next = date.add(new Duration(days: 60));
                } else if (kind == 'Thay dầu lap') {
                  next = date.add(new Duration(days: 130));
                } else {
                  next = null;
                };
                String dateNext;
                if (next == null) {
                  dateNext = null;
                } else {
                  dateNext = f.format(next);
                }
                print(kind);
                int year = date.year;
                bloc.updateMotor(id, idUser, dateShow, dateConvert, dateNext, year, content, kind, money, context);
                bloc.getAllMotor(idUser);
                bloc.getTotalMotor(idUser);
              }
            },
          ),
        );
      },
    );
  }

  Widget buttonDelete(
      ProtectMotorBloc bloc, BuildContext context, int id, int idUser) {
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
              bloc.deleteMotor(id, idUser, context);
              bloc.getAllMotor(idUser);
              bloc.getTotalMotor(idUser);
            },
          ),
        );
      },
    );
  }
}
