

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_spending/blocs/register_bloc.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  double widthDevice;
  double heightDevice;
  String userReg, phoneReg, passReg, rePassReg;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final RegisterBloc bloc = BlocProvider.of<RegisterBloc>(context);
    widthDevice = MediaQuery.of(context).size.width;
    heightDevice = MediaQuery.of(context).size.height;
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Register'),
        ),
        body: ListView(

          scrollDirection: Axis.vertical,
          children: <Widget>[
            Form(
                key: _formKey,
                child: Container(
                  height: heightDevice - 56.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/bg_2usd.jpg'), fit: BoxFit.fill),
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: widthDevice / 6,
                      ),
                      _buildUser(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildPhone(bloc),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildPass(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildRePass(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _submitReg(bloc),
                      SizedBox(height: 20.0),
                      GestureDetector(
                        child: Text(
                          'If you have an account. Login!',
                          style: TextStyle(
                              color: Colors.blue[600],
                              fontSize: 14.0,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/');
                        },
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
      },
    );
  }

  Widget _buildUser() {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      margin: EdgeInsets.only(left: 15.0, right: 15.0),
      child: TextFormField(
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
            userReg = value;
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

  Widget _buildPhone(RegisterBloc bloc) {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      margin: EdgeInsets.only(left: 15.0, right: 15.0),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'Phone Number',
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent))),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Phone is not empty';
          } else if (value.length != 10) {
            return 'Phone Number must have 10 characters!';
          }
        },
        onSaved: (String value) {
          setState(() {
            phoneReg = value;
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

  Widget _buildPass() {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.black12),
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
      ),
      margin: EdgeInsets.only(left: 15.0, right: 15.0),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'Password',
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
            passReg = value;
          });
        },
      ),
    );
  }

  Widget _buildRePass() {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      margin: EdgeInsets.only(left: 15.0, right: 15.0),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'Re-enter Password',
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
            rePassReg = value;
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

  Widget _submitReg(RegisterBloc bloc) =>
      StreamBuilder<bool>(builder: (context, snapshot) {
        return Container(
          height: 44.0,
          width: widthDevice,
          margin: EdgeInsets.only(left: 15.0, right: 15.0),
          child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.5)),
              child: Text(
                'Register',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue[600],
              onPressed: () {
                if (!_formKey.currentState.validate()) {
                  return;
                } else {
                  _formKey.currentState.save();
                  bloc.register(context, userReg, phoneReg, passReg, rePassReg);
                }
              }),
        );
      });
}
