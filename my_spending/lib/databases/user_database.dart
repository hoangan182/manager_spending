import 'dart:async';
import 'dart:io';
import 'package:my_spending/databases/database.dart';
import 'package:my_spending/models/User.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class UserDB {

  UserDB._();

  static final UserDB db = UserDB._();

  Future<Database> database = DatabaseDB.database;

//
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
//
//    Directory documentsDirectory = await getApplicationDocumentsDirectory();
//    String path = join(documentsDirectory.path, "ManagerSpending.db");
//
//    return await openDatabase(path, version: 1, onOpen: (db) {},
//        onCreate: (Database db, int version) async {
//          await db.execute("CREATE TABLE UserMember ("
//              "id INTEGER PRIMARY KEY,"
//              "userName TEXT,"
//              "passWord TEXT,"
//              "phoneNumber TEXT"
//              ")");
//        });
//  }

  //CRUD
  //Create
  newUser(User newUser) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM UserMember");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into UserMember (id,userName,passWord,phoneNumber)"
            " VALUES (?,?,?,?)",
        [id, newUser.userName, newUser.passWord, newUser.phoneNumber]);
    return raw;
  }

  //Read
  //Get user by id
  getUser(int id, int idUser) async {
    final db = await database;
    var res = await db.query("UserMember", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? User.fromMap(res.first) : Null;
  }

  //Get all user with condition
  getAllUser() async {
    final db = await database;
    var res = await db.query("UserMember");
    List<User> userList =
    res.isNotEmpty ? res.map((c) => User.fromMap(c)).toList() : [];
    return userList;
  }

  //Update
  //Update an existing user
//  updateUser(User user) async {
//    final db = await database;
//    var res = await db.update("UserMember", user.toMap(),
//        where: "id = ?", whereArgs: [user.id]);
//    return res;
//  }

  //Delete
  //Delete one user
//  deleteUser(int id) async {
//    final db = await database;
//    var res = await db.delete("UserMember", where: "id = ?", whereArgs: [id]);
//  }

  //Delete all user
//  deleteAll() async {
//    final db = await database;
//    db.rawDelete("Delete * from UserMember");
//  }

  //find exits username
  Future<bool> findUser(String user, String pass) async {
    //print(user+"/"+pass);
    bool exist = false;
    final db = await database;
    var res = await db.query("UserMember",
        where: '"userName" = ? and "passWord" = ?', whereArgs: [user, pass]);
    print(res);
    if (res.length > 0) {
      res.isNotEmpty ? exist = true : exist = false;
    }
    return exist;
  }

  //find exits user
  Future<bool> findExistUser(String user) async{
    bool exist = false;
    final db = await database;
    var res = await db.query("UserMember",
        where: "userName = ? ", whereArgs: [user]);
    print(res);
    if (res.length > 0) {
      res.isNotEmpty ? exist = true : exist = false;
    }
    return exist;
  }

  //find user
  Future<User> findUserLogin(String user, String pass) async{
    final db = await database;
    User mUser;
    var res = await db.query("UserMember",
        where: '"userName" = ? and "passWord" = ?',
        whereArgs: [user, pass]);
    if (res.length > 0) {
      mUser = User.fromMap(res.first);
    } else {
      mUser = null;
    }
    return mUser;
  }
  //find password forgot
  Future<User> findPassword(String user, String phone) async {
    final db = await database;
    User mUser;

    //Có thể sử dụng câu lệnh này
    //var res = await db.rawQuery('SELECT * FROM UserMember WHERE userName = ? AND phoneNumber = ?', [user, phone]);

    //Sử dụng query hỗ trợ của flutter
    var res = await db.query("UserMember",
        where: '"userName" = ? and "phoneNumber" = ?',
        whereArgs: [user, phone]);
    if (res.length > 0) {
      mUser = User.fromMap(res.first);
    } else {
      mUser = null;
    }
    return mUser;
  }
}