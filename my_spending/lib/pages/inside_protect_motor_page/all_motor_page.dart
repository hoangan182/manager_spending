import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:MySpending/blocs/protect_motor_bloc.dart';
import 'package:MySpending/models/Motor.dart';
import 'package:MySpending/pages/input_edit_pages/edit_motor_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllMotorPage extends StatefulWidget {
  @override
  _AllMotorPageState createState() => _AllMotorPageState();
}

class _AllMotorPageState extends State<AllMotorPage> {
  SharedPreferences sharedPreferences;
  int idUser;


  @override
  void initState() {
    super.initState();
    ProtectMotorBloc protectMotorBloc = BlocProvider.of<ProtectMotorBloc>(context);
    getMotorList(protectMotorBloc);
  }

  getMotorList(ProtectMotorBloc bloc) async{
    sharedPreferences = await SharedPreferences.getInstance();
    idUser = sharedPreferences.getInt('idUser');
    bloc.getAllMotor(idUser);
    bloc.getTotalMotor(idUser);
  }

  @override
  Widget build(BuildContext context) {
    final fN = new NumberFormat('#,###');
    final f = new DateFormat('dd/MM/yyyy');

    ProtectMotorBloc protectMotorBloc = BlocProvider.of<ProtectMotorBloc>(context);

    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 40.0),
          child: StreamBuilder<List<Motor>>(
              stream: protectMotorBloc.outMotorList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return CustomScrollView(
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            Motor motor = snapshot.data[index];
                            var mMoney = motor.money;
                            var mDateShow = motor.dateShow;
                            var mContent = motor.content;
                            var mDateNext;
                            if(motor.dateNext == null){
                              mDateNext = '';
                            }else{
                              mDateNext = motor.dateNext;
                            }
                            return GestureDetector(
                                child: Container(
                                  margin: EdgeInsets.only(left: 15.0, right: 15.0),
                                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(mContent),
                                        flex: 2,
                                      ),
                                      Expanded(
                                        child: Text(mDateShow),
                                        flex: 1,
                                      ),
                                      Expanded(
                                        child: Text(mDateNext,style: TextStyle(color: Colors.red),),
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
                                ),
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => EditMotorPage(motor: motor)));
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
              stream: protectMotorBloc.outMotorTotal,
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
