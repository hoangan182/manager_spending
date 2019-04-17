
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_spending/blocs/expense_bloc.dart';
import 'package:my_spending/models/Expense.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllExpensePage extends StatefulWidget {
  @override
  _AllExpensePageState createState() => _AllExpensePageState();
}

class _AllExpensePageState extends State<AllExpensePage> {

  SharedPreferences sharedPreferences;
  int idUser;


  @override
  void initState() {
    super.initState();
    print('bbbbbb');
    ExpenseBloc expenseBloc = BlocProvider.of<ExpenseBloc>(context);
    getExpenseList(expenseBloc);
  }

  getExpenseList(ExpenseBloc bloc) async{
    sharedPreferences = await SharedPreferences.getInstance();
    idUser = sharedPreferences.getInt('idUser');
    print('cccccc');
    bloc.getAllExpense(idUser);
    bloc.getTotalExpense(idUser);
  }

  @override
  Widget build(BuildContext context) {
    final fN = new NumberFormat('#,###');
    final f = new DateFormat('dd/MM/yyyy');

    ExpenseBloc expenseBloc = BlocProvider.of<ExpenseBloc>(context);

    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 40.0),
          child: StreamBuilder<List<Expense>>(
              stream: expenseBloc.outExpenseList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print('aaaa' + snapshot.data.length.toString());
                  return CustomScrollView(
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            var mMoney = snapshot.data[index].expense;
                            var mDate = snapshot.data[index].date;
                            var mContent = snapshot.data[index].content;
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
                                  expenseBloc.findExpenseByContent(mDate, mContent, mMoney, idUser, context);
                                  print(idUser.toString());
                                  print('vừa click vào: '+mContent);
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
                    child: Text("Chưa có dữ liệu"),
                  );
                }
              }),
        ),
        Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: StreamBuilder(
              stream: expenseBloc.outExpenseTotal,
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
