import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class DatabaseHelper {
  // Database Name
  static const databaseName = "AirQualityExplorer.db";

  // Database Version
  static const databaseVersion = 1;

  // Database Table Name
  static const databaseTableName = "saved_Location";

  // Table Column name
  static const columnId = "id";
  static const columnStartDate = "start_date";
  static const columnEndDate = "end_date";
  static const columnLocationNm = "location_name";
  static const columnLat = "location_lat";
  static const columnLong = "location_long";
  static const columnStationList = "station_model_class";
  static const columnPollutantTableNm = "station_model_class_data_list";
  static const columnStationId = "station_id";
  static const columnStationPollutantType = "station_pollutant_type";
  static const columnStationPollutantValue = "station_pollutant_value";

  late Database db;

  // this opens the database (and creates it if it doesn't exist)
  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, databaseName);

    db = await openDatabase(
      path,
      version: databaseVersion,
      onCreate: onCreate,
    );
  }

  // SQL code to create the database table
  Future onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $databaseTableName (
            $columnId INTEGER PRIMARY KEY,
            $columnStartDate INTEGER NOT NULL,
            $columnEndDate INTEGER NOT NULL,
            $columnLocationNm TEXT NOT NULL,
            $columnLat DOUBLE NOT NULL,
            $columnLong DOUBLE NOT NULL,
            $columnStationList TEXT NOT NULL,
            $columnPollutantTableNm TEXT NOT NULL,
            $columnStationId INTEGER,
            $columnStationPollutantType TEXT NOT NULL,
            $columnStationPollutantValue DOUBLE 
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    return await db.insert(databaseTableName, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await db.query(databaseTableName);
  }

  /* // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    final results =
        await db.rawQuery('SELECT COUNT(*) FROM $databaseTableName');
    return Sqflite.firstIntValue(results) ?? 0;
  } */

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    return await db.delete(
      databaseTableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row, int dbId) async {
    dbId = row[columnId];
    return await db.update(
      databaseTableName,
      row,
      where: '$columnId = ?',
      whereArgs: [dbId],
    );
  }
}
