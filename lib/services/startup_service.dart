import 'dart:developer';

import 'package:simplepos/data/database/dao/usaha_dao.dart';
import 'package:simplepos/models/data/usaha_model.dart';
import 'package:simplepos/services/connectivity_service.dart';

enum AppStartRoute { intro, register, login, mainframe }

class AppStartUpService {
  final ConnectivityService connectivityService;
  AppStartUpService(this.connectivityService);

  Future<AppStartRoute> initializing() async {
    final hasConnection = await connectivityService.hasConnection();

    if (hasConnection) {
      final hasInternet = await connectivityService.hasInternet();
      if (hasInternet) {
        log("$runtimeType : Mengambil setting dari firebase...");
      } else {
        log("$runtimeType : 3. Ambil setting default...");
      }
    } else {
      log("$runtimeType : 3. Ambil setting default...");
    }

    log("$runtimeType : 4. Memeriksa dan mengambil data usaha...");
    UsahaDao usahaDao = UsahaDao();
    UsahaModel? usaha = await usahaDao.getDataUsaha();

    if (usaha == null) {
      log("$runtimeType : Belum ada data usaha, lanjut ke no 5.");
      return AppStartRoute.register;
    } else {
      log("$runtimeType : Ada data usaha, lanjut ke no 6.");

      log(usaha.toMap().toString());
      if (usaha.password != null) {
        return AppStartRoute.login;
      } else {
        return AppStartRoute.mainframe;
      }
    }
  }
}
