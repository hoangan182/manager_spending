import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:MySpending/blocs/protect_motor_bloc.dart';
import 'package:MySpending/pickers/date_time_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputMotorPage extends StatefulWidget {
  @override
  _InputMotorPageState createState() => _InputMotorPageState();
}

class _InputMotorPageState extends State<InputMotorPage> {
  double widthDevice;

  double _money;
  String _content;

  TextEditingController controller = new TextEditingController();

  DateTime _fromDate = DateTime.now();

  SharedPreferences sharedPreferences;
  int idUser;

  String _dropdownValue;

  @override
  void initState() {
    super.initState();
    getIdUser();
    _dropdownValue = 'Khác';
  }

  getIdUser() async {
    sharedPreferences = await SharedPreferences.getInstance();
    idUser = sharedPreferences.getInt('idUser');
  }

  @override
  Widget build(BuildContext context) {
    final ProtectMotorBloc expenseBloc =
        BlocProvider.of<ProtectMotorBloc>(context);

    widthDevice = MediaQuery.of(context).size.width;

    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Protect Motor'),
        ),
        body: Container(
          margin: EdgeInsets.only(left: 15.0, right: 15.0),
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Text(
                'Protect your motor as below',
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
                      decoration: InputDecoration(
                          hintText: 'Input content...',
                          contentPadding:
                              EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 5.0)),
                      onChanged: (String value) {
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
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: 'Input money...',
                          contentPadding:
                              EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 5.0)),
                      onChanged: (String value) {
                        setState(() {
                          _money = double.parse(value);
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              submitButton(expenseBloc, context)
            ],
          ),
        ),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
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

  Widget submitButton(ProtectMotorBloc bloc, BuildContext context) {
    final f = new DateFormat('dd/MM/yy');
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
              if (_fromDate != null && _content != null && _money != null) {
                DateTime next;
                if (_dropdownValue == 'Thay dầu máy') {
                  next = _fromDate.add(new Duration(days: 60));
                } else if (_dropdownValue == 'Thay dầu lap') {
                  next = _fromDate.add(new Duration(days: 130));
                } else {
                  next = null;
                }
                ;
                String dateNext;
                if (next == null) {
                  dateNext = null;
                } else {
                  dateNext = f.format(next);
                }
                String dateShow = f.format(_fromDate);
                String dateCon = fC.format(_fromDate);

                int year = _fromDate.year;
                bloc.addMotor(idUser, dateShow, dateCon, dateNext, year,
                    _content, _dropdownValue, _money, context);
              }
            },
          ),
        );
      },
    );
  }
}
