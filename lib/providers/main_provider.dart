import 'package:flutter/material.dart';
import 'package:simplepos/models/menu_model.dart';
import 'package:simplepos/ui/dummy_page.dart';

class MainProvider with ChangeNotifier {
  int _currentPage = 0;

  int get currentPage => _currentPage;

  void setPage(int index) {
    _currentPage = index;
    notifyListeners();
  }

  // ======Daftar Halaman Main======
  List<Widget> lstMainPage = [
    DummyPage(caption: "Dashboard Page"),
    DummyPage(caption: "Produk Page"),
    DummyPage(caption: "Cart Page"),
    DummyPage(caption: "History Page"),
    DummyPage(caption: "Manage Page"),
  ];

  // ======Daftar menu bawah=======
  List<MenuModel> lstBottomMenu = [
    MenuModel(label: "Dashboard", icon: Icon(Icons.dashboard)),
    MenuModel(label: "Produk", icon: Icon(Icons.inventory)),
    MenuModel(label: "Keranjang", icon: Icon(Icons.shopping_cart)),
    MenuModel(label: "Riwayat", icon: Icon(Icons.history)),
    MenuModel(label: "Master", icon: Icon(Icons.settings)),
  ];
}
