import 'dart:developer';

import 'package:simplepos/data/database/dbmanager.dart';
import 'package:simplepos/data/database/table_scheme.dart';
import 'package:simplepos/models/data/produk_model.dart';
import 'package:simplepos/models/data/produksat_model.dart';

class ProdukDao {
  // ======== Mengupdate Produk ============
  Future<ProdukModel> updateProduk(ProdukModel updatedData) async {
    final db = await Dbmanager.database;
    try {
      return await db.transaction((txn) async {
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
      return await db.delete(
            TableScheme.tbItem,
            where: "id=?",
            whereArgs: [data.id],
          ) >
          0;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ======Menambahkan produk baru=========
  Future<ProdukModel> addNewProduk(ProdukModel data) async {
    final db = await Dbmanager.database;
    try {
      return await db.transaction<ProdukModel>((txn) async {
        final idProduk = await txn.insert(TableScheme.tbItem, data.toDb());
        data.id = idProduk;

        // insert data satuan
        for (var sat in data.lstSatuan!) {
          sat.idProduk = idProduk;
          final satId = await txn.insert(TableScheme.tbItemSat, sat.toDb());
          sat.id = satId;
        }
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
}
