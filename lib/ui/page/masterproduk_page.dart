import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplepos/providers/master_provider.dart';
import 'package:simplepos/ui/widget/reusable/emptydata_element.dart';

class MasterprodukPage extends StatefulWidget {
  const MasterprodukPage({super.key});

  @override
  State<MasterprodukPage> createState() => _MasterprodukPageState();
}

class _MasterprodukPageState extends State<MasterprodukPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Master Produk")),
      floatingActionButton: FloatingActionButton(
        heroTag: "masterproduk",
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: Consumer<MasterProvider>(
        builder: (context, prov, _) {
          return prov.daftarProduk.isEmpty
              ? Center(child: EmptydataElement())
              : ListView(
                  children: prov.daftarProduk.map((item) {
                    return ListTile(title: Text(item.namaProduk!));
                  }).toList(),
                );
        },
      ),
    );
  }
}
