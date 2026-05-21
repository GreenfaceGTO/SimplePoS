import 'package:flutter/material.dart';
import 'package:simplepos/models/menu_model.dart';
import 'package:simplepos/ui/tab_page/cart_tabpage.dart';
import 'package:simplepos/ui/tab_page/dashboard_tabpage.dart';
import 'package:simplepos/ui/tab_page/history_tabpage.dart';
import 'package:simplepos/ui/tab_page/produk_tabpage.dart';

class MainProvider with ChangeNotifier {
  int _currentPage = 0;

  int get currentPage => _currentPage;

  void setPage(int index) {
    _currentPage = index;
    notifyListeners();
  }

  // ======Daftar Halaman Main======
  List<Widget> lstMainPage = [
    DashboardTabpage(),
    ProdukTabpage(),
    CartTabpage(),
    HistoryTabpage(),
  ];

  // ======Daftar menu bawah=======
  List<MenuModel> lstBottomMenu = [
    MenuModel(label: "Dashboard", icon: Icon(Icons.dashboard)),
    MenuModel(label: "Produk", icon: Icon(Icons.inventory)),
    MenuModel(label: "Keranjang", icon: Icon(Icons.shopping_cart)),
    MenuModel(label: "Riwayat", icon: Icon(Icons.history)),
  ];
}
