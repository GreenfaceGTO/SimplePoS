import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:simplepos/data/repository/transaksi_repo.dart';
import 'package:simplepos/models/data/itemtransaksi_model.dart';
import 'package:simplepos/models/data/transaksi_model.dart';
import 'package:simplepos/providers/master_provider.dart';
import 'package:simplepos/services/utils/enums.dart';
import 'package:simplepos/ui/widget/reusable/public_widget.dart';

class TransaksiProvider with ChangeNotifier {
  final TransaksiRepo _transaksiRepo = TransaksiRepo();
  final MasterProvider masterProvider;

  TransaksiProvider(this.masterProvider);

  /// variabel daftar transaksi hari ini
  final List<TransaksiModel> _lstTodayTrx = [];
  final List<TransaksiModel> _lstPendingTrx = [];
  TransaksiModel? _currentTransaksi;

  bool _isLoading = false;

  List<TransaksiModel> get daftarTrxHariIni => _lstTodayTrx;
  List<TransaksiModel> get daftarPendingTrx => _lstPendingTrx;
  TransaksiModel? get currentTransaksi => _currentTransaksi;

  bool get isLoading => _isLoading;

  /// Menghapus transaksi dalam keranjang (status = draft)
  Future<void> deleteCart() async {
    try {
      final result = await _transaksiRepo.deleteCart(currentTransaksi!);
      if (result) {
        // update stok local
        for (var detail in currentTransaksi!.lstDetail) {
          masterProvider.updateStok(
            detail.idProduk!,
            detail.qty! * detail.isi!,
            tambah: true,
          );
        }

        _lstTodayTrx.removeWhere((e) => e.id == currentTransaksi!.id!);
        _currentTransaksi = null;
        notifyListeners();
      } else {
        log("gagal");
      }
    } catch (e) {
      PublicWidget.showMessage(message: e.toString(), mode: MessageMode.error);
    }
  }

  /// Menambahkan transaksi baru, metode ini dipanggil hanya saat user menambahkan item pertama ke dalam keranjang. Untuk item selanjutnya menggunakan metode [addOtherItemToTrx]
  Future<bool> addNewTransaksi(ItemtransaksiModel firstItem) async {
    var firstTotal = firstItem.harga! * (firstItem.isi! * firstItem.qty!);

    final newTrx = TransaksiModel(
      tipe: 'jual',
      tanggal: DateTime.now().toIso8601String(),
      total: firstTotal,
      status: "draft",
      lstDetail: [firstItem],
    );

    try {
      final trx = await _transaksiRepo.addNewCart(newTrx);

      // jika transaksi pertama sudah berhasil disimpan [trx!=null] update stok di master provider
      if (trx.id != null) {
        _currentTransaksi = trx;
        _lstTodayTrx.add(trx);
        for (var sat in _currentTransaksi!.lstDetail) {
          masterProvider.updateStok(sat.idProduk!, sat.qty! * sat.isi!);
        }
        notifyListeners();
      }
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// mengambil data transaksi hari ini
  Future<void> loadTodayTransaksi() async {
    _setLoading(true);
    try {
      final result = await _transaksiRepo.getTodayTrx();
      if (result.isNotEmpty) {
        _lstTodayTrx.addAll(result);

        // looping trx ini jika ada yang masih berstatus draf
        for (var item in _lstTodayTrx) {
          if (item.status == 'draft') {
            _currentTransaksi = item;
          }
        }
        notifyListeners();
      }
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
