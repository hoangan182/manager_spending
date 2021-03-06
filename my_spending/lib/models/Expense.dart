import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

Expense expenseFromJson(dynamic str){
  final jsonData = json.decode(str);
  return Expense.fromMap(jsonData);
}

String expenseToJson(Expense expense){
  final dyn = expense.toMap();
  return json.encode(dyn);
}

@JsonSerializable(nullable: false)
class Expense{
  int id;
  String date;
  String dateCon;
  String content;
  double expense;
  int month;
  int year;
  int idUser;


  Expense({this.id, this.date, this.dateCon, this.content, this.expense, this.month, this.year, this.idUser});

  factory Expense.fromMap(Map<dynamic, dynamic> json) => new Expense(
      id: json['id'],
      date: json['date'],
      dateCon: json['dateCon'],
      content: json['content'],
      expense: double.parse(json['expense'] as String),
      month: int.parse(json['month'] as String),
      year: int.parse(json['year'] as String),
      idUser: int.parse(json['idUser'] as String)
  );


  Map<String, dynamic> toMap() => {
    'id': id,
    'date': date,
    'dateCon': dateCon,
    'content': content,
    'expense': expense,
    'month': month,
    'year': year,
    'idUser': idUser
  };

}