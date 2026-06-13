import 'package:flutter/material.dart';
import 'package:simplepos/data/repository/transaksi_repo.dart';
import 'package:simplepos/models/data/transaksi_model.dart';

class TransaksiProvider with ChangeNotifier {
  final TransaksiRepo _transaksiRepo = TransaksiRepo();

  List<TransaksiModel> _lstHistoryTrx = [];
  List<TransaksiModel> _lstPendingTrx = [];

  bool _isLoading = false;

  List<TransaksiModel> get daftarRiwayatTrx => _lstHistoryTrx;
  List<TransaksiModel> get daftarPendingTrx => _lstPendingTrx;

  bool get isLoading => _isLoading;

  Future<void> loadTransaksi() async {
    _setLoading(true);
    try {} finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
