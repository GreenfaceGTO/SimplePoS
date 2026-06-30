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

  // --------------------------------
  // Mengupdate qty item detail
  // --------------------------------
  Future<void> updateTrxQty({
    required TransaksiModel trx,
    required ItemtransaksiModel detail,
    required int newValue,
  }) async {
    // log("step 3 [$runtimeType]: tambah $newValue di detail transaksi");
    // if (currentTransaksi!.id == trx.id) {
    //   int idx = _currentTransaksi!.lstDetail.indexWhere(
    //     (e) => e.id == detail.id,
    //   );
    //   detail.qty = detail.qty! + newValue;

    //   _currentTransaksi!.lstDetail[idx] = detail;
    //   // log("Qty sebelum ubah ${item.qty}");
    //   // log("akan ditambahkan $newValue");
    //   // item.qty = item.qty! + newValue;
    //   // log("Qty setelah ubah ${item.qty}");
    //   // log(
    //   //   "step 3 a : [$runtimeType] qty di currentTransaksi diupdate sejumlah ${item.qty}",
    //   // );
    //   // log("selengkapnya ${item.toMap()}");
    // }

    // // jika transaksi ada di daftar transaksi, ubah juga
    // if (daftarTrxHariIni.any((e) => e.id == trx.id)) {
    //   int idxh = daftarTrxHariIni.indexWhere((e) => e.id == trx.id);
    //   final dtTrx = daftarTrxHariIni[idxh];
    //   int idxd = dtTrx.lstDetail.indexWhere((e) => e.id == detail.id);
    //   final item = dtTrx.lstDetail[idxd];
    //   item.qty = item.qty! + newValue;
    // }
    // notifyListeners();
  }

  // -------------------------------
  // Menghapus detail transaksi
  // -------------------------------
  Future<void> delCartDetail(
    TransaksiModel transaksi,
    ItemtransaksiModel detail,
  ) async {
    final result = await _transaksiRepo.delCartDetail(transaksi, detail);

    if (!result) {
      return;
    }
    // hapus data di local
    _currentTransaksi!.lstDetail.removeWhere((e) => e.id == detail.id);

    // update total
    final subTotal = detail.qty! * detail.harga!;
    _currentTransaksi!.total = _currentTransaksi!.total! - subTotal;

    // update stok di master provider
    masterProvider.updateLocalStok(
      detail.idProduk!,
      detail.qty! * detail.isi!,
      tambah: true,
    );
    notifyListeners();
  }

  // -------------------------------------------
  /// Menambahkan item detail transaksi baru
  // -------------------------------------------
  Future<void> addNewDetailToCart(
    TransaksiModel transaksi,
    ItemtransaksiModel detail,
  ) async {
    try {
      final newTotal = transaksi.total! + (detail.qty! * detail.harga!);
      detail.idTransaksi = transaksi.id!;
      // log("$runtimeType: ${data.toMap()}");
      final result = await _transaksiRepo.addItemToCart(
        transaksi,
        detail,
        transaksi.total!,
      );

      // pastikan data sudah memiliki id
      detail.id ??= result.id;

      // periksa jika item yang akan ditambahkan sudah ada di daftar detail transaksi
      bool ada = transaksi.lstDetail.any((e) => e.idProduk == detail.idProduk);

      if (ada) {
        // item sudah ada, update jumlahnya
        final idxDetail = transaksi.lstDetail.indexWhere(
          (e) => e.idProduk == detail.idProduk,
        );
        final oldQty = transaksi.lstDetail[idxDetail].qty;
        final newQty = detail.qty! + oldQty!;
        transaksi.lstDetail[idxDetail].qty = newQty;
      } else {
        // item belum ada, tambahkan
        transaksi.lstDetail.add(result);
      }

      // update total transaksi
      _currentTransaksi!.total = newTotal;

      // updateStok
      masterProvider.updateLocalStok(
        detail.idProduk!,
        detail.qty! * detail.isi!,
      );
      notifyListeners();
    } catch (e) {
      log(e.toString());
      PublicWidget.showMessage(message: e.toString(), mode: MessageMode.error);
    }
  }

  // -------------------------------------------------------
  /// Menghapus transaksi dalam keranjang (status = draft)
  // -------------------------------------------------------
  Future<void> deleteCart(TransaksiModel data) async {
    try {
      final result = await _transaksiRepo.deleteCart(data);
      if (result) {
        // update stok local
        for (var detail in data.lstDetail) {
          masterProvider.updateLocalStok(
            detail.idProduk!,
            detail.qty! * detail.isi!,
            tambah: true,
          );
        }

        // jika data yang dikirim adalah transaksi aktif saat ini
        if (data.id == _currentTransaksi!.id) {
          _lstTodayTrx.removeWhere((e) => e.id == currentTransaksi!.id!);
          _currentTransaksi = null;
        } else {
          // periksa jika data yang dikirim adalah data pending
          final inPending = _lstPendingTrx.any((e) => e.id == data.id);
          if (inPending) {
            _lstPendingTrx.removeWhere((e) => e.id == data.id);
          } else {
            log("$runtimeType: message");
          }
        }
        notifyListeners();
      } else {
        log("$runtimeType: ${result.toString()}");
      }
    } catch (e) {
      PublicWidget.showMessage(message: e.toString(), mode: MessageMode.error);
    }
  }

  // ----------------------------------------------------------------------------------------------------
  /// Menambahkan transaksi baru, metode ini dipanggil hanya saat user menambahkan item pertama ke dalam keranjang. Untuk item selanjutnya menggunakan metode [addNewDetailToCart]
  // ----------------------------------------------------------------------------------------------------
  Future<bool> addNewTransaksi(ItemtransaksiModel firstItem) async {
    var total = firstItem.harga! * (firstItem.isi! * firstItem.qty!);

    final newTrx = TransaksiModel(
      tipe: 'jual',
      tanggal: DateTime.now().toIso8601String(),
      total: total,
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
          masterProvider.updateLocalStok(sat.idProduk!, sat.qty! * sat.isi!);
        }
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // -----------------------------------------------
  /// Mengambil seluruh data transaksi hari ini
  // -----------------------------------------------
  Future<void> loadTodayTransaksi() async {
    _setLoading(true);
    final today = DateTime.now();
    try {
      final result = await _transaksiRepo.getTrxByPeriod();
      if (result.isNotEmpty) {
        _lstTodayTrx.addAll(result);

        // looping daftar data transaksi untuk memeriksa jika masih ada yang berstatus draft.
        // Jika ada, dan tanggal draft sama dengan hari ini serta tidak ada transaksi yang sedang aktif  (currentTransaksi==null), jadikan draft tersebut sebagai transaksi saat ini.
        for (var item in _lstTodayTrx) {
          if (item.status == 'draft') {
            final tglData = DateTime.parse(item.tanggal!);
            final tglSama =
                tglData.year == today.year &&
                tglData.month == today.month &&
                tglData.day == today.day;

            if (tglSama) {
              _currentTransaksi ??= item;
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
