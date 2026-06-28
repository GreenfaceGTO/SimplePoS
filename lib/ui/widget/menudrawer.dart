import 'dart:io';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:simplepos/models/menu_model.dart';
import 'package:simplepos/providers/master_provider.dart';
import 'package:simplepos/services/utils/cache_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simplepos/services/utils/constant.dart';

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
    MenuModel(
      label: "Pengaturan",
      icon: SvgPicture.asset("assets/svg/settings.svg", width: 20, height: 20),
    ),
  ];
  bool isLogoFileExist = false;

  void onMenuTap(String menuName) {
    switch (menuName) {
      case "Katalog Produk":
        Navigator.pushNamed(context, rtMasterProduk);

        break;
      case "Pengaturan":
        Navigator.pushNamed(context, rtSettings);
      default:
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final dataUsaha = context.read<MasterProvider>().dataUsaha;
      if (dataUsaha != null) {
        if (dataUsaha.logoToko != null) {
          String pathFile = dataUsaha.logoToko!;
          isLogoFileExist = await File(pathFile).exists();
          setState(() {});
        }
      }
    });
    super.initState();
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
            isLogoFileExist
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
                : _defaultLogo(context, mstProv),
            SizedBox(height: 8),
            Text(
              mstProv.dataUsaha!.namaUsaha!,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              "ID: ${mstProv.dataUsaha!.kodeusaha!}",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stack _defaultLogo(BuildContext context, MasterProvider mstProv) {
    return Stack(
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          maxRadius: 40,
          child: Icon(Icons.storefront, size: 50, color: Colors.white),
        ),
        mstProv.dataUsaha!.logoToko != null
            ? Positioned(
                bottom: 5,
                right: 5,
                child: Icon(Symbols.info, color: Colors.yellow),
              )
            : SizedBox(),
      ],
    );
  }
}
