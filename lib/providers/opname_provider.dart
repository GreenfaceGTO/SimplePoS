import 'package:flutter/widgets.dart';
import 'package:simplepos/data/repository/opname_repo.dart';
import 'package:simplepos/models/data/opname_model.dart';
import 'package:simplepos/models/data/produk_model.dart';
import 'package:simplepos/services/utils/enums.dart';
import 'package:simplepos/ui/widget/reusable/public_widget.dart';

class OpnameProvider with ChangeNotifier {
  OpnameRepo opnameRepo = OpnameRepo();

  List<OpnameModel> _lstHistoryOpname = [];
  List<OpnameModel> get daftarOpname => _lstHistoryOpname;

  OpnameModel? _currentTask;
  OpnameModel? get currentTask => _currentTask;

  // ---------------------
  // Membuat data opname
  // ---------------------
  Future<bool> createOpname(OpnameModel data) async {
    final result = await opnameRepo.createOpnameData(data);

    if (result != null && result.id != null) {
      _currentTask = result;
      _lstHistoryOpname.add(_currentTask!);
      notifyListeners();
      return true;
    } else {
      PublicWidget.showMessage(
        message: "Gagal membuat data opname",
        mode: MessageMode.error,
      );
    }
    return false;
  }

  // --------------------------------------
  /// Mengambil daftar item untuk dipilih
  // --------------------------------------
  Future<List<ProdukModel>> getAllitem() async {
    try {
      return await opnameRepo.fetchIraProduk();
    } catch (e) {
      PublicWidget.showMessage(message: e.toString());
    }
    return [];
  }

  // Future<void> createOpnameTask() async {
  //   try {
  //     final result = await opnameRepo.getCutOff();
  //     if (result != null) {
  //       _currentTask = result;
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     PublicWidget.showMessage(message: e.toString(), mode: MessageMode.error);
  //   }
  // }
}
