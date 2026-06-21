import 'dart:developer';

import 'package:path/path.dart';
import 'package:simplepos/data/database/table_scheme.dart';
import 'package:sqflite/sqflite.dart';

class Dbmanager {
  static Database? _db;

  // ======Getter======
  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  // =========Inisialisasi Database=========
  static Future<Database> _init() async {
    final path = join(await getDatabasesPath(), "simplepos");
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // =========Membuat table struktur=========
  static Future<void> _onCreate(Database db, int version) async {
    log("Membuat struktur database...");
    await db.execute(TableScheme.createTbUsaha);
    await db.execute(TableScheme.createTbItem);
    await db.execute(TableScheme.createTbItemSat);
    await db.execute(TableScheme.createTbTranshd);
    await db.execute(TableScheme.createTbTransdt);
    await db.execute(TableScheme.createTbMutasiStok);
    await db.execute(TableScheme.createTbsaldo);
  }

  // =========Upgrade Database [jika ada]=========
  static Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      log("upgrading database...");
      // await db.execute(
      //   'ALTER TABLE ${TableScheme.tbItemSat} ADD COLUMN stok INTEGER',
      // );
    }
  }
}
