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

  // =========inisialisasi provider=========
  Future<void> init() async {
    if (_initialized) return;
    _dataUsaha = await _masterDataRepo.getDataUsaha();
    _initialized = true;
    notifyListeners();
  }
}
