import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplepos/models/args_model.dart';
import 'package:simplepos/providers/master_provider.dart';
import 'package:simplepos/services/utils/constant.dart';
import 'package:simplepos/services/utils/enums.dart';
import 'package:simplepos/ui/widget/reusable/emptydata_element.dart';

class KatalogProdukPage extends StatefulWidget {
  const KatalogProdukPage({super.key});

  @override
  State<KatalogProdukPage> createState() => _KatalogProdukPageState();
}

class _KatalogProdukPageState extends State<KatalogProdukPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Katalog Produk")),
      floatingActionButton: FloatingActionButton(
        heroTag: "masterproduk",
        onPressed: () {
          Navigator.pushNamed(
            context,
            rtFormKatalogProduk,
            arguments: ArgsModel(formMode: FormMode.input),
          );
        },
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
