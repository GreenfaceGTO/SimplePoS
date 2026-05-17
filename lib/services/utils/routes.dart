import 'package:flutter/material.dart';
import 'package:simplepos/services/utils/constant.dart';
import 'package:simplepos/ui/dummy_page.dart';
import 'package:simplepos/ui/page/dashboard_page.dart';
import 'package:simplepos/ui/page/splashscreen_page.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    rtSplash: (_) => SplashscreenPage(),
    rtLogin: (_) => DummyPage(caption: "Login"),
    rtRegister: (_) => DummyPage(caption: "Register"),
    rtDashboard: (_) => DashboardPage(),
  };

  static Route<dynamic> generateRoute(RouteSettings setting) {
    final args = setting.arguments;
    switch (setting.name) {
      default:
        return MaterialPageRoute(
          builder: (_) => const DummyPage(caption: "Halaman tidak ditemukan"),
        );
    }
  }
}
