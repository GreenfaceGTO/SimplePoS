import 'package:flutter/material.dart';
import 'package:simplepos/services/startup_service.dart';

class StartupProvider with ChangeNotifier {
  final AppStartUpService service;

  AppStartRoute? route;
  bool isLoading = true;

  StartupProvider(this.service) {
    init();
  }

  Future<void> init() async {
    route = await service.initializing();
    await Future.delayed(const Duration(seconds: 3));
    isLoading = false;
    notifyListeners();
  }
}
