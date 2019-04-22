import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Setting'),),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Text('Coming soon', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.blue),),
        ),
      ),
    );
  }
}
