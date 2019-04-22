import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:MySpending/blocs/forgot_password_bloc.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String userForgot;
  String phoneForgot;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  double widthDevice, heightDevice;

  @override
  Widget build(BuildContext context) {
    widthDevice = MediaQuery.of(context).size.width;
    heightDevice = MediaQuery.of(context).size.height;
    final ForgotPasswordBloc bloc = BlocProvider.of<ForgotPasswordBloc>(context);
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Forgot Password'),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              height: heightDevice - 56.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/bg.jpg'), fit: BoxFit.fill)),
              child: Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: widthDevice / 3,
                    ),
                    _buildUser(),
                    SizedBox(
                      height: 15.0,
                    ),
                    _buildPhone(),
                    SizedBox(
                      height: 25.0,
                    ),
                    _submitForgot(bloc),
                    SizedBox(
                      height: 25.0,
                    ),
                    _getPassword(bloc),
                  ],
                ),
              ),
            )
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
      margin: EdgeInsets.only(left: 15.0, right: 15.0),
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.black12),
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
      ),
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
            userForgot = value;
          });
        },
      ),
    );
  }

  Widget _buildPhone() {
    return Container(
        margin: EdgeInsets.only(left: 15.0, right: 15.0),
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.black12),
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
        ),
        child: TextFormField(
          decoration: InputDecoration(
              labelText: 'Phone number',
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent))),
          validator: (String value) {
            if (value.isEmpty) {
              return 'Phone number is not empty!';
            } else if (value.length < 6) {
              return 'Phone Number must have 10 characters!';
            }
          },
          onSaved: (String value) {
            setState(() {
              phoneForgot = value;
            });
          },
        ));
  }

  Widget _submitForgot(ForgotPasswordBloc bloc) =>
      StreamBuilder<String>(builder: (context, snapshot) {
        return Container(
          height: 44.0,
          width: widthDevice,
          margin: EdgeInsets.only(left: 15.0, right: 15.0),
          child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.5)),
              child: Text(
                'Get Password',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue[600],
              onPressed: () {
                if (!_formkey.currentState.validate()) {
                  return;
                } else {
                  _formkey.currentState.save();
                  bloc.getPass(userForgot, phoneForgot);
                }
              }),
        );
      });

  Widget _getPassword(ForgotPasswordBloc bloc) {
    return StreamBuilder(
        stream: bloc.outPass,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              alignment: AlignmentDirectional.center,
              width: widthDevice,
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              margin: EdgeInsets.only(left: 15.0, right: 15.0),
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.black12),
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
              ),
              child: Text('${snapshot.data}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
            );
          } else {
            return Container();
          }
        });
  }
}