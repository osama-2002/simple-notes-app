import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class NotesSqlDB {

  static const _databaseName = "notesDB.db";
  static const _databaseVersion = 1;

  static const table = 'notes';

  static const columnId = 'id'; 
  static const columnTitle = 'title';
  static const columnBody = 'body';
  static const columnUserId = 'userId';

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
        $columnTitle TEXT NOT NULL,
        $columnBody TEXT NOT NULL,
        $columnUserId INTEGER NOT NULL
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