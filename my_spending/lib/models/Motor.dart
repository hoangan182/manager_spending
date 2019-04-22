import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

Motor motorFromJson(dynamic str){
  final jsonData = json.decode(str);
  return Motor.fromMap(jsonData);
}

String motorToJson(Motor motor){
  final dyn = motor.toMap();
  return json.encode(dyn);
}

@JsonSerializable(nullable: false)
class Motor{
  int id;
  int idUser;
  String dateShow;
  String dateCon;
  String dateNext;
  int year;
  String content;
  String kind;
  double money;


  Motor({this.id, this.idUser, this.dateShow, this.dateCon, this.dateNext, this.year, this.content, this.kind, this.money});

  factory Motor.fromMap(Map<dynamic, dynamic> json) => new Motor(
      id: json['id'],
      idUser: int.parse(json['idUser'] as String),
      dateShow: json['dateShow'],
      dateCon: json['dateCon'],
      dateNext: json['dateNext'],
      year: int.parse(json['year'] as String),
      content: json['content'],
      kind: json['kind'],
      money: double.parse(json['money'] as String),

  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'idUser': idUser,
    'dateShow': dateShow,
    'dateCon': dateCon,
    'dateNext': dateNext,
    'year': year,
    'content': content,
    'kind': kind,
    'money': money
  };
}