import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:MySpending/blocs/protect_motor_bloc.dart';
import 'package:MySpending/models/Motor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class YearMotorPage extends StatefulWidget {
  @override
  _YearMotorPageState createState() => _YearMotorPageState();
}

class _YearMotorPageState extends State<YearMotorPage> {
  double widthDevice, heightDevice;
  List<int> _years = [];

  int _currentYear;
  List<DropdownMenuItem<int>> _dropDownMenuYears;

  final fN = new NumberFormat('#,###');
  final f = new DateFormat('dd/MM/yy');


  SharedPreferences sharedPreferences;
  int idUser;


  @override
  void initState() {
    getIdUser();
    _currentYear = DateTime.now().year;
    _years = <int>[_currentYear - 3, _currentYear - 2, _currentYear - 1, _currentYear];
    _dropDownMenuYears = getDropDownMenuYears();
  }

  getIdUser() async{
    sharedPreferences = await SharedPreferences.getInstance();
    idUser = sharedPreferences.getInt('idUser');
  }

  List<DropdownMenuItem<int>> getDropDownMenuYears() {
    List<DropdownMenuItem<int>> years = new List();
    for (int year in _years) {
      years.add(new DropdownMenuItem(
          value: year,
          child: new Text(
            "$year",
          )));
    }
    return years;
  }

  void changedDropDownYear(int selectedYear) {
    setState(() {
      _currentYear = selectedYear;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ProtectMotorBloc protectMotorBloc = BlocProvider.of<ProtectMotorBloc>(context);
    widthDevice = MediaQuery.of(context).size.width;
    heightDevice = MediaQuery.of(context).size.height;
    return Column(
      children: <Widget>[
        Container(
          height: 40.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: (widthDevice - 20.0) / 8,
                child: Text(
                  'Year',
                  style: TextStyle(fontSize: 14.0),
                ),
              ),
              Container(
                  width: (widthDevice - 20.0) / 4,
                  child: new DropdownButtonHideUnderline(
                    child: new ButtonTheme(
                      alignedDropdown: true,
                      child: new DropdownButton(
                        style: TextStyle(fontSize: 14.0, color: Colors.black),
                        isExpanded: true,
                        value: _currentYear,
                        items: _dropDownMenuYears,
                        onChanged: changedDropDownYear,
                      ),
                    ),
                  )),
              StreamBuilder(
                  builder: (context, snapshot){
                    return Container(
                        width: (widthDevice - 20.0) / 4,
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)
                            ),
                            padding: EdgeInsets.all(0.0),
                            color: Colors.blue,
                            child: Text('Find', style: TextStyle(fontSize: 16.0, color: Colors.white),),
                            onPressed: (){
                              protectMotorBloc.getYearMotor(_currentYear, idUser);
                              protectMotorBloc.getYearTotalMotor(_currentYear, idUser);
                            })
                    );
                  })
            ],
          ),
        ),
        Container(
          height: heightDevice - 220.0,
          child: StreamBuilder<List<Motor>>(
            stream: protectMotorBloc.outMotorListYear,
            builder: (context, snapshot){
              if(snapshot.hasData){
                return CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              Motor motor = snapshot.data[index];
                          var mMoney = motor.money;
                          var mDateShow = motor.dateShow;
                          var mDateNext = motor.dateNext;
                          var mContent = motor.content;
                          return Container(
                            margin: EdgeInsets.only(left: 15.0, right: 15.0),
                            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(mContent),
                                  flex: 1,
                                ),
                                Expanded(
                                  child: Text(mDateShow),
                                  flex: 1,
                                ),
                                Expanded(
                                  child: Text(mDateNext),
                                  flex: 1,
                                ),
                                Expanded(
                                  child: Text(
                                    fN.format(mMoney),
                                    textAlign: TextAlign.right,
                                  ),
                                  flex: 1,
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.black26),
                                )),
                          );
                        },
                        childCount: snapshot.data.length,
                      ),
                    )
                  ],
                );
              }else{
                return Center(
                  child: Text('There are no data!'),
                );
              }
            },
          ),
        ),
        Container(
            height: 40.0,
            child: StreamBuilder(
                stream: protectMotorBloc.outMotorYearTotal,
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return Container(
                      color: Colors.white,
                      height: 40.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'Total of year: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            flex: 5,
                          ),
                          Expanded(
                            child: Text(
                              fN.format(snapshot.data),
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.right,
                            ),
                            flex: 3,
                          )
                        ],
                      ),
                    );
                  }else{
                    return Container();
                  }
                })
        )
      ],
    );
  }
}
