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

  /// Menambahkan item detail transaksi baru
  Future<void> addNewDetailToCart(ItemtransaksiModel data) async {
    try {
      final newTotal = _currentTransaksi!.total! + (data.qty! * data.harga!);
      final result = await _transaksiRepo.addItemToCart(
        data,
        currentTransaksi!.total!,
      );

      // periksa jika item yang akan ditambahkan sudah ada di daftar detail transaksi
      bool ada = _currentTransaksi!.lstDetail.any(
        (e) => e.idProduk == data.idProduk,
      );
      if (ada) {
        // item sudah ada, update jumlahnya
        final idxDetail = _currentTransaksi!.lstDetail.indexWhere(
          (e) => e.idProduk == data.idProduk,
        );
        final oldQty = _currentTransaksi!.lstDetail[idxDetail].qty;
        final newQty = data.qty! + oldQty!;
        _currentTransaksi!.lstDetail[idxDetail].qty = newQty;
      } else {
        // item belum ada, tambahkan
        _currentTransaksi!.lstDetail.add(result);
      }

      // update total transaksi
      _currentTransaksi!.total = newTotal;
      notifyListeners();
    } catch (e) {
      PublicWidget.showMessage(message: e.toString(), mode: MessageMode.error);
    }
  }

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
    final today = DateTime.now();
    try {
      final result = await _transaksiRepo.getTrxByThisPeriod();
      if (result.isNotEmpty) {
        _lstTodayTrx.addAll(result);

        // looping trx ini jika ada yang masih berstatus draf
        for (var item in _lstTodayTrx) {
          if (item.status == 'draft') {
            if (item.tanggal == today.toIso8601String()) {
              _currentTransaksi = item;
            } else {
              _lstPendingTrx.add(item);
            }
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
