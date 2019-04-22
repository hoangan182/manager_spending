

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:MySpending/pages/inside_expense_page/all_expense_page.dart';
import 'package:MySpending/pages/inside_expense_page/month_expense_page.dart';
import 'package:MySpending/pages/inside_expense_page/year_expense_page.dart';
import 'package:MySpending/pages/inside_income_page/month_income_page.dart';
import 'package:MySpending/pages/inside_income_page/year_income_page.dart';

class ExpensePage extends StatefulWidget {
  @override
  _ExpensePageState createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage>{
  PageController _pageController;
  int _selectedIndex = 0;
  bool visible = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(keepPage: true);

  }


  @override
  void dispose() {
    super.dispose();
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
        title: Text('Expense'),
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
                Navigator.pushNamed(context, '/input_expense_page');
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        items: [
          _buildCupertinoTab(Icons.done_all, 'All'),
          _buildCupertinoTab(Icons.calendar_view_day, 'Month'),
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
          AllExpensePage(),
          MonthExpensePage(),
          YearExpensePage()
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