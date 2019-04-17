
import 'dart:convert';

User userFromJson(String str){
  final jsonData = json.decode(str);
  return User.fromMap(jsonData);
}

String userToJson(User user){
  final dyn = user.toMap();
  return json.encode(dyn);
}

class User{
  int id;
  String userName;
  String passWord;
  String phoneNumber;

  User({this.id, this.userName, this.passWord, this.phoneNumber});


  factory User.fromMap(Map<String, dynamic> json) => new User(
    id: json['id'],
    userName: json['userName'],
    passWord: json['passWord'],
    phoneNumber: json['phoneNumber']);

  Map<String, dynamic> toMap() => {
    'id': id,
    'userName': userName,
    'passWord': passWord,
    'phoneNumber': phoneNumber
  };
  
}