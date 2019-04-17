

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

Income incomeFromJson(dynamic str){
  final jsonData = json.decode(str);
  return Income.fromMap(jsonData);
}

String incomeToJson(Income income){
  final dyn = income.toMap();
  return json.encode(dyn);
}

@JsonSerializable(nullable: false)
class Income{
  int id;
  String dateShow;
  String dateConvert;
  String content;
  double income;
  int month;
  int year;
  int idUser;


  Income({this.id, this.dateShow, this.dateConvert, this.content, this.income,
      this.month, this.year, this.idUser});

  factory Income.fromMap(Map<dynamic, dynamic> json) => new Income(
      id: json['id'],
      dateShow: json['dateShow'],
      dateConvert: json['dateConvert'],
      content: json['content'],
      income: double.parse(json['income'] as String),
      month: int.parse(json['month'] as String),
      year: int.parse(json['year'] as String),
      idUser: int.parse(json['idUser'] as String)
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'dateShow': dateShow,
    'dateConvert': dateConvert,
    'content': content,
    'income': income,
    'month': month,
    'year': year,
    'idUser': idUser
  };

}