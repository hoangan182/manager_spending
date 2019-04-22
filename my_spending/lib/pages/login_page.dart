import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MySpending/databases/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:MySpending/blocs/login_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double widthDevice;
  double heightDevice;
  bool _valueCheck = false;
  String userName;
  String passWord;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  SharedPreferences sharedPreferences;
  TextEditingController userNameController = new TextEditingController();
  TextEditingController passWordController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    DatabaseDB.initDB();
    getAccount();
  }

  void _onChangeCheck(bool value) {
    setState(() {
      _valueCheck = value;
    });
  }

  getAccount() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _valueCheck = sharedPreferences.getBool("check");
      if (_valueCheck != null) {
        if (_valueCheck) {
          userNameController.text = sharedPreferences.getString("username");
          passWordController.text = sharedPreferences.getString("password");
        } else {
          userNameController.clear();
          passWordController.clear();
          sharedPreferences.clear();
        }
      } else {
        _valueCheck = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final LoginBloc bloc = BlocProvider.of<LoginBloc>(context);
    widthDevice = MediaQuery.of(context).size.width;
    heightDevice = MediaQuery.of(context).size.height;
    return GestureDetector(
      child: Scaffold(
        body: SafeArea(
            child: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Form(
                    key: _formkey,
                    child: Container(
                      height: heightDevice - 30.0,
                      alignment: AlignmentDirectional.center,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/bg_main.jpg'),
                            fit: BoxFit.fill),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          userField(bloc, context),
                          SizedBox(
                            height: 10.0,
                          ),
                          passwordField(bloc, context),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                _buildCheckRemember(),
                                _buildForgotPassword()
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          submitButton(bloc, context),
                          SizedBox(height: 20.0),
                          _buildTextNavigation()
                        ],
                      ),
                    )),
              ],
            ),
            _buildTitle('Author by Hoang An', 0.0, 5.0,
                AlignmentDirectional.bottomCenter, 12.0),
            _buildTitle('Manager Spending', 10.0, 0.0,
                AlignmentDirectional.topCenter, 14.0),
          ],
        )),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
    );
  }

  Widget _buildTitle(String text, double top, double bottom,
      AlignmentDirectional alignment, double size) {
    return Align(
        child: Container(
      margin: EdgeInsets.only(top: top, bottom: bottom),
      child: Text(
        text,
        style: TextStyle(color: Colors.blue[700], fontSize: size),
      ),
      alignment: alignment,
    ));
  }

  Widget _buildCheckRemember() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Checkbox(
          value: _valueCheck,
          onChanged: _onChangeCheck,
        ),
        Text(
          'Remember password',
          style: TextStyle(color: Colors.lightBlue[800], fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget _buildForgotPassword() {
    return GestureDetector(
      child: Text(
        'Forgot Password',
        style: TextStyle(
            color: Colors.lightBlue[800],
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline),
      ),
      onTap: () {
        Navigator.pushNamed(context, '/forgot_page');
      },
    );
  }

  Widget _buildTextNavigation() {
    return GestureDetector(
      child: Container(
        height: 50.0,
        child: Text(
          'Have not any user? Register!',
          style: TextStyle(
              color: Colors.lightBlue[800],
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold),
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, '/register');
      },
    );
  }

  Widget userField(LoginBloc bloc, BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      margin: EdgeInsets.only(left: 15.0, right: 15.0),
      child: TextFormField(
        controller: userNameController,
        decoration: InputDecoration(
            labelText: 'User name',
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent))),
        validator: (String value) {
          if (value.isEmpty) {
            return 'User is not empty!';
          } else if (value.length < 6) {
            return 'Enter must be at least 6 characters';
          }
        },
        onSaved: (String value) {
          setState(() {
            userName = value;
          });
        },
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.black12),
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
      ),
    );
  }

  Widget passwordField(LoginBloc bloc, BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.black12),
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
      ),
      margin: EdgeInsets.only(left: 15.0, right: 15.0),
      child: TextFormField(
          controller: passWordController,
          obscureText: true,
          decoration: InputDecoration(
              labelText: 'Pass word',
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent))),
          validator: (String value) {
            if (value.isEmpty) {
              return 'Password is not empty';
            } else if (value.length < 8) {
              return 'Enter must be at least 8 characters';
            }
          },
          onSaved: (String value) {
            setState(() {
              passWord = value;
            });
          }),
    );
  }

  Widget submitButton(LoginBloc bloc, BuildContext context) {
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
              'Login',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blue[700],
            onPressed: () {
              if (!_formkey.currentState.validate()) {
                return;
              } else {
                _formkey.currentState.save();
                bloc.login(context, userName, passWord, _valueCheck);
              }
            },
          ),
        );
      },
    );
  }
}
