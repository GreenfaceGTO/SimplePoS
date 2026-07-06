import 'package:simplepos/data/database/dao/opname_dao.dart';
import 'package:simplepos/models/data/opname_model.dart';
import 'package:simplepos/models/data/produk_model.dart';

class OpnameRepo {
  final OpnameDao _opnameDao = OpnameDao();

  // ----------------------------------
  // Mengambil daftar riwayat opname
  // ----------------------------------
  Future<List<OpnameModel>> fetchData({int? tahun, int? bulan}) async {
    try {
      return await _opnameDao.fetchOpnameHistory(tahun, bulan);
    } catch (e) {
      Exception(e.toString());
    }
    return [];
  }

  // -----------------------
  // Menyimpan data opname
  // -----------------------
  Future<OpnameModel?> createOpnameData(OpnameModel data) async {
    try {
      return await _opnameDao.createOpname(data);
    } catch (e) {
      Exception(e.toString());
    }
    return null;
  }

  //  ------------------------------------------
  // mengambil daftar produk untuk stokc opname
  //  ------------------------------------------
  Future<List<ProdukModel>> fetchIraProduk() async {
    try {
      return await _opnameDao.getNonIraProduk();
    } catch (e) {
      Exception(e.toString());
    }
    return [];
  }
}
