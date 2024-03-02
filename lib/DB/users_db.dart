import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class UsersSqlDB {

  static const _databaseName = "usersDB.db";
  static const _databaseVersion = 1;

  static const table = 'users';

  static const columnId = 'id';
  static const columnName = 'name';
  static const columnEmail = 'email';
  static const columnPassword = 'password';
  static const columnBio = 'bio';

  late Database _db;

  Future<void> initialDB() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName); //dbPath/notesDB.db
    _db = await openDatabase(
      path, 
      version: _databaseVersion,
      onCreate: _onCreate
    );
  }
  Future _onCreate(Database db, int version) async {
    await db.execute('DROP TABLE If EXISTS $table');
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnEmail TEXT NOT NULL,
        $columnPassword TEXT NOT NULL,
        $columnBio TEXT NOT NULL
      );
    ''');
  }
  Future<List<Map<String, dynamic>>> readData() async {
    return await _db.query(table);
  }
  Future<int> insertData(Map<String, dynamic> row) async {
    return await _db.insert(
      table, 
      row
    );
  }
  Future<int> updateData(Map<String, dynamic> row) async {
    return await _db.update(
      table, 
      row,
      where: '$columnId = ?', 
      whereArgs: [row[columnId]],
    );
  }
  Future<int> deleteData(int id) async {
    return await _db.delete(
      table, 
      where: 'id = ?', 
      whereArgs: [id]);
  }
}