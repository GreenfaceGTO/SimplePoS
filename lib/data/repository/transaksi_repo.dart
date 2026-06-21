import 'package:simplepos/data/database/dao/transaksi_dao.dart';
import 'package:simplepos/models/data/itemtransaksi_model.dart';
import 'package:simplepos/models/data/transaksi_model.dart';

class TransaksiRepo {
  final TransaksiDao _transaksiDao = TransaksiDao();

  // Menambahkah detail transaksi
  Future<ItemtransaksiModel> addItemToCart(
    ItemtransaksiModel newDetail,
    double currentTotal,
  ) async {
    try {
      return await _transaksiDao.addDetailCart(newDetail, currentTotal);
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

  // Mengambil transaksi periode ini.
  Future<List<TransaksiModel>> getTrxByThisPeriod() async {
    try {
      return await _transaksiDao.getTrxForPeriode();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
