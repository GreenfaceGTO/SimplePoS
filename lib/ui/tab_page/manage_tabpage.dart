import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class ManageTabpage extends StatefulWidget {
  const ManageTabpage({super.key});

  @override
  State<ManageTabpage> createState() => _ManageTabpageState();
}

class _ManageTabpageState extends State<ManageTabpage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          visualDensity: VisualDensity(),
          onTap: () {},
          leading: Icon(Symbols.inventory_2),
          title: Text("Kelola Katalog"),
          // subtitle: Text("Tambah - Ubah - Hapus data produk"),
        ),
        ListTile(
          visualDensity: VisualDensity(),
          onTap: () {},
          leading: Icon(Symbols.shopping_basket),
          title: Text("Pembelian"),
          // subtitle: Text("Tambah - Ubah - Hapus data produk"),
        ),
        ListTile(
          visualDensity: VisualDensity(),
          onTap: () {},
          leading: Icon(Symbols.check_alert),
          title: Text("Stok Opname"),
          // subtitle: Text("Tambah - Ubah - Hapus data produk"),
        ),
      ],
    );
  }
}
