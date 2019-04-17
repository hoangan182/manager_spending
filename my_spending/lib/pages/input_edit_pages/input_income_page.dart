import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

import 'package:my_spending/blocs/income_bloc.dart';
import 'package:my_spending/models/AutoCompleteIncome.dart';
import 'package:my_spending/pickers/date_time_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';



class InputIncomePage extends StatefulWidget {

  @override
  _InputIncomePageState createState() => _InputIncomePageState();
}

class _InputIncomePageState extends State<InputIncomePage> {
  double widthDevice;

  double money;
  String content;

  AutoCompleteTextField searchTextField;

  GlobalKey<AutoCompleteTextFieldState<AutoCompleteIncome>> key = new GlobalKey();

  TextEditingController controller = new TextEditingController();

  DateTime _fromDate = DateTime.now();

  SharedPreferences sharedPreferences;
  int idUser;

  @override
  void initState() {
    super.initState();
    getIdUser();
  } //  List<AutoCompleteIncome> incomes = [
//    AutoCompleteIncome(income: 'Tiền lương', status: 'default'),
//    AutoCompleteIncome(income: 'Tiền thưởng 30/4', status: 'default'),
//    AutoCompleteIncome(income: 'Tiền thưởng 2/9', status: 'default'),
//    AutoCompleteIncome(income: 'Tiền thưởng tết dương', status: 'default'),
//    AutoCompleteIncome(income: 'Tiền thưởng tết âm', status: 'default'),
//  ];

  getIdUser() async{
    sharedPreferences = await SharedPreferences.getInstance();
    idUser = sharedPreferences.getInt('idUser');
  }


  @override
  Widget build(BuildContext context) {
    final IncomeBloc incomeBloc = BlocProvider.of<IncomeBloc>(context);

    widthDevice = MediaQuery.of(context).size.width;


    return Scaffold(
      appBar: AppBar(title: Text('Input Income'),),
      body: Container(
        margin: EdgeInsets.only(left: 15.0, right: 15.0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 20.0,),
            Text('Input income below',style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
            SizedBox(height: 15.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildTitle('Date', widthDevice, 50.0),
                Container(
                  width: (widthDevice-30)*2/3,
                  height: 50.0,
                  child: DateTimePicker(
                    selectedDate: _fromDate,
                    selectDate: (DateTime date){
                      setState(() {
                        _fromDate = date;
                      });
                    },
                  ),
                )
              ],
            ),
            SizedBox(height: 15.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildTitle('Income', widthDevice, 50.0),
                Container(
                  width: (widthDevice-30)*2/3,
                  height: 50.0,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Input income...',
                      contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 5.0)
                    ),
                    onChanged: (String value){
                      setState(() {
                        content = value;
                      });
                    },

                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildTitle('Money', widthDevice, 50.0),
                Container(
                  width: (widthDevice-30)*2/3,
                  height: 50.0,
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Input money...',
                        contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 5.0)
                    ),
                    onChanged: (String value){
                      setState(() {
                        money = double.parse(value);
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0,),
            submitButton(incomeBloc, context)
          ],
        ),
      )
      ,
    );
  }

  Widget _buildTitle(String title, double width, double mHeight){
    return Container(
      width: (width-30)/3,
      height: mHeight,
      child: Text(title, style: TextStyle(fontSize: 16.0),),
      alignment: AlignmentDirectional.bottomStart,
      padding: EdgeInsets.only(bottom: 10.0),
    );
  }

  Widget submitButton(IncomeBloc bloc, BuildContext context) {
    final f = new DateFormat('dd/MM/yyyy');
    final fC = new DateFormat('yyyyMMdd');
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
              'Save',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blue[600],
            onPressed: () {
              if(_fromDate != null && content != null && money != null){
                String dateShow = f.format(_fromDate);
                String dateConvert = fC.format(_fromDate);
                int month = _fromDate.month;
                int year = _fromDate.year;
                bloc.addIncome(dateShow, dateConvert, content, money, month, year, idUser, context);
              }
            },
          ),
        );
      },
    );
  }

//  Widget _buildAutoCompleteText(){
//    return searchTextField = AutoCompleteTextField<AutoCompleteIncome>(
//      style: TextStyle(color: Colors.black, fontSize: 16.0),
//      decoration: InputDecoration(
//          filled: true,
//          hintText: 'Input Income...',
//          fillColor: Colors.transparent,
//          contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 5.0)
//      ),
//      itemSubmitted: (item){
//        setState(() {
//          searchTextField.textField.controller.text = item.income;
//          content = item.income;
//
//        });
//      },
//      clearOnSubmit: false,
//      key: key,
//      suggestions: incomes,
//      itemBuilder: (context, item){
//        return Container(
//          margin: EdgeInsets.all(0),
//          padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 5.0),
//          child: Text(item.income, style: TextStyle(fontSize: 16.0),),
//
//        );
//      },
//      itemSorter: (a,b){
//        return a.income.compareTo(b.income);
//      },
//      itemFilter: (item, query){
//        return item.income.toLowerCase().startsWith(query.toLowerCase());
//      },
//    );
//  }


}