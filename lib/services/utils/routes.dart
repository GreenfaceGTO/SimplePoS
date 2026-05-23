import 'package:flutter/material.dart';
import 'package:simplepos/models/args_model.dart';
import 'package:simplepos/services/utils/constant.dart';
import 'package:simplepos/ui/dummy_page.dart';
import 'package:simplepos/ui/page/mainframe_page.dart';
import 'package:simplepos/ui/page/masterproduk_page.dart';
import 'package:simplepos/ui/page/register_page.dart';
import 'package:simplepos/ui/page/splashscreen_page.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    rtSplash: (_) => SplashscreenPage(),
    rtLogin: (_) => DummyPage(caption: "Login"),
    rtRegister: (_) => RegisterPage(),
    rtMasterProduk: (_) => MasterprodukPage(),
  };

  static Route<dynamic> generateRoute(RouteSettings setting) {
    final args = setting.arguments as ArgsModel;
    switch (setting.name) {
      case rtMainFrame:
        return MaterialPageRoute(builder: (_) => MainframePage(args: args));
      default:
        return MaterialPageRoute(
          builder: (_) => const DummyPage(caption: "Halaman tidak ditemukan"),
        );
    }
  }
}
