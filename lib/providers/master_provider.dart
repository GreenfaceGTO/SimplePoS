import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:simplepos/data/database/dao/produk_dao.dart';
import 'package:simplepos/data/database/dao/usaha_dao.dart';
import 'package:simplepos/data/repository/masterdata_repo.dart';
import 'package:simplepos/models/data/mutasistok_model.dart';
import 'package:simplepos/models/data/produk_model.dart';
import 'package:simplepos/models/data/saldo_model.dart';
import 'package:simplepos/models/data/usaha_model.dart';
import 'package:simplepos/services/utils/constant.dart';
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
  List<SaldoModel> _daftarMutasiSaldo = [];

  // =========getter=========
  UsahaModel? get dataUsaha => _dataUsaha;
  List<ProdukModel> get daftarProduk => _daftarProduk;
  List<String> get daftarKategori => _daftarKategori;
  List<String> get daftarSatuan => _daftarSatuan;
  List<SaldoModel> get daftarMutasiSaldo => _daftarMutasiSaldo;

  // -------------------------------------
  // Mengambil data mutasi stok produk
  // -------------------------------------
  Future<List<MutasistokModel>> getMutasiStok({
    required int idProduk,
    required int tahun,
    required int bulan,
  }) async {
    try {
      log("$runtimeType: fetch saldo awal sebelum periode ini");
      // mengambil saldo akhir periode sebelumnya
      final saldoAwal = await _masterDataRepo.getSaldoAkhirLalu(
        tahun: tahun,
        bulan: bulan,
        idProduk: idProduk,
      );

      List<MutasistokModel> lstMutasi = [];
      // if (saldoAwal > 0) {}
      final periode = DateTime(tahun, bulan, 1);
      final tglSebelumnya = periode.subtract(Duration(days: 1));
      final namaBulanLalu = lstNamaBulan[tglSebelumnya.month - 1];
      log("$runtimeType: $namaBulanLalu");
      final mtsSaldo = MutasistokModel(
        tanggal: tglSebelumnya.toIso8601String(),
        keterangan:
            "SALDO AKHIR ${namaBulanLalu.toUpperCase()} ${tglSebelumnya.year}",
        idProduk: idProduk,
        qty: saldoAwal,
      );

      lstMutasi.add(mtsSaldo);

      log("$runtimeType: fetch mutasi stok");

      final lstData = await _masterDataRepo.getMutasiStok(
        idProduk: idProduk,
        tahun: tahun,
        bulan: bulan,
      );
      lstMutasi.addAll(lstData);
      return lstMutasi;
    } catch (e) {
      PublicWidget.showMessage(message: e.toString(), mode: MessageMode.error);
    }
    return [];
  }

  // ----------------------------------------
  // Mengambil data mutasi saldo periode ini
  // ----------------------------------------
  Future<void> getMutasiSaldo() async {
    try {
      final result = await _masterDataRepo.getMutasiSaldo();
      if (result.isEmpty) return;
      _daftarMutasiSaldo.addAll(result);
      notifyListeners();
    } catch (e) {
      PublicWidget.showMessage(message: e.toString(), mode: MessageMode.error);
    }
  }

  // ------------------------------------------------------------------------
  ///  mengupdate stok (lokal), [value] adalah nilai yang akan merubah stok
  /// jika [tambah]=true, maka akan ditambahkan, sebaliknya akan mengurangi
  // ------------------------------------------------------------------------
  void updateLocalStok(int itemId, int value, {bool tambah = false}) {
    for (var item in _daftarProduk) {
      if (item.id == itemId) {
        if (tambah) {
          log("step 2 [$runtimeType]: Tambah $value stok di local");
          item.stok = item.stok! + value;
        } else {
          log("step 2 [$runtimeType]: kurang $value stok di local");
          item.stok = item.stok! - value;
        }
      }
    }
    notifyListeners();
  }

  // set data usaha
  void setUsahaData(UsahaModel data) {
    _dataUsaha = data;
    notifyListeners();
  }

  // menambahkan kategori (lokal)
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

  // Menambahkan satuan (lokal)
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
