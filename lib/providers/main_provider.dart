import 'package:flutter/material.dart';
import 'package:simplepos/services/utils/enums.dart';

class MainProvider with ChangeNotifier {
  /// index halaman bottom navbar
  int _currentPage = 0;

  /// getter index halaman bottom navbar
  int get currentPage => _currentPage;

  /// setter index halaman bottom navbar
  void setPage(int index) {
    _currentPage = index;
    notifyListeners();
  }

  /// mode halaman produk
  ProdukPageMode _produkPageMode = ProdukPageMode.browser;

  /// getter mode halaman produk
  ProdukPageMode get produkPageMode => _produkPageMode;

  /// setter mode halaman produk
  void setProdukPageMode(ProdukPageMode mode) {
    _produkPageMode = mode;
    notifyListeners();
  }
}
