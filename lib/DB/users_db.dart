import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UsersSqlDB {

  late Database _db;
  final String table = 'users';

  Future<void> initialDB() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, "usersDB.db"); //dbPath/notesDB.db
    _db = await openDatabase(
      path, 
      version: 1,
      onCreate: _onCreate
    );
  }
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        password TEXT NOT NULL,
        bio TEXT NOT NULL
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
  Future<int> deleteData(int id) async {
    return await _db.delete(
      table, 
      where: 'id = ?', 
      whereArgs: [id]);
  }
  Future<int> updateData(int id, Map<String, dynamic> row) async {
    return await _db.update(
      table, 
      row,
      where: 'id = ?', 
      whereArgs: [row['id']],
    );
  }
}