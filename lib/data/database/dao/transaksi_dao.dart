import 'dart:developer';

import 'package:simplepos/data/database/dbmanager.dart';
import 'package:simplepos/data/database/table_scheme.dart';
import 'package:simplepos/models/data/itemtransaksi_model.dart';
import 'package:simplepos/models/data/transaksi_model.dart';

class TransaksiDao {
  // Menambahkan detail transaksi ke transaksi dengan status draft

  // Menyimpan transaksi baru
  Future<TransaksiModel> addToCart(TransaksiModel trxData) async {
    final db = await Dbmanager.database;

    try {
      return await db.transaction<TransaksiModel>((txn) async {
        final idTrx = await txn.insert(TableScheme.tbTranshd, trxData.toDb());
        trxData.id = idTrx;

        // insert data detail
        for (var dtl in trxData.lstDetail) {
          dtl.idTransaksi = idTrx;
          final detailId = await txn.insert(TableScheme.tbTransdt, dtl.toMap());
          dtl.id = detailId;
          final qty = dtl.qty! * dtl.isi!;

          // potong stok item
          await txn.execute(
            '''UPDATE ${TableScheme.tbItem} SET stok = stok - ? WHERE id=?''',
            [qty, dtl.idProduk],
          );
        }

        return trxData;
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // menghapus data transaksi
  Future<bool> deleteTransaksi(TransaksiModel data) async {
    log("mulai menghapus");
    final db = await Dbmanager.database;

    log(db.path);

    try {
      return await db.transaction((txn) async {
        log("Masuk transaksi");
        // looping untuk memulihkan stok
        for (var detail in data.lstDetail) {
          final qty = detail.qty! * detail.isi!;
          await txn.execute(
            '''UPDATE ${TableScheme.tbItem} SET stok = stok + ? WHERE id=?''',
            [qty, detail.idProduk],
          );
        }

        //  hapus detail transaksi
        await txn.delete(
          TableScheme.tbTransdt,
          where: "id_header=?",
          whereArgs: [data.id],
        );

        // hapus transaksi
        return await txn.delete(
              TableScheme.tbTranshd,
              where: "id=?",
              whereArgs: [data.id],
            ) >
            0;
      });
    } catch (e) {
      throw Exception(e.toString());
      // log(e.toString());
      // log(s.toString());
      // return false;
    }
  }

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
