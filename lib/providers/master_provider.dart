import 'package:flutter/widgets.dart';
import 'package:simplepos/data/database/dao/usaha_dao.dart';
import 'package:simplepos/data/repository/masterdata_repo.dart';
import 'package:simplepos/models/data/usaha_model.dart';

class MasterProvider with ChangeNotifier {
  final _masterDataRepo = MasterdataRepo(usahaDao: UsahaDao());

  // =========deklarasi variabel=========
  bool _initialized = false;
  UsahaModel? _dataUsaha;

  // =========getter=========
  UsahaModel? get dataUsaha => _dataUsaha;

  // =========setter==========
  void setUsahaData(UsahaModel data) {
    _dataUsaha = data;
    notifyListeners();
  }

  // =========inisialisasi provider=========
  Future<void> init() async {
    if (_initialized) return;
    // TODO: semua master load disini

    _initialized = true;
    notifyListeners();
  }

  Future<void> loadDataUsaha() async {
    _dataUsaha = await _masterDataRepo.getDataUsaha();
    notifyListeners();
  }
}
