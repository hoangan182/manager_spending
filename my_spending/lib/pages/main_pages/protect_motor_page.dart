import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:MySpending/pages/inside_protect_motor_page/all_motor_page.dart';
import 'package:MySpending/pages/inside_protect_motor_page/year_motor_page.dart';

class ProtectMotorPage extends StatefulWidget {
  @override
  _ProtectMotorPageState createState() => _ProtectMotorPageState();
}

class _ProtectMotorPageState extends State<ProtectMotorPage> {
  PageController _pageController;
  int _selectedIndex = 0;
  bool visible = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(keepPage: true);

  }

  _buildCupertinoTab(IconData icData, String item) {
    return BottomNavigationBarItem(
        icon: Icon(icData),
        title: Text(
          item,
          style: TextStyle(fontSize: 10.0),
        ));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Protect your motor'),
        actions: <Widget>[
          Visibility(
            visible: visible,
            child: IconButton(
              icon: Icon(
                Icons.add_circle,
                color: Colors.white,
              ),
              iconSize: 35.0,
              onPressed: () {
                Navigator.pushNamed(context, '/input_motor_page');
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        items: [
          _buildCupertinoTab(Icons.done_all, 'All'),
          _buildCupertinoTab(Icons.calendar_today, 'Year')
        ],
        onTap: navigationTapped,
        currentIndex: _selectedIndex,
      ),
      body: PageView(
        onPageChanged: onPageChanged,
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          AllMotorPage(),
          YearMotorPage()
        ],
      ),
    );
  }

  void navigationTapped(int value) {
    _pageController.animateToPage(value,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
    if(value == 0){
      setState(() {
        visible = true;
      });
    }else{
      setState(() {
        visible = false;
      });
    }
  }

  void onPageChanged(int value) {
    setState(() {
      this._selectedIndex = value;

    });
  }
}
