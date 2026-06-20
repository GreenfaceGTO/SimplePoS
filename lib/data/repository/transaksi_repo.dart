import 'package:simplepos/data/database/dao/transaksi_dao.dart';
import 'package:simplepos/models/data/transaksi_model.dart';

class TransaksiRepo {
  final TransaksiDao _transaksiDao = TransaksiDao();

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

  // Mengambil transaksi hari ini
  Future<List<TransaksiModel>> getTodayTrx() async {
    try {
      return await _transaksiDao.getTodayTrx();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
