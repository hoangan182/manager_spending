
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_spending/blocs/expense_bloc.dart';
import 'package:my_spending/models/Expense.dart';
import 'package:shared_preferences/shared_preferences.dart';

class YearExpensePage extends StatefulWidget {
  @override
  _YearExpensePageState createState() => _YearExpensePageState();
}

class _YearExpensePageState extends State<YearExpensePage> {
  double widthDevice, heightDevice;
  List<int> _years = [];

  int _currentYear;
  List<DropdownMenuItem<int>> _dropDownMenuYears;

  final fN = new NumberFormat('#,###');
  final f = new DateFormat('dd/MM/yyyy');


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
    final ExpenseBloc expenseBloc = BlocProvider.of<ExpenseBloc>(context);
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
                              expenseBloc.getYearExpense(_currentYear, idUser);
                              expenseBloc.getYearTotalExpense(_currentYear, idUser);
                            })
                    );
                  })
            ],
          ),
        ),
        Container(
          height: heightDevice - 220.0,
          child: StreamBuilder<List<Expense>>(
            stream: expenseBloc.outExpenseListYear,
            builder: (context, snapshot){
              if(snapshot.hasData){
                return CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          var mMoney = snapshot.data[index].expense;
                          var mDate = snapshot.data[index].date;
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
                stream: expenseBloc.outExpenseTotal,
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
