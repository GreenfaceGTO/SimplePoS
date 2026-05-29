import 'package:simplepos/data/database/dbmanager.dart';
import 'package:simplepos/data/database/table_scheme.dart';
import 'package:simplepos/models/data/produk_model.dart';

class ProdukDao {
  // ======Menambahkan produk baru=========
  Future<ProdukModel> addNewProduk(ProdukModel data) async {
    final db = await Dbmanager.database;
    try {
      return db.transaction<ProdukModel>((txn) async {
        final idProduk = await txn.insert(TableScheme.tbItem, data.toMap());
        data.id = idProduk;

        // insert data satuan
        for (var sat in data.lstSatuan) {
          sat.idProduk = idProduk;
          final satId = await txn.insert(TableScheme.tbItemSat, sat.toMap());
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
        if (satuan.isNotEmpty) {
          item.lstSatuan = satuan;
        }
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
