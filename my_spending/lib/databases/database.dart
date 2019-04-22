
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseDB{

  DatabaseDB._();

  static final DatabaseDB db = DatabaseDB._();

  static Database _database;

  static Future<Database> get database async{
    if(_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  static initDB()async{
        var databasesPath = await getDatabasesPath();
        String path = join(databasesPath, "ManagerSpending.db");

        return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE UserMember (id INTEGER PRIMARY KEY, userName TEXT, passWord TEXT, phoneNumber TEXT)");
          await db.execute("CREATE TABLE Income (id INTEGER PRIMARY KEY, dateShow TEXT, dateConvert TEXT, content TEXT, income TEXT, month TEXT, year TEXT,idUser TEXT)");
          await db.execute("CREATE TABLE Expense (id INTEGER PRIMARY KEY, date TEXT, dateCon TEXT, content TEXT, expense TEXT, month TEXT, year TEXT,idUser TEXT)");
          await db.execute("CREATE TABLE Motor (id INTEGER PRIMARY KEY, idUser TEXT, dateShow TEXT, dateCon TEXT, dateNext TEXT, year TEXT, content TEXT, kind TEXT, money TEXT)");
        });
  }


}