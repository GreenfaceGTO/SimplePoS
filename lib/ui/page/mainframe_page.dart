import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:simplepos/models/args_model.dart';
import 'package:simplepos/models/menu_model.dart';
import 'package:simplepos/providers/main_provider.dart';
import 'package:simplepos/providers/master_provider.dart';
import 'package:simplepos/services/utils/constant.dart';
import 'package:simplepos/ui/tab_page/dashboard_tabpage.dart';
import 'package:simplepos/ui/tab_page/history_tabpage.dart';
import 'package:simplepos/ui/tab_page/produk_tabpage.dart';
import 'package:simplepos/ui/widget/menudrawer.dart';

class MainframePage extends StatefulWidget {
  const MainframePage({super.key, required this.args});
  final ArgsModel args;
  @override
  State<MainframePage> createState() => _MainframePageState();
}

class _MainframePageState extends State<MainframePage> {
  // ======Daftar Halaman Main======
  List<Widget> lstMainPage = [
    DashboardTabpage(),
    ProdukTabpage(),
    HistoryTabpage(),
    // ManageTabpage(),
  ];

  // ======Daftar menu bawah=======
  List<MenuModel> lstBottomMenu = [
    MenuModel(label: "Dashboard", icon: Icon(Symbols.dashboard_2)),
    MenuModel(label: "Produk", icon: Icon(Symbols.package_2)),
    MenuModel(label: "Riwayat", icon: Icon(Symbols.history_2)),
    // MenuModel(label: "Pengaturan", icon: Icon(Symbols.settings)),
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<MasterProvider>().loadDataUsaha();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(
      builder: (context, prov, _) {
        return Scaffold(
          drawer: Menudrawer(),
          appBar: AppBar(title: Text(appTitle), actions: [
           
            ],
          ),

          body: IndexedStack(
            index: prov.currentPage,
            children: lstMainPage.map((page) => page).toList(),
          ),

          bottomNavigationBar: NavigationBar(
            selectedIndex: prov.currentPage,
            onDestinationSelected: (val) {
              prov.setPage(val);
            },
            destinations: lstBottomMenu
                .map(
                  (menuTab) => NavigationDestination(
                    icon: menuTab.icon!,
                    label: menuTab.label,
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
