import 'dart:developer';

import 'package:simplepos/data/database/dbmanager.dart';
import 'package:simplepos/data/database/table_scheme.dart';
import 'package:simplepos/models/data/mutasistok_model.dart';
import 'package:simplepos/models/data/produk_model.dart';
import 'package:simplepos/models/data/produksat_model.dart';
import 'package:sqflite/sqlite_api.dart';

class ProdukDao {
  // --------------------------------------------------------
  /// menghitung sisa mutasi saldo stok periode sebelumnya
  /// [tahun] dan [bulan] adalah periode data stok yang akan
  /// ditampilkan, maka stok awal dihitung sebelum periode
  /// tersebut
  // --------------------------------------------------------
  Future<int> hitungSaldoAwal({
    required int tahun,
    required int bulan,
    required int idProduk,
  }) async {
    final db = await Dbmanager.database;

    // buat tanggal awal untuk peride ini
    final today = DateTime(tahun, bulan, 1);

    try {
      final result = await db.rawQuery(
        """
        SELECT COALESCE(SUM(CASE WHEN pos_tipe='IN' THEN qty WHEN pos_tipe='OUT' THEN -qty END),0) as stok_awal 
        FROM ${TableScheme.tbMutasiStok}
        WHERE id_item=? AND tanggal<?
        """,
        [idProduk, today.toIso8601String()],
      );

      log(result.toString());

      if (result.isEmpty) {
        return 0;
      } else {
        return (result.first['stok_awal'] as num).toInt();
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // -----------------------------
  // mengambil data mutasi stok
  // -----------------------------
  Future<List<MutasistokModel>> getMutasi({
    required int idProduk,
    required int tahun,
    required int bulan,
  }) async {
    final db = await Dbmanager.database;

    final awal = DateTime(tahun, bulan, 1);
    final akhir = DateTime(tahun, bulan + 1, 1);
    try {
      final result = await db.query(
        TableScheme.tbMutasiStok,
        where: "id_item = ? AND (tanggal >= ? AND tanggal < ?)",
        whereArgs: [idProduk, awal.toIso8601String(), akhir.toIso8601String()],
      );

      if (result.isEmpty) return [];
      List<MutasistokModel> lstResult = result
          .map((e) => MutasistokModel.fromMap(e))
          .toList();
      return lstResult;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // --------------------------------------------------------------
  // update stok item
  // metode ini digunakan saat user menambah atau mengurangi jumlah
  // item dalam cart. jika parameter value bernilai positif maka stok
  // ditambahkan, sebaliknya dikurangi
  // --------------------------------------------------------------
  Future<bool> updateItemStok({
    required int idProduk,
    required int value,
  }) async {
    final db = await Dbmanager.database;
    try {
      await db.execute(
        """UPDATE ${TableScheme.tbItem} SET stok= stok+? WHERE id=?""",
        [idProduk, value],
      );
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ======== Mengupdate Produk ============
  Future<ProdukModel> updateProduk(ProdukModel updatedData) async {
    final db = await Dbmanager.database;
    try {
      return await db.transaction((txn) async {
        // mengupdate data produk
        await txn.update(
          TableScheme.tbItem,
          updatedData.toDb(),
          where: "id=?",
          whereArgs: [updatedData.id],
        );

        // ambil satuan produk dari data update yang memiliki id
        final satFromList = updatedData.lstSatuan!
            .where((e) => e.id != null)
            .map((e) => e.id)
            .toList();

        log("$runtimeType : ${updatedData.lstSatuan!.map((e) => e.toMap())}");

        // ambil satuan produk di db untuk dibandingkan dengan daftar satuan pada update
        final satFromDb = await txn.query(
          TableScheme.tbItemSat,
          where: "id_produk=?",
          whereArgs: [updatedData.id],
        );

        // ambil satuan yang akan dihapus dari variabel satFromDb yang tidak ada pada satFromList
        final toDelete = satFromDb
            .map((e) => e['id'] as int)
            .where((id) => !satFromList.contains(id))
            .toList();

        // hapus satuan yang sudah tidak ada di data update
        for (var id in toDelete) {
          await txn.delete(
            TableScheme.tbItemSat,
            where: "id=?",
            whereArgs: [id],
          );
        }

        // looping satuan dari update data untuk menghapus data lama atau menambahkan data baru di db
        for (var sat in updatedData.lstSatuan!) {
          if (sat.id != null) {
            await txn.update(
              TableScheme.tbItemSat,
              {
                "satuan": sat.satuan,
                "isi": sat.isi,
                "tipe": sat.tipe,
                "barcode": sat.barcode,
                "h_pokok": sat.hPokok,
                "h_jual": sat.hJual,
              },
              where: "id=?",
              whereArgs: [sat.id],
            );
          } else {
            sat.idProduk = updatedData.id;
            final idSat = await txn.insert(TableScheme.tbItemSat, sat.toDb());
            sat.id = idSat;
          }
        }
        return updatedData;
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ======Menghapus produk===========
  Future<bool> deleteProduk(ProdukModel data) async {
    final db = await Dbmanager.database;

    try {
      return await db.transaction((txn) async {
        // hapus detail
        await txn.delete(
          TableScheme.tbItemSat,
          where: "id_produk=?",
          whereArgs: [data.id],
        );

        // hapus header
        await txn.delete(
          TableScheme.tbItem,
          where: "id=?",
          whereArgs: [data.id],
        );
        return true;
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ======Menambahkan produk baru=========
  Future<ProdukModel> addNewProduk(ProdukModel data) async {
    final db = await Dbmanager.database;
    try {
      return await db.transaction<ProdukModel>((txn) async {
        log("$runtimeType: menambahkan produk baru pada master produk");

        final idProduk = await txn.insert(TableScheme.tbItem, data.toDb());
        data.id = idProduk;

        log("$runtimeType: menambahkan satuan produk");
        // insert data satuan
        for (var sat in data.lstSatuan!) {
          sat.idProduk = idProduk;
          final satId = await txn.insert(TableScheme.tbItemSat, sat.toDb());
          sat.id = satId;
        }

        // mencatat mutasi stok sebagai stok awal
        final today = DateTime.now().toIso8601String();
        final mutasi = MutasistokModel(
          tanggal: today,
          keterangan: "Inisialisasi stok awal",
          pos: "IN",
          idProduk: data.id,
          idSatuan: data.lstSatuan![0].id,
          qty: data.stok,
          nilai: data.stok! * data.lstSatuan![0].hPokok!,
        );
        await updateMutasiStok(txn, mutasi);

        return data;
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // =======Mengambil daftar produk=======
  Future<List<ProdukModel>> fetchProduk() async {
    final db = await Dbmanager.database;
    try {
      final result = await db.query(TableScheme.tbItem);
      if (result.isEmpty) {
        return [];
      }
      List<ProdukModel> lstProduk = result
          .map((e) => ProdukModel.fromMap(e))
          .toList();

      for (var item in lstProduk) {
        final satuan = await getSatuanProduk(item.id!);
        item.lstSatuan = satuan;
        item.lstSatuan!.sort((a, b) => a.isi.compareTo(b.isi));
      }
      return lstProduk;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ======= Mengambil satuan berdasarkan id produk=======
  Future<List<ProdukSatModel>> getSatuanProduk(int idProduk) async {
    final db = await Dbmanager.database;
    try {
      final satuan = await db.query(
        TableScheme.tbItemSat,
        where: "id_produk=?",
        whereArgs: [idProduk],
      );
      List<ProdukSatModel> lstSatuan = satuan
          .map((e) => ProdukSatModel.fromMap(e))
          .toList();
      return lstSatuan;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateMutasiStok(Transaction txn, MutasistokModel mutasi) async {
    try {
      log("$runtimeType: Menambahkan mutasi stok : ${mutasi.toMap()}");

      await txn.insert(TableScheme.tbMutasiStok, mutasi.toMap());
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
