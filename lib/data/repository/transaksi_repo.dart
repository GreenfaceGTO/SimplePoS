import 'package:simplepos/data/database/dao/transaksi_dao.dart';
import 'package:simplepos/models/data/itemtransaksi_model.dart';
import 'package:simplepos/models/data/transaksi_model.dart';

class TransaksiRepo {
  final TransaksiDao _transaksiDao = TransaksiDao();

  // ---------------------------------
  // Menghapus detail transaksi
  // ---------------------------------
  Future<bool> delCartDetail(ItemtransaksiModel detail) async {
    try {
      return await _transaksiDao.removeCartDetail(detail);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ---------------------------------
  // Menambahkah detail transaksi
  // ---------------------------------
  Future<ItemtransaksiModel> addItemToCart(
    ItemtransaksiModel newDetail,
    double currentTotal,
  ) async {
    try {
      return await _transaksiDao.addItemToCart(newDetail, currentTotal);
    } catch (e) {
      rethrow;
    }
  }

  //  Menghapus data transaksi
  Future<bool> deleteCart(TransaksiModel data) async {
    try {
      return await _transaksiDao.deleteTransaksi(data);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Menghapus detail item dari transaksi
  Future<bool> delItemTransaksi(int idTrx, int idItem) async {
    try {
      return false;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Menyimpan transaksi baru
  Future<TransaksiModel> addNewCart(TransaksiModel data) async {
    try {
      return await _transaksiDao.addToCart(data);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ------------------------------------------------------------------------
  // Mengambil transaksi berdasarkan periode. secara default periode ini yang
  // akan diambil jika parameter tahun dan bulan = null
  // ------------------------------------------------------------------------
  Future<List<TransaksiModel>> getTrxByPeriod({int? tahun, int? bulan}) async {
    try {
      return await _transaksiDao.getTrxForPeriode(tahun: tahun, bulan: bulan);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
