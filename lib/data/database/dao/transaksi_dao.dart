import 'dart:developer';

import 'package:simplepos/data/database/dbmanager.dart';
import 'package:simplepos/data/database/table_scheme.dart';
import 'package:simplepos/models/data/itemtransaksi_model.dart';
import 'package:simplepos/models/data/mutasistok_model.dart';
import 'package:simplepos/models/data/transaksi_model.dart';
import 'package:sqflite/sqflite.dart';

class TransaksiDao {
  // ----------------------------------
  // Menghapus item dalam transaksi
  // ----------------------------------
  Future<bool> removeCartDetail(
    TransaksiModel transaksi,
    ItemtransaksiModel detail,
  ) async {
    final db = await Dbmanager.database;
    try {
      return await db.transaction((txn) async {
        final qty = detail.qty;
        final subTotal = detail.qty! * detail.harga!;

        // pulihkan stok
        await updateStok(txn, idProduk: detail.idProduk!, newValue: qty!);

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
    required TransaksiModel transaksi,
    required ItemtransaksiModel detail,
    required int newValue,
  }) async {
    final db = await Dbmanager.database;
    try {
      return await db.transaction((txn) async {
        // update stok
        await txn.execute(
          """UPDATE ${TableScheme.tbItem} SET stok = stok + ? WHERE id=?""",
          [newValue, detail.idProduk],
        );

        // update detail transaksi
        await txn.execute(
          """UPDATE ${TableScheme.tbTransdt} SET qty = qty + ? WHERE id=? AND id_header=?""",
          [newValue, detail.id, detail.idTransaksi],
        );

        // update total transaksi
        await txn.execute(
          """UPDATE ${TableScheme.tbTranshd} SET total=total+? WHERE id=?""",
          [],
        );

        return true;
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ---------------------------------------------------------------------
  // Menambahkan detail transaksi ke transaksi dengan status draft
  // ---------------------------------------------------------------------
  Future<ItemtransaksiModel> addItemToCart(
    TransaksiModel transaksi,
    ItemtransaksiModel newDetail,
    double currentTotal,
  ) async {
    final db = await Dbmanager.database;
    try {
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
        await updateStok(txn, idProduk: newDetail.idProduk!, newValue: qty);

        // update mutasi
        final mutasi = MutasistokModel(
          tanggal: transaksi.tanggal,
          idProduk: newDetail.idProduk,
          idTransaksi: newDetail.idTransaksi,
          pos: "OUT",
          keterangan: "",
          qty: qty,
        );
        await updateMutasi(txn, mutasi);

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
        // Menyimpan header transaksi
        final idTrx = await txn.insert(TableScheme.tbTranshd, trxData.toDb());
        trxData.id = idTrx;

        // insert data detail
        for (var dtl in trxData.lstDetail) {
          dtl.idTransaksi = idTrx;

          log(
            "$runtimeType: insert item ${dtl.namaProduk} pada detail transaksi sejumlah ${dtl.qty}",
          );
          final detailId = await txn.insert(TableScheme.tbTransdt, dtl.toMap());
          dtl.id = detailId;

          final qty = dtl.qty! * dtl.isi!;
          log("$runtimeType : update stok ${dtl.namaProduk} ${-qty.abs()}");

          // potong stok item
          await updateStok(txn, idProduk: dtl.idProduk!, newValue: -qty.abs());

          // catat mutasi stok keluar
          final nilai = (dtl.qty! * dtl.isi!) * dtl.harga!;
          final mutasi = MutasistokModel(
            tanggal: DateTime.now().toIso8601String(),
            keterangan:
                "Transaksi penjualan nomor ${trxData.id.toString().padLeft(6, '0')}",
            pos: "OUT",
            idTransaksi: trxData.id,
            idProduk: dtl.idProduk,
            qty: dtl.qty!.abs(),
            nilai: nilai,
          );

          log(
            "$runtimeType: Mencatat mutasi keluar item ${dtl.namaProduk} pada tabel mutasi stok",
          );

          await updateMutasi(txn, mutasi);
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

    try {
      log(data.toMap().toString());
      return await db.transaction((txn) async {
        // looping untuk memulihkan stok
        for (var detail in data.lstDetail) {
          final qty = detail.qty! * detail.isi!;
          log(
            "$runtimeType: hapus transaksi No ${detail.idTransaksi} & update stok ${detail.namaProduk} sejumlah $qty",
          );
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
        // hapus mutasi stok
        await txn.delete(
          TableScheme.tbMutasiStok,
          where: 'id_transaksi=?',
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
      log("$runtimeType: ${e.toString()}");
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

  // -----------------------------------------------------------------------
  // Mengupdate stok produk ketika ada perubahan qty pada detail transaksi
  // -----------------------------------------------------------------------
  Future<void> updateStok(
    Transaction txn, {
    required int idProduk,
    required int newValue,
  }) async {
    try {
      log("$runtimeType [updateStok] value $newValue");
      await txn.execute(
        """UPDATE ${TableScheme.tbItem} SET stok = stok + ? WHERE id=?""",
        [newValue, idProduk],
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // -------------------------------------------------------------
  // mengupdate total transaksi ketika ada perubahan didetail
  // -------------------------------------------------------------
  Future<void> updateTotalTransaksi(TransaksiModel data) async {
    double total = 0;
    for (var detail in data.lstDetail) {
      double subTotal = (detail.qty! * detail.isi!) * detail.harga!;
      total = total + subTotal;
    }
    final db = await Dbmanager.database;

    try {
      await db.transaction((txn) async {
        await txn.execute(
          """UPDATE ${TableScheme.tbTranshd} SET total=? WHERE id=?""",
          [total, data.id],
        );
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // -------------------------
  // Mencatat mutasi stok
  // -------------------------
  Future<void> updateMutasi(Transaction txn, MutasistokModel mutasi) async {
    try {
      // periksa jika mutasi sudah ada
      final lstCurrent = await txn.query(
        TableScheme.tbMutasiStok,
        where: "id_item=? AND id_transaksi=?",
        whereArgs: [mutasi.idProduk, mutasi.idTransaksi],
      );

      if (lstCurrent.isNotEmpty) {
        // update data lama
        log("$runtimeType: Update mutasi");
        await txn.execute(
          """UPDATE ${TableScheme.tbMutasiStok} SET qty=qty+? WHERE id_item=? AND id_transaksi=?""",
          [mutasi.qty, mutasi.idProduk, mutasi.idTransaksi],
        );
      } else {
        log("$runtimeType: Insert mutasi");
        // buat data baru
        await txn.insert(TableScheme.tbMutasiStok, mutasi.toMap());
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
