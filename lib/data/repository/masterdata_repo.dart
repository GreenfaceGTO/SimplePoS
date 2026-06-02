import 'dart:developer';

import 'package:simplepos/data/database/dao/produk_dao.dart';
import 'package:simplepos/data/database/dao/usaha_dao.dart';
import 'package:simplepos/models/data/produk_model.dart';
import 'package:simplepos/models/data/usaha_model.dart';

class MasterdataRepo {
  final UsahaDao usahaDao;
  final ProdukDao produkDao;
  MasterdataRepo({required this.usahaDao, required this.produkDao});

  // ====== Mengupdate produk ==========
  Future<ProdukModel> updateProduk(ProdukModel produk) async {
    try {
      return await produkDao.updateProduk(produk);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ======= Menghapus produk ============
  Future<bool> delProduk(ProdukModel data) async {
    try {
      return await produkDao.deleteProduk(data);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ======== Menyimpan data produk =========
  Future<ProdukModel> addNewProduk(ProdukModel data) async {
    try {
      return await produkDao.addNewProduk(data);
    } catch (e) {
      throw Exception("Gagal menyimpan : ${e.toString()}");
    }
  }

  // ========= Mengambil daftar produk =========
  Future<List<ProdukModel>> fetchAllProduk() async {
    try {
      log("$runtimeType : fetch all produk");
      return await produkDao.fetchProduk();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // =======Menyimpan data usaha=======
  Future<void> saveDataUsaha(UsahaModel data) async {
    try {
      await usahaDao.saveUsaha(data);
    } catch (e) {
      throw Exception(e);
    }
  }

  // =========Mengambil data usaha=========
  Future<UsahaModel?> getDataUsaha() async {
    try {
      return await usahaDao.getDataUsaha();
    } catch (e) {
      throw Exception(e);
    }
  }
}
