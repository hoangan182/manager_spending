import 'package:flutter/material.dart';

class InputDropdown extends StatelessWidget {
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;


  InputDropdown({Key key, this.valueText, this.valueStyle, this.onPressed, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onPressed,
        child: InputDecorator(
          decoration: InputDecoration(
              hintText: 'Date...'
          ),
          baseStyle:  valueStyle,
          child: Container(
            margin: EdgeInsets.only(left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(valueText, style: valueStyle,),
                Icon(Icons.arrow_drop_down, color: Theme.of(context).brightness == Brightness.light ? Colors.grey.shade700 : Colors.white70,)
              ],
            ),
          )
          ,
        )
    );
  }
}