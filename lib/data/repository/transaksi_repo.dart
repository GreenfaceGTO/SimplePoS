import 'package:simplepos/data/database/dao/produk_dao.dart';
import 'package:simplepos/data/database/dao/transaksi_dao.dart';

class TransaksiRepo {
  final TransaksiDao _transaksiDao = TransaksiDao();
  final ProdukDao _produkDao = ProdukDao();
}
