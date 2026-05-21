import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityService {
  /// Kelas untuk memeriksa apakah perangkat memiliki koneksi
  Future<bool> hasConnection() async {
    log("$runtimeType : 1. Memeriksa koneksi perangkat...");
    var koneksi = await Connectivity().checkConnectivity();
    if (koneksi.isNotEmpty && koneksi.contains(ConnectivityResult.none)) {
      log("$runtimeType : ada koneksi lanjut ke no 2.");
      return false;
    }
    log("$runtimeType : tidak ada koneksi lanjut ke no 3.");
    return true;
  }

  /// Kelas untuk memeriksa apakah perangkat terhubung ke internet
  Future<bool> hasInternet() async {
    log("$runtimeType : 2. Memeriksa internet...");
    final internet = InternetConnectionChecker.createInstance(
      addresses: [AddressCheckOption(uri: Uri.parse("https://google.co.id"))],
    );

    bool konek = await internet.hasConnection;
    internet.dispose();
    return konek;
  }
}
