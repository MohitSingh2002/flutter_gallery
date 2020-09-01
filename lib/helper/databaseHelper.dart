import 'dart:io' as io;
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_gallery/helper/photos.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseHelper {

  static Database _database;
  static const String ID = "id";
  static const String NAME = "photoname";
  static const String TABLE = "PhotosTable";
  static const String DB_NAME = "photos.db";

  Future<Database> get db async {
    if(null != _database) {
      return _database;
    }
    _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationSupportDirectory();
    String path = join(documentDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $TABLE ($ID INTEGER, $NAME TEXT)");
  }

  Future<Photos> save(Photos photos) async {
    var dbClient = await db;
    photos.id = await dbClient.insert(TABLE, photos.toMap());
    return photos;
  }

  Future<List<Photos>> getPhotos() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, NAME]);
    List<Photos> photos = [];
    if(maps.length > 0) {
      for(int i=0;i<maps.length;i++) {
        photos.add(Photos.fromMap(maps[i]));
      }
    }
    return photos;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

}
