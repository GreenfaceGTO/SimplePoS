import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:simplepos/models/args_model.dart';
import 'package:simplepos/models/menu_model.dart';
import 'package:simplepos/providers/main_provider.dart';
import 'package:simplepos/providers/master_provider.dart';
import 'package:simplepos/providers/transaksi_provider.dart';
import 'package:simplepos/services/utils/constant.dart';
import 'package:simplepos/ui/tabpage/dashboard_tabpage.dart';
import 'package:simplepos/ui/tabpage/history_tabpage.dart';
import 'package:simplepos/ui/tabpage/kasir_tabpage.dart';
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
    KasirTabpage(),
    HistoryTabpage(),
    // ManageTabpage(),
  ];

  // ======Daftar menu bawah=======
  List<MenuModel> lstBottomMenu = [
    MenuModel(label: "Dashboard", icon: Icon(Symbols.dashboard_2)),
    MenuModel(label: "Kasir", icon: Icon(Symbols.point_of_sale)),
    MenuModel(label: "Riwayat", icon: Icon(Symbols.history_2)),
    // MenuModel(label: "Pengaturan", icon: Icon(Symbols.settings)),
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<MasterProvider>().loadDataUsaha();
      context.read<MasterProvider>().getMutasiSaldo();

      context.read<TransaksiProvider>().loadTodayTransaksi();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final trxProv = Provider.of<TransaksiProvider>(context);

    return Consumer<MainProvider>(
      builder: (context, prov, _) {
        return Scaffold(
          drawer: Menudrawer(),
          appBar: AppBar(
            title: Text(appTitle),
            actions: [
              // pending buket

              // cart belanja
              if (prov.currentPage == 1)
                Consumer<TransaksiProvider>(
                  builder: (context, trxProv, _) {
                    return Row(
                      children: [
                        if (trxProv.daftarPendingTrx.isNotEmpty)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Badge(
                                alignment: Alignment.topLeft,
                                offset: Offset(-5, 0),
                                label: Text(
                                  trxProv.daftarPendingTrx.length.toString(),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, rtPendingPage);
                                  },
                                  child: Icon(Icons.pending_actions),
                                ),
                              ),
                              SizedBox(width: 8),
                            ],
                          ),
                        Badge(
                          alignment: Alignment.topRight,
                          offset: Offset(-8, 10),
                          label: trxProv.currentTransaksi == null
                              ? null
                              : Text(
                                  trxProv.currentTransaksi!.lstDetail.length
                                      .toString(),
                                ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, rtCartPage);
                            },
                            icon: Icon(Icons.shopping_cart, size: 18),
                          ),
                        ),
                      ],
                    );
                  },
                ),
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
