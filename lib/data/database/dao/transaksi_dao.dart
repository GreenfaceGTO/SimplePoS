import 'package:simplepos/data/database/dbmanager.dart';
import 'package:simplepos/data/database/table_scheme.dart';
import 'package:simplepos/models/data/itemtransaksi_model.dart';
import 'package:simplepos/models/data/transaksi_model.dart';

class TransaksiDao {
  // Mengambil data transaksi hari ini
  Future<List<TransaksiModel>> getTodayTrx() async {
    final db = await Dbmanager.database;
    final today = DateTime.now();
    final tglMulai = DateTime(today.year, today.month, today.day);
    final tglAkhir = tglMulai.add(Duration(days: 1));

    try {
      final result = await db.query(
        TableScheme.tbTranshd,
        where: "tanggal>=? AND tanggal<?",
        whereArgs: [tglMulai.toIso8601String(), tglAkhir.toIso8601String()],
      );
      if (result.isEmpty) return [];

      List<TransaksiModel> lstTransaksi = result
          .map((e) => TransaksiModel.fromMap(e))
          .toList();

      // mengambil detail;
      for (var trx in lstTransaksi) {
        final detail = await getDetailTrx(trx.id!);
        trx.lstDetail = detail;
      }
      return lstTransaksi;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Mengambil detail transaksi
  Future<List<ItemtransaksiModel>> getDetailTrx(int id) async {
    final db = await Dbmanager.database;
    try {
      final detail = await db.query(
        TableScheme.tbTransdt,
        where: "id_header=?",
        whereArgs: [id],
      );
      List<ItemtransaksiModel> result = detail
          .map((e) => ItemtransaksiModel.fromMap(e))
          .toList();
      return result;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
