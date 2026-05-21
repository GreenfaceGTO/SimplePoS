import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplepos/providers/main_provider.dart';
import 'package:simplepos/services/utils/constant.dart';
import 'package:simplepos/ui/widget/menudrawer.dart';

class MainframePage extends StatefulWidget {
  const MainframePage({super.key});

  @override
  State<MainframePage> createState() => _MainframePageState();
}

class _MainframePageState extends State<MainframePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(
      builder: (context, prov, _) {
        return Scaffold(
          drawer: Menudrawer(),
          appBar: AppBar(title: Text(appTitle)),

          body: IndexedStack(
            index: prov.currentPage,
            children: prov.lstMainPage.map((page) => page).toList(),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: prov.currentPage,
            onDestinationSelected: (val) {
              prov.setPage(val);
            },
            destinations: prov.lstBottomMenu
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
