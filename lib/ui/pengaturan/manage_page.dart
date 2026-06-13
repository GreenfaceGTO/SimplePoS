import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:simplepos/services/utils/constant.dart';

class ManagePage extends StatefulWidget {
  const ManagePage({super.key});

  @override
  State<ManagePage> createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pengaturan")),
      body: ListView(
        children: [
          ListTile(
            visualDensity: VisualDensity(),
            onTap: () {},
            leading: Icon(Symbols.price_change),
            title: Text("Aturan Harga Produk"),
            // subtitle: Text("Tambah - Ubah - Hapus data produk"),
          ),
        ],
      ),
    );
  }
}
