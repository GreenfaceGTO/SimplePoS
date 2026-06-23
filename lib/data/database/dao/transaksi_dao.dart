import 'dart:developer';

import 'package:simplepos/data/database/dbmanager.dart';
import 'package:simplepos/data/database/table_scheme.dart';
import 'package:simplepos/models/data/itemtransaksi_model.dart';
import 'package:simplepos/models/data/transaksi_model.dart';

class TransaksiDao {
  // ----------------------------------
  // Menghapus item dalam transaksi
  // ----------------------------------
  Future<bool> removeCartDetail(ItemtransaksiModel detail) async {
    final db = await Dbmanager.database;
    try {
      return await db.transaction((txn) async {
        final qty = detail.qty;
        final subTotal = detail.qty! * detail.harga!;

        // pulihkan stok
        await txn.execute(
          """UPDATE ${TableScheme.tbItem} SET stok = stok + ? WHERE id=?""",
          [qty, detail.idProduk],
        );

        // hapus detail
        await txn.delete(
          TableScheme.tbTransdt,
          where: "id=?",
          whereArgs: [detail.id],
        );

        //  update total di header

        await txn.execute(
          """UPDATE ${TableScheme.tbTranshd} SET total=total-? WHERE id=?""",
          [subTotal, detail.idTransaksi],
        );

        return true;
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ------------------------------------------
  // Merubah jumlah item di detail transaksi
  // ------------------------------------------
  Future<bool> updateTrxQty({
    required ItemtransaksiModel data,
    required int newValue,
  }) async {
    final db = await Dbmanager.database;
    try {
      return await db.transaction((txn) async {
        // TODO: inibelum lengkap
        return false;
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ---------------------------------------------------------------------
  // Menambahkan detail transaksi ke transaksi dengan status draft
  // ---------------------------------------------------------------------
  Future<ItemtransaksiModel> addItemToCart(
    // int idheader,
    ItemtransaksiModel newDetail,
    double currentTotal,
  ) async {
    final db = await Dbmanager.database;
    try {
      log("$runtimeType: ${newDetail.toMap()}");
      return await db.transaction((txn) async {
        // tambahkan total dimemori saat ini dengan total dari item baru
        currentTotal = currentTotal + (newDetail.qty! * newDetail.harga!);
        final qty = newDetail.qty! * newDetail.isi!;

        // periksa jika item sudah ada
        final dtlTransaksi = await txn.query(
          TableScheme.tbTransdt,
          where: "id_header=? AND id_item=?",
          whereArgs: [newDetail.idTransaksi, newDetail.idProduk],
          limit: 1,
        );

        if (dtlTransaksi.isNotEmpty) {
          // casting menjadi itemtransaksi
          List<ItemtransaksiModel> lstItem = dtlTransaksi
              .map((e) => ItemtransaksiModel.fromMap(e))
              .toList();
          final idx = lstItem.indexWhere(
            (e) => e.idProduk == newDetail.idProduk,
          );

          // ambil id data detail
          newDetail.id = lstItem[idx].id;
          log("update");

          // jika detail item sudah ada, update untuk menambahkan jumlahnya
          await txn.execute(
            """UPDATE ${TableScheme.tbTransdt} SET qty=qty+? where id_item=? AND id_header=? """,
            [qty, newDetail.idProduk, newDetail.idTransaksi],
          );
        } else {
          log("insert");
          //  jika detail item belum ada, insert
          final newId = await txn.insert(
            TableScheme.tbTransdt,
            newDetail.toMap(),
          );
          newDetail.id = newId;
        }

        // update stok
        await txn.execute(
          """UPDATE ${TableScheme.tbItem} SET stok=stok-? WHERE id=?""",
          [qty, newDetail.id],
        );

        // update total di header transaksi
        await txn.execute(
          """UPDATE ${TableScheme.tbTranshd} SET total=? WHERE id=?""",
          [currentTotal, newDetail.idTransaksi],
        );

        return newDetail;
      });
    } catch (e) {
      rethrow;
      // throw Exception(e.toString());
    }
  }

  // -----------------------------
  // Menyimpan transaksi baru
  // -----------------------------
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

  // --------------------------
  // menghapus data transaksi
  // --------------------------
  Future<bool> deleteTransaksi(TransaksiModel data) async {
    final db = await Dbmanager.database;

    log(db.path);

    try {
      return await db.transaction((txn) async {
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
    }
  }

  // ------------------------------------------------------------------------
  // Mengambil data transaksi, jika parameter tahun dan bulan null
  // maka periode ini yang akan diambil
  // ------------------------------------------------------------------------
  Future<List<TransaksiModel>> getTrxForPeriode({
    int? tahun,
    int? bulan,
  }) async {
    final db = await Dbmanager.database;
    final today = DateTime.now();
    late DateTime awal;
    late DateTime akhir;
    tahun ??= today.year;
    bulan ??= today.month;

    awal = DateTime(tahun, bulan, 1);
    akhir = DateTime(tahun, bulan + 1, 1);

    try {
      final result = await db.query(
        TableScheme.tbTranshd,
        where: "tanggal>=? AND tanggal<?",
        whereArgs: [awal.toIso8601String(), akhir.toIso8601String()],
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

  // ------------------------------
  // Mengambil detail transaksi
  // ------------------------------
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
