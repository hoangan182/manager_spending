

import 'package:MySpending/databases/database.dart';
import 'package:MySpending/models/Expense.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseDB{
  ExpenseDB._();

  static final ExpenseDB exdb = ExpenseDB._();

  Future<Database> database = DatabaseDB.database;


  //CRUD
  //Create
  Future<int> newExpense(Expense mExpense) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Expense");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Expense (id, date, dateCon, content, expense, month, year, idUser) VALUES (?,?,?,?,?,?,?,?)",
        [id, mExpense.date, mExpense.dateCon, mExpense.content, mExpense.expense, mExpense.month, mExpense.year, mExpense.idUser]);
    return raw;
  }

  //Read
  //Get expense by id
  getExpense(int id) async {
    final db = await database;
    var res = await db.query("Expense", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Expense.fromMap(res.first) : null;
  }

  //get expense by date, content and money
  Future<Expense> getExpenseByContent(String dateShow, String content, double money, int idUser) async{
    final db = await database;
    var res = await db.query("Expense", where: "dateShow = ? AND content = ? AND expense = ? AND idUseer = ?", whereArgs: [dateShow, content, money, idUser]);
    return res.isNotEmpty ? Expense.fromMap(res.first) : null;
  }

  //Get all expense with condition
  getAllExpense(int idUser) async {
    final db = await database;
    var res = await db.query("Expense", where: "idUser = ?", whereArgs: [idUser]);
    print(idUser.toString());
    print(res);
    //List<Expense> expenseList = res.isNotEmpty ? res.map((c) => Expense.fromMap(c)).toList() : [];
    List<Expense> expenseList = res.isNotEmpty ? res.map((c) => Expense.fromMap(c)).toList() : [];
    print('database: '+expenseList.length.toString());
    return expenseList;
  }

  //Update
  //Update an existing expense
  Future<int> updateExpense(Expense expense) async {
    final db = await database;
    var res = await db.update("Expense", expense.toMap(), where: "id = ?", whereArgs: [expense.id]);
    print(res);
    return res;
  }

  //Delete
  //Delete one expense
  Future<int> deleteExpense(int id, int idUser) async {
    final db = await database;
    var res = await db.delete("Expense", where: "id = ? AND idUser = ?", whereArgs: [id, idUser]);
    return res;
  }

  //get sum expense
  Future<double> getTotal(int idUser) async{
    final db = await database;
    var res = await db.rawQuery("SELECT SUM(expense) as Total FROM Expense WHERE idUser = ?", [idUser]);
    double total = res[0]['Total'];
    print('database expense has: ' + total.toString());
    return total;
  }

  //get sum expense by month
  Future<double> getTotalByMonth(int month, int year, int idUser) async{
    final db = await database;
    var res = await db.rawQuery("SELECT SUM(expense) as Total FROM Expense WHERE month = ? AND year = ? AND idUser = ?", [month, year, idUser]);
    double sumMonth = res[0]['Total'];
    return sumMonth;

  }

  Future<double> getTotalByYear(int year) async{
    final db = await database;
    var res = await db.rawQuery("SELECT SUM(expense) as Total FROM Expense WHERE year = ?", [year]);
    double sumYear = res[0]['Total'];
    return sumYear;
  }

  Future<List<Expense>>getExpenseByMonth(int month, int year, int idUser) async{
    final db = await database;
    var res = await db.query("Expense", where: '"month" = ? and "year" = ? and "idUser" = ?', whereArgs: [month, year, idUser]);
    List<Expense> expenseMonthList = res.isNotEmpty ? res.map((c) => Expense.fromMap(c)).toList() : [];
    return expenseMonthList;
  }

  Future<List<Expense>>getExpenseByYear(int year, int idUser) async{
    final db = await database;
    var res = await db.query("Expense", where: "year = ? and idUser = ?", whereArgs: [year, idUser]);
    List<Expense> expenseYearList = res.isNotEmpty ? res.map((c) => Expense.fromMap(c)).toList() : [];
    return expenseYearList;
  }

  Future<int> getIdByExpense(String dateShow, String content, double expense) async{
    final db = await database;
    var res = await db.rawQuery("SELECT id as ID FROM Expense WHERE dateShow = ? AND content = ? AND expense = ?", [dateShow, content, expense]);
    int id = res[0]['ID'];
    print('database có: '+id.toString());
    return id;
  }


}