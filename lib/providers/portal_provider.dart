import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:simplepos/data/database/dao/usaha_dao.dart';
import 'package:simplepos/data/repository/masterdata_repo.dart';
import 'package:simplepos/models/data/usaha_model.dart';
import 'package:simplepos/services/utils/enums.dart';
import 'package:simplepos/ui/widget/reusable/public_widget.dart';

class PortalProvider with ChangeNotifier {
  final MasterdataRepo _masterdataRepo = MasterdataRepo(usahaDao: UsahaDao());
  // ====== Loading Status =======
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // ======Submit Register Usaha======
  Future<bool> submitRegister(UsahaModel dataUsaha) async {
    setLoading(true);
    try {
      await _masterdataRepo.saveDataUsaha(dataUsaha);
      return true;
    } catch (e) {
      log("$runtimeType Error : $e");
      PublicWidget.showMessage(message: e.toString(), mode: MessageMode.error);
    } finally {
      setLoading(false);
    }
    return false;
  }
}
