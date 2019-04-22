import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:MySpending/pickers/input_dropdown.dart';

class DateTimePicker extends StatelessWidget {
  final DateTime selectedDate;
  //final TimeOfDay selectedTime;
  final ValueChanged<DateTime> selectDate;
  //final ValueChanged<TimeOfDay> selectTime;


//  DateTimePicker({Key key,this.selectedDate, this.selectedTime, this.selectDate,
//      this.selectTime}) : super(key: key);

  DateTimePicker({Key key,this.selectedDate, this.selectDate,}) : super(key: key);

  Future<void> _selectDate(BuildContext context) async{
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if(picked != null && picked != selectedDate) selectDate(picked);
  }

//  Future<void> _selectTime(BuildContext context) async{
//    final TimeOfDay picked = await showTimePicker(context: context, initialTime: selectedTime);
//    if(picked != null && picked != selectedTime) selectTime(picked);
//  }
  @override
  Widget build(BuildContext context) {
    final TextStyle style = TextStyle(fontSize: 16.0, color: Colors.black);
    return Container(
      child: InputDropdown(
        valueText: DateFormat.yMMMd().format(selectedDate),
        valueStyle:  style,
        onPressed: (){
          _selectDate(context);
        },
      ),
    );
  }

}
