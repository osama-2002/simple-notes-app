import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NotesSqlDB {

  late Database _db;
  final String table = 'notes';

  Future<void> initialDB() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, "notesDB.db"); //dbPath/notesDB.db
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
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        userID INTEGER NOT NULL
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