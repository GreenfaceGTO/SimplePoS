import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:simplepos/data/database/dao/produk_dao.dart';
import 'package:simplepos/data/database/dao/usaha_dao.dart';
import 'package:simplepos/data/repository/masterdata_repo.dart';
import 'package:simplepos/models/data/produk_model.dart';
import 'package:simplepos/models/data/usaha_model.dart';
import 'package:simplepos/services/utils/enums.dart';
import 'package:simplepos/ui/widget/reusable/public_widget.dart';

class MasterProvider with ChangeNotifier {
  final _masterDataRepo = MasterdataRepo(
    usahaDao: UsahaDao(),
    produkDao: ProdukDao(),
  );

  // =========deklarasi variabel=========
  bool _initialized = false;
  UsahaModel? _dataUsaha;
  List<ProdukModel> _daftarProduk = [];
  List<String> _daftarKategori = [];
  List<String> _daftarSatuan = [];

  // =========getter=========
  UsahaModel? get dataUsaha => _dataUsaha;
  List<ProdukModel> get daftarProduk => _daftarProduk;
  List<String> get daftarKategori => _daftarKategori;
  List<String> get daftarSatuan => _daftarSatuan;

  // =========================
  // REFERENSI SETTER
  // =========================
  void setUsahaData(UsahaModel data) {
    _dataUsaha = data;
    notifyListeners();
  }

  void addNewKategori(String value) {
    if (!_daftarKategori.contains(value)) {
      _daftarKategori.add(value);
      _daftarKategori.sort((a, b) => a.compareTo(b));
      notifyListeners();
    } else {
      PublicWidget.showMessage(
        message: "Kategori sudah ada",
        mode: MessageMode.error,
      );
    }
  }

  Future<bool> addNewSatuan(String value) async {
    if (!_daftarSatuan.contains(value)) {
      _daftarSatuan.add(value);
      _daftarSatuan.sort((a, b) => a.compareTo(b));
      notifyListeners();
      return true;
    } else {
      PublicWidget.showMessage(
        message: "Satuan sudah ada",
        mode: MessageMode.error,
      );
      return false;
    }
  }

  // =========inisialisasi provider=========
  Future<void> init() async {
    if (_initialized) return;
    _daftarProduk = await _masterDataRepo.fetchAllProduk();
    _daftarKategori = await buildKategoriList();

    _daftarSatuan = await buildSatuanList();
    _initialized = true;
    notifyListeners();
  }

  // ======== Memuat data usaha ==========
  Future<void> loadDataUsaha() async {
    _dataUsaha = await _masterDataRepo.getDataUsaha();
    notifyListeners();
  }

  // ====== Mengumpulkan tag kategori dari data produk ============
  Future<List<String>> buildKategoriList() async {
    List<String> result = [];
    for (var item in _daftarProduk) {
      var tag = item.tag;
      if (tag!.isNotEmpty) {
        for (var kat in tag) {
          if (!result.contains(kat)) {
            result.add(kat);
          }
        }
      }
    }
    return result;
  }

  // ========= Mengumpulkan data satuan dari data produk ==============
  Future<List<String>> buildSatuanList() async {
    List<String> result = [];
    for (var item in daftarProduk) {
      for (var sat in item.lstSatuan!) {
        if (!result.contains(sat.satuan)) {
          log("add satuan $sat");
          result.add(sat.satuan!);
        } else {
          log("skip satuan $sat");
        }
      }
    }
    return result;
  }

  // =========== Menambahkan produk ===========
  Future<bool> addNewProduk(ProdukModel newProduk) async {
    try {
      var result = await _masterDataRepo.addNewProduk(newProduk);
      _daftarProduk.add(result);
      notifyListeners();
      return true;
    } catch (e) {
      log(e.toString());
      PublicWidget.showMessage(message: e.toString(), mode: MessageMode.error);
    }
    return false;
  }

  // =========== Mengupdate produk =============
  Future<bool> updateProduk(ProdukModel updatedProduk) async {
    try {
      log("$runtimeType : ${updatedProduk.toMap().toString()}");
      final result = await _masterDataRepo.updateProduk(updatedProduk);
      int idx = _daftarProduk.indexWhere((e) => e.id == result.id);
      _daftarProduk[idx] = result;
      notifyListeners();
      return true;
    } catch (e) {
      log(e.toString());
      PublicWidget.showMessage(message: e.toString(), mode: MessageMode.error);
    }
    return false;
  }

  // ======= Menghapus produk ==========
  Future<void> deleteProduk(ProdukModel data) async {
    try {
      final result = await _masterDataRepo.delProduk(data);
      if (result) {
        _daftarProduk.removeWhere((e) => e.id == data.id);
        notifyListeners();
      }
    } catch (e) {
      PublicWidget.showMessage(message: e.toString(), mode: MessageMode.error);
    }
  }
}
