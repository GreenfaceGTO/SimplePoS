import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityService {
  /// Kelas untuk memeriksa apakah perangkat memiliki koneksi
  Future<bool> hasConnection() async {
    log("$runtimeType : Memeriksa koneksi perangkat...");
    var koneksi = await Connectivity().checkConnectivity();
    if (koneksi.isNotEmpty && koneksi.contains(ConnectivityResult.none)) {
      return false;
    }
    return true;
  }

  /// Kelas untuk memeriksa apakah perangkat terhubung ke internet
  Future<bool> hasInternet() async {
    log("$runtimeType : Memeriksa internet...");
    final internet = InternetConnectionChecker.createInstance(
      addresses: [AddressCheckOption(uri: Uri.parse("https://google.co.id"))],
    );

    bool konek = await internet.hasConnection;
    internet.dispose();
    return konek;
  }
}
