import 'dart:io';

import 'package:my_spending/databases/database.dart';
import 'package:my_spending/models/Income.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class IncomeDB {

  IncomeDB._();

  static final IncomeDB icdb = IncomeDB._();

  Future<Database> database = DatabaseDB.database;

//  Database _database;
//
//  Future<Database> get database async{
//    _database = await database;
//    return _database;
//  }

//  Future<Database> get database async {
//    if (_database != null) return _database;
//    _database = await initDB();
//    return _database;
//  }
//
//  initDB() async {
//    var databasesPath = await getDatabasesPath();
//    String path = join(databasesPath, "IncomeDB.db");
//
//    return await openDatabase(path, version: 1, onOpen: (icdb) {},
//        onCreate: (Database icdb, int version) async {
//            await icdb.execute("CREATE TABLE Income (id INTEGER PRIMARY KEY, dateShow TEXT, dateConvert TEXT, content TEXT, income TEXT, month TEXT, year TEXT,idUser TEXT)");
//    });
//  }

  //CRUD
  //Create
  Future<int> newIncome(Income newIncome) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Income");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Income (id,dateShow,dateConvert,content,income,month,year,idUser)"
        " VALUES (?,?,?,?,?,?,?,?)",
        [
          id,
          newIncome.dateShow,
          newIncome.dateConvert,
          newIncome.content,
          newIncome.income,
          newIncome.month,
          newIncome.year,
          newIncome.idUser,
        ]);
    return raw;
  }

  //Read
  //Get income by id
//  getIncome(int id) async {
//    final db = await database;
//    var res = await db.query("Income", where: "id = ?", whereArgs: [id]);
//    return res.isNotEmpty ? Income.fromMap(res.first) : null;
//  }

  //get income by date, content and money
  Future<Income> getIncomeByContent(
      int idUser, String dateShow, String content, double money) async {
    final db = await database;
    var res = await db.query("Income",
        where: "idUser = ? AND dateShow = ? AND content = ? AND income = ?",
        whereArgs: [idUser, dateShow, content, money]);
    return res.isNotEmpty ? Income.fromMap(res.first) : null;
  }

  //Get all income with condition
  getAllIncome(int idUser) async {
    final db = await database;
    var res = await db.query("Income", where: "idUser = ?", whereArgs: [idUser]);
    List<Income> incomeList = res.isNotEmpty ? res.map((c) => Income.fromMap(c)).toList() : [];
    print('database income: '+incomeList.length.toString());
    return incomeList;
  }

  //Update
  //Update an existing income
  Future<int> updateIncome(Income income) async {
    final db = await database;
    var res = await db.update("Income", income.toMap(),
        where: "id = ? AND idUser = ?", whereArgs: [income.id, income.idUser]);
    print(res);
    return res;
  }

  //Delete
  //Delete one income
  Future<int> deleteIncome(int id, int idUser) async {
    final db = await database;
    var res = await db.delete("Income",
        where: "id = ? AND idUser = ?", whereArgs: [id, idUser]);
    return res;
  }

  //get sum income
  Future<double> getTotal(int idUser) async {
    final db = await database;
    print(db);
    var res = await db.rawQuery("SELECT SUM(income) as Total FROM Income WHERE idUser = ?", [idUser]);
    double total = res[0]['Total'];
    print('database income has: ' + total.toString());
    return total;
  }

  //get sum income by month
  Future<double> getTotalByMonth(int month, int year, int idUser) async {
    final db = await database;
    var res = await db.rawQuery(
        "SELECT SUM(income) as Total FROM Income WHERE month = ? AND year = ? AND idUser = ?",
        [month, year, idUser]);
    double sumMonth = res[0]['Total'];
    return sumMonth;
  }

  Future<double> getTotalByYear(int year, int idUser) async {
    final db = await database;
    var res = await db.rawQuery(
        "SELECT SUM(income) as Total FROM Income WHERE year = ? AND idUser = ?",
        [year, idUser]);
    double sumYear = res[0]['Total'];
    return sumYear;
  }

  Future<List<Income>> getIncomeByMonth(int month, int year, int idUser) async {
    final db = await database;
    var res = await db.query("Income",
        where: '"month" = ? and "year" = ? and "idUser" = ?',
        whereArgs: [month, year, idUser]);
    List<Income> incomeMonthList =
        res.isNotEmpty ? res.map((c) => Income.fromMap(c)).toList() : [];
    return incomeMonthList;
  }

  getIncomeByYear(int year, int idUser) async {
    final db = await database;
    var res = await db.query("Income",
        where: "year = ? AND idUser = ?", whereArgs: [year, idUser]);
    List<Income> incomeYearList =
        res.isNotEmpty ? res.map((c) => Income.fromMap(c)).toList() : [];
    return incomeYearList;
  }

  Future<int> getIdByIncome(
      String dateShow, String content, double income, int idUser) async {
    final db = await database;
    var res = await db.rawQuery(
        "SELECT id as ID FROM Income WHERE dateShow = ? AND content = ? AND income = ? AND idUser = ?",
        [dateShow, content, income, idUser]);
    int id = res[0]['ID'];
    print('database có: ' + id.toString());
    return id;
  }
}
