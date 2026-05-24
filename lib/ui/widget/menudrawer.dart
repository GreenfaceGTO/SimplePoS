import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplepos/models/menu_model.dart';
import 'package:simplepos/providers/master_provider.dart';
import 'package:simplepos/services/utils/cache_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simplepos/services/utils/constant.dart';
import 'package:simplepos/ui/widget/reusable/public_widget.dart';

class Menudrawer extends StatefulWidget with CacheManager {
  Menudrawer({super.key});

  @override
  State<Menudrawer> createState() => _MenudrawerState();
}

class _MenudrawerState extends State<Menudrawer> {
  final List<MenuModel> _lstMenu = [
    MenuModel(
      label: "Katalog Produk",
      icon: SvgPicture.asset("assets/svg/katalog.svg", width: 20, height: 20),
    ),
    MenuModel(
      label: "Stok Opname",
      icon: SvgPicture.asset("assets/svg/inventory.svg", width: 20, height: 20),
    ),
    MenuModel(
      label: "Pembelian",
      icon: SvgPicture.asset("assets/svg/purchase.svg", width: 20, height: 20),
    ),
  ];

  void onMenuTap(String menuName) {
    switch (menuName) {
      case "Katalog Produk":
        Navigator.pushNamed(context, rtMasterProduk);

        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    final mstProv = context.read<MasterProvider>();
    return Drawer(
      child: Column(
        children: [
          Stack(
            children: [
              _drawerHeader(mstProv, context),
              Positioned(
                top: 35,
                right: 5,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.edit_document, size: 18),
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _lstMenu.map((menu) {
                return ListTile(
                  visualDensity: VisualDensity.standard,
                  onTap: () {
                    onMenuTap(menu.label);
                  },
                  leading: menu.icon,
                  title: Text(menu.label),
                  trailing: Icon(Icons.chevron_right),
                );
              }).toList(),
            ),
          ),
          Divider(height: 3),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text("$appTitle - $appCRight"),
          ),
        ],
      ),
    );
  }

  SizedBox _drawerHeader(MasterProvider mstProv, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DrawerHeader(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            mstProv.dataUsaha!.logoToko != null
                ? Container(
                    width: 80,
                    height: 80,
                    clipBehavior: Clip.antiAlias,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // BorderRadius.circular(8),
                    ),
                    child: Image.file(
                      File(mstProv.dataUsaha!.logoToko!),
                      fit: BoxFit.cover,
                    ),
                  )
                : CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    maxRadius: 40,
                    child: Icon(
                      Icons.storefront,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
            PublicWidget.spasi(),
            Text(
              mstProv.dataUsaha!.namaUsaha!,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(mstProv.dataUsaha!.email!),
          ],
        ),
      ),
    );
  }
}
