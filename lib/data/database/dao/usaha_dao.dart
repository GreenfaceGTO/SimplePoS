import 'dart:math';
import 'dart:developer' as dev;
import 'package:simplepos/data/database/dbmanager.dart';
import 'package:simplepos/data/database/table_scheme.dart';
import 'package:simplepos/models/data/saldo_model.dart';
import 'package:simplepos/models/data/usaha_model.dart';

class UsahaDao {
  // ---------------------------------------------
  // Mengambil mutasi saldo berdasarkan periode
  // --------------------------------------------
  Future<List<SaldoModel>> getMutasiSaldoByPeriod({
    int? year,
    int? month,
  }) async {
    final db = await Dbmanager.database;
    final today = DateTime.now();
    late DateTime awal;
    late DateTime akhir;
    year ??= today.year;
    month ??= today.month;
    awal = DateTime(year, month, 1);
    akhir = DateTime(year, month + 1, 1);
    try {
      final result = await db.query(
        TableScheme.tbSaldo,
        where: "tanggal>=? AND tanggal<?",
        whereArgs: [awal.toIso8601String(), akhir.toIso8601String()],
      );
      return result.map((e) => SaldoModel.fromMap(e)).toList();
    } catch (e) {
      dev.log(e.toString());
      throw Exception(e.toString());
    }
  }

  // =========Menyimpan data usaha=========
  Future<void> saveUsaha(UsahaModel data) async {
    final db = await Dbmanager.database;
    try {
      return await db.transaction((txn) async {
        dev.log("$runtimeType: Membuat kode usaha");
        data.kodeusaha = generateKodeUsaha();
        final tglRegister = DateTime.now().toIso8601String();
        data.tglRegister = tglRegister;

        dev.log("$runtimeType: Menyimpan data usaha");
        // insert data usaha
        await txn.insert(TableScheme.tbUsaha, data.toMap());

        dev.log("$runtimeType: Menyimpan saldo bonus pendaftaran");
        // insert saldo bonus pendaftaran
        final saldoAwal = SaldoModel(
          tanggal: tglRegister,
          pos: "D",
          keterangan: "Saldo bonus pendaftaran",
          nilai: 100000,
        );
        await txn.insert(TableScheme.tbSaldo, saldoAwal.toMap());
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // =========Mengambil data usaha=========
  Future<UsahaModel?> getDataUsaha() async {
    final db = await Dbmanager.database;
    try {
      final result = await db.query(TableScheme.tbUsaha, limit: 1);
      if (result.isEmpty) {
        return null;
      }
      return UsahaModel.fromMap(result[0]);
    } catch (e) {
      throw Exception(e);
    }
  }
}

String generateKodeUsaha() {
  final now = DateTime.now();
  final random = Random();

  final kode =
      '${now.year}'
      '${now.month.toString().padLeft(2, '0')}'
      '${now.day.toString().padLeft(2, '0')}-'
      '${now.hour.toString().padLeft(2, '0')}'
      '${now.minute.toString().padLeft(2, '0')}'
      '${now.second.toString().padLeft(2, '0')}-'
      '${random.nextInt(999).toString().padLeft(3, '0')}';

  return kode;
}
