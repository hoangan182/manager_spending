import 'package:flutter/material.dart';

class ChoosePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChoosePageState();
  }
}

class _ChoosePageState extends State<ChoosePage> {
  double widthDevice, heightDevice;

  @override
  Widget build(BuildContext context) {
    widthDevice = MediaQuery.of(context).size.width;
    heightDevice = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(
                    height: widthDevice * 2 / 5,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          child: Column(
                            children: <Widget>[
                              CircleAvatar(
                                radius: widthDevice * 1.1 / 6.5,
                                child: Image(
                                  image: AssetImage('assets/ic_income.png'),
                                  fit: BoxFit.fill,
                                ),
                                backgroundColor: Colors.blue[500],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                'Income',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/income_page');
                          },
                        ),
                        GestureDetector(
                          child: Column(
                            children: <Widget>[
                              CircleAvatar(
                                radius: widthDevice * 1.1 / 6.5,
                                child: Image(
                                  image: AssetImage('assets/ic_expense.png'),
                                  fit: BoxFit.fill,
                                ),
                                backgroundColor: Colors.blue[500],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text('Expense',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/expense_page');
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          child: Column(
                            children: <Widget>[
                              CircleAvatar(
                                radius: widthDevice * 1.1 / 6.5,
                                child: Image(
                                  image:
                                      AssetImage('assets/ic_protect_motor.png'),
                                  fit: BoxFit.fill,
                                ),
                                backgroundColor: Colors.blue[500],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text('Protect Motor',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/protect_motor_page');
                          },
                        ),
                        GestureDetector(
                          child: Column(
                            children: <Widget>[
                              CircleAvatar(
                                radius: widthDevice * 1.1 / 6.5,
                                child: Image(
                                  image: AssetImage('assets/ic_setting.png'),
                                  fit: BoxFit.fill,
                                ),
                                backgroundColor: Colors.blue[500],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text('Setting',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/setting_page');
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Container(
                alignment: AlignmentDirectional.center,
                height: 50.0,
                child: Text(
                  'Manager Spending',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Happy',
                        style: TextStyle(color: Colors.blue, fontSize: 15.0),
                      ),
                      SizedBox(width: 5.0,),
                      CircleAvatar(
                        radius: 25.0,
                        child: Image(
                          image:
                          AssetImage('assets/ic_family.png'),
                          fit: BoxFit.fill,
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                      SizedBox(width: 5.0,),
                      Text(
                        'Family',
                        style: TextStyle(color: Colors.blue, fontSize: 15.0),
                      )
                    ],
                  )
                  ,
                )
                )
            ],
          ),
        ),
      ),
    );
  }
}
