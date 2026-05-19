import 'package:flutter/foundation.dart';

class PortalProvider with ChangeNotifier {
  // ====== Loading Status =======
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
