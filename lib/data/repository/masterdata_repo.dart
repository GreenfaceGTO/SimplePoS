import 'dart:developer';

import 'package:simplepos/data/database/dao/produk_dao.dart';
import 'package:simplepos/data/database/dao/usaha_dao.dart';
import 'package:simplepos/models/data/mutasistok_model.dart';
import 'package:simplepos/models/data/produk_model.dart';
import 'package:simplepos/models/data/saldo_model.dart';
import 'package:simplepos/models/data/usaha_model.dart';

class MasterdataRepo {
  final UsahaDao usahaDao;
  final ProdukDao produkDao;
  MasterdataRepo({required this.usahaDao, required this.produkDao});

  // ------------------------------------------
  // Mengambil saldo awal periode sebelumnya
  // ------------------------------------------
  Future<int> getSaldoAkhirLalu({
    required int tahun,
    required int bulan,
    required int idProduk,
  }) async {
    try {
      return await produkDao.hitungSaldoAwal(
        tahun: tahun,
        bulan: bulan,
        idProduk: idProduk,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ------------------------------
  // Mengambil data mutasi item
  // ------------------------------
  Future<List<MutasistokModel>> getMutasiStok({
    required int idProduk,
    required int tahun,
    required int bulan,
  }) async {
    try {
      return await produkDao.getMutasi(
        idProduk: idProduk,
        tahun: tahun,
        bulan: bulan,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ----------------------
  // Mengupdate stok item
  // ----------------------
  Future<bool> updateStok({required int idProduk, required int value}) async {
    try {
      return await produkDao.updateItemStok(idProduk: idProduk, value: value);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ========= Mengambil daftar mutasi saldo periode ini ===========
  Future<List<SaldoModel>> getMutasiSaldo() async {
    try {
      return await usahaDao.getMutasiSaldoByPeriod();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

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
