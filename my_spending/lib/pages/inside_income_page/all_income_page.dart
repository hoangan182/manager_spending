import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:MySpending/pages/input_edit_pages/edit_income_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:MySpending/blocs/income_bloc.dart';
import 'package:MySpending/models/Income.dart';


class AllIncomePage extends StatefulWidget {
  @override
  _AllIncomePageState createState() => _AllIncomePageState();
}

class _AllIncomePageState extends State<AllIncomePage> {
  SharedPreferences sharedPreferences;
  int idUser;


  @override
  void initState() {
    super.initState();
    IncomeBloc incomeBLoc = BlocProvider.of<IncomeBloc>(context);
    getIncomeList(incomeBLoc);
  }

  getIncomeList(IncomeBloc bloc) async{
    sharedPreferences = await SharedPreferences.getInstance();
    idUser = sharedPreferences.getInt('idUser');
    bloc.getAllIncome(idUser);
    bloc.getTotalAll(idUser);
  }

  @override
  Widget build(BuildContext context) {
    final fN = new NumberFormat('#,###');
    final f = new DateFormat('dd/MM/yyyy');

    IncomeBloc incomeBLoc = BlocProvider.of<IncomeBloc>(context);

    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 40.0),
          child: StreamBuilder<List<Income>>(
              stream: incomeBLoc.outIncome,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return CustomScrollView(
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            Income income = snapshot.data[index];
                            var mMoney = income.income;
                            var mDate = income.dateShow;
                            var mContent = income.content;
                            return GestureDetector(
                              child: Container(
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
                              ),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => EditIncomePage(income: income)));
                              }
                            );
                          },
                          childCount: snapshot.data.length,
                        ),
                      )
                    ],
                  );
                } else {
                  return Center(
                    child: Text("There are no data"),
                  );
                }
              }),
        ),
        Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: StreamBuilder(
              stream: incomeBLoc.outTotal,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    color: Colors.white,
                    height: 40.0,
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Total: ',
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
                }
                else {
                  return Container();
                }
              }),
        )
      ],
    );
  }

}
