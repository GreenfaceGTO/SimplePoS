import 'package:flutter/material.dart';
import 'package:simplepos/models/args_model.dart';
import 'package:simplepos/models/data/produksat_model.dart';
import 'package:simplepos/services/utils/constant.dart';
import 'package:simplepos/ui/dummy_page.dart';
import 'package:simplepos/ui/katalog/katalog_form.dart';
import 'package:simplepos/ui/pengaturan/manage_page.dart';
import 'package:simplepos/ui/ref/satuan_form.dart';
import 'package:simplepos/ui/mainframe_page.dart';
import 'package:simplepos/ui/katalog/katalogproduk_page.dart';
import 'package:simplepos/ui/portal/register_page.dart';
import 'package:simplepos/ui/portal/splashscreen_page.dart';
import 'package:simplepos/ui/transaksi/cart_page.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    rtSplash: (_) => SplashscreenPage(),
    rtLogin: (_) => DummyPage(caption: "Login"),
    rtRegister: (_) => RegisterPage(),
    rtMasterProduk: (_) => KatalogProdukPage(),
    rtSettings: (_) => ManagePage(),
    rtCartPage: (_) => CartPage(),
  };

  static Route<dynamic> generateRoute(RouteSettings setting) {
    final args = setting.arguments as ArgsModel;
    switch (setting.name) {
      case rtMainFrame:
        return MaterialPageRoute(builder: (_) => MainframePage(args: args));
      case rtFormKatalogProduk:
        return MaterialPageRoute(builder: (_) => KatalogForm(args: args));
      case rtFormSatuan:
        return MaterialPageRoute<ProdukSatModel?>(
          builder: (_) => SatuanForm(args: args),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const DummyPage(caption: "Halaman tidak ditemukan"),
        );
    }
  }
}
