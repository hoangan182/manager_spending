import 'package:MySpending/databases/database.dart';
import 'package:MySpending/models/Motor.dart';
import 'package:sqflite/sqflite.dart';

class MotorDB{
  MotorDB._();

  static final MotorDB mtdb = MotorDB._();

  Future<Database> database = DatabaseDB.database;


  //CRUD
  //Create
  Future<int> newMotor(Motor mMotor) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Expense");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Motor (id, idUser, dateShow, dateCon, dateNext, year, content, kind, money) VALUES (?,?,?,?,?,?,?,?, ?)",
        [id, mMotor.idUser, mMotor.dateShow, mMotor.dateCon, mMotor.dateNext, mMotor.year, mMotor.content, mMotor.kind, mMotor.money]);
    return raw;
  }

  //Read
  //Get motor by id
  getMotor(int id) async {
    final db = await database;
    var res = await db.query("Motor", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Motor.fromMap(res.first) : null;
  }

  //get motor by date, content and money
  Future<Motor> getMotorByContent(String dateShow, String content, double money, int idUser) async{
    final db = await database;
    var res = await db.query("Motor", where: "dateShow = ? AND content = ? AND money = ? AND idUser = ?", whereArgs: [dateShow, content, money, idUser]);
    return res.isNotEmpty ? Motor.fromMap(res.first) : null;
  }

  //Get all motor with condition
  getAllMotor(int idUser) async {
    final db = await database;
    var res = await db.query("Motor", where: "idUser = ?", whereArgs: [idUser]);
    print(res);
    List<Motor> motorList = res.isNotEmpty ? res.map((c) => Motor.fromMap(c)).toList() : [];
    return motorList;
  }

  //Update
  //Update an existing motor
  Future<int> updateMotor(Motor motor) async {
    final db = await database;
    var res = await db.update("Motor", motor.toMap(), where: "id = ?", whereArgs: [motor.id]);
    return res;
  }

  //Delete
  //Delete one motor
  Future<int> deleteMotor(int id, int idUser) async {
    final db = await database;
    var res = await db.delete("Motor", where: "id = ? AND idUser = ?", whereArgs: [id, idUser]);
    return res;
  }

  //get sum motor
  Future<double> getTotal(int idUser) async{
    final db = await database;
    var res = await db.rawQuery("SELECT SUM(money) as Total FROM Motor WHERE idUser = ?", [idUser]);
    double total = res[0]['Total'];
    return total;
  }

  //get sum motor by year
  Future<double> getTotalByYear(int year) async{
    final db = await database;
    var res = await db.rawQuery("SELECT SUM(money) as Total FROM Motor WHERE year = ?", [year]);
    double sumYear = res[0]['Total'];
    return sumYear;
  }

  Future<List<Motor>>getMotorByYear(int year, int idUser) async{
    final db = await database;
    var res = await db.query("Motor", where: "year = ? and idUser = ?", whereArgs: [year, idUser]);
    List<Motor> motorYearList = res.isNotEmpty ? res.map((c) => Motor.fromMap(c)).toList() : [];
    return motorYearList;
  }
  
}