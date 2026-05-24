import 'package:flutter/widgets.dart';
import 'package:simplepos/data/database/dao/produk_dao.dart';
import 'package:simplepos/data/database/dao/usaha_dao.dart';
import 'package:simplepos/data/repository/masterdata_repo.dart';
import 'package:simplepos/models/data/produk_model.dart';
import 'package:simplepos/models/data/usaha_model.dart';

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

  // =========getter=========
  UsahaModel? get dataUsaha => _dataUsaha;
  List<ProdukModel> get daftarProduk => _daftarProduk;
  List<String> get daftarKategori => _daftarKategori;

  // =========setter==========
  void setUsahaData(UsahaModel data) {
    _dataUsaha = data;
    notifyListeners();
  }

  // =========inisialisasi provider=========
  Future<void> init() async {
    if (_initialized) return;
    // TODO: semua master load disini
    _daftarProduk = await _masterDataRepo.fetchAllProduk();
    _daftarKategori = await buildKategoriList();
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
}
