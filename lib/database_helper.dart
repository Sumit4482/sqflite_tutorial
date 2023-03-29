import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;

  static const table = "my_table";
  static const columnID = "_id";
  static const columnName = "_name";
  static const columnAge = "age";

  late Database _db;

  //this opens the database and create if it is doesn't exist.

  Future<void> init() async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, _databaseName);
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $table(
      $columnID INTEGER PRIMARY KEY,
      $columnName TEXT NOT NULL,
      $columnAge INTERGER NOT NULL
    )
    ''');
  }

  //HELPER METHOD

  //Inserts a row in the database where each key in the Map is a column name
  //ans the value is the column value.The return value is the id of the
  //inserted row.

  Future<int> insert(Map<String, dynamic> row) async {
    return await _db.insert(table, row);
  }

  //All of the rows are returned as a list of maps,where each map is
  //a key-value list oof columns.

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await _db.query(table);
  }

  // All of the methods (INSERT,QUERY,UPDATE,DELETE) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    final results = await _db.rawQuery('SELECT COUNT(*) FROM $table');
    return Sqflite.firstIntValue(results) ?? 0;
  }

  //we are asumming here that the id column in the map set.The other
  //column values will be used to update the row.

  Future<int> update(Map<String, dynamic> row) async {
    int id = row[columnID];
    return await _db.update(
      table,
      row,
      where: '$columnID  = ?',
      whereArgs: [id],
    );
  }

  //Deletes the row specified by the id.The number of affected rows is returned.
  //This should be 1 as the row exists.
  Future<int> delete(int id) async {
    return await _db.delete(table, where: '$columnID=?', whereArgs: [id]);
  }
}
