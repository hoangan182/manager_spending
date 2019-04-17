import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_spending/blocs/income_bloc.dart';
import 'package:my_spending/models/Income.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MonthIncomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {

    return _MonthIncomePageState();
  }
}

class _MonthIncomePageState extends State<MonthIncomePage> {

  final List<int> _months = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  List<int> _years = [];

  int _currentYear;
  int _currentMon;
  List<DropdownMenuItem<int>> _dropDownMenuMonths;
  List<DropdownMenuItem<int>> _dropDownMenuYears;

  final fN = new NumberFormat('#,###');
  final f = new DateFormat('dd/MM/yyyy');

  double widthDevice;
  double heightDevice;
  SharedPreferences sharedPreferences;
  int idUser;

  @override
  void initState() {
    super.initState();
    getIdUser();
    _dropDownMenuMonths = getDropDownMenuMonths();
    _currentMon = DateTime.now().month;
    _currentYear = DateTime.now().year;
    _years = <int>[_currentYear - 2, _currentYear - 1, _currentYear];
    _dropDownMenuYears = getDropDownMenuYears();

  }

  getIdUser() async{
    sharedPreferences = await SharedPreferences.getInstance();
    idUser = sharedPreferences.getInt('idUser');
  }

  List<DropdownMenuItem<int>> getDropDownMenuMonths() {
    List<DropdownMenuItem<int>> mons = new List();
    for (int mon in _months) {
      mons.add(new DropdownMenuItem(
          value: mon,
          child: new Text(
            "$mon",
          )));
    }
    return mons;
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

  void changedDropDownMon(int selectedMon) {
    setState(() {
      _currentMon = selectedMon;
    });
  }
  void changedDropDownYear(int selectedYear) {
    setState(() {
      _currentYear = selectedYear;
    });
  }

  @override
  Widget build(BuildContext context) {
    IncomeBloc incomeBloc = BlocProvider.of<IncomeBloc>(context);
    widthDevice = MediaQuery.of(context).size.width;
    heightDevice = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 40.0,
          margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: (widthDevice - 20.0) / 8,
                child: Text(
                  'Month',
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
                        value: _currentMon,
                        items: _dropDownMenuMonths,
                        onChanged: changedDropDownMon,
                      ),
                    ),
                  )),
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
              StreamBuilder<List<Income>>(builder: (context, snapshot){
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
                          incomeBloc.findIncomeByMonth(_currentMon, _currentYear, idUser);
                          incomeBloc.getTotalMonth(_currentMon, _currentYear, idUser);
                        })
                );
              },)

            ],
          ),
        ),
        Container(
          height: heightDevice - 220.0,
          child: StreamBuilder<List<Income>>(
            stream: incomeBloc.outMonthIncome,
            builder: (context, snapshot){
              if(snapshot.hasData){
                return CustomScrollView(
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            var mMoney = snapshot.data[index].income;
                            var mDate = snapshot.data[index].dateShow;
                            var mContent = snapshot.data[index].content;
                            return Container(
                                margin: EdgeInsets.only(left: 15.0, right: 15.0),
                                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(mDate),
                                      flex: 2,
                                    ),
                                    Expanded(
                                      child: Text(mContent),
                                      flex: 3,
                                    ),
                                    Expanded(
                                      child: Text(
                                        fN.format(mMoney),
                                        textAlign: TextAlign.right,
                                      ),
                                      flex: 3,
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
                  child: Text('They have not data!'),
                );
              }
            },
          ),
        ),
        Container(
          height: 40.0,
          child: StreamBuilder(
              stream: incomeBloc.outMonth,
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
                            'Total of month: ',
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
