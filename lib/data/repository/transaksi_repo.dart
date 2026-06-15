import 'package:simplepos/data/database/dao/produk_dao.dart';
import 'package:simplepos/data/database/dao/transaksi_dao.dart';
import 'package:simplepos/models/data/transaksi_model.dart';

class TransaksiRepo {
  final TransaksiDao _transaksiDao = TransaksiDao();
  final ProdukDao _produkDao = ProdukDao();

  // Mengambil transaksi hari ini
  Future<List<TransaksiModel>> getTodayTrx() async {
    try {
      return await _transaksiDao.getTodayTrx();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
