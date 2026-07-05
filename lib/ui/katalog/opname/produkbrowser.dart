import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplepos/models/data/itemopname_model.dart';
import 'package:simplepos/models/data/opname_model.dart';
import 'package:simplepos/models/data/produk_model.dart';
import 'package:simplepos/providers/opname_provider.dart';
import 'package:simplepos/services/utils/constant.dart';
import 'package:simplepos/ui/katalog/opname/opnamelistitem_page.dart';
import 'package:simplepos/ui/widget/reusable/emptydata_element.dart';

/// Halaman untuk menampilkan daftar produk pilihan untuk opname
class ProdukBrowser extends StatefulWidget {
  const ProdukBrowser({super.key});

  @override
  State<ProdukBrowser> createState() => _ProdukBrowserState();
}

class _ProdukBrowserState extends State<ProdukBrowser> {
  List<ProdukModel> selectedItems = [];
  List<ProdukModel> lstProduk = [];
  bool loading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final result = await Provider.of<OpnameProvider>(
        context,
        listen: false,
      ).getAllitem();
      lstProduk.addAll(result);
      loading = false;
      setState(() {});
    });
    super.initState();
  }

  void generateIraData() async {
    List<ItemopnameModel> detail = [];
    for (var element in selectedItems) {
      detail.add(ItemopnameModel.fromProduk(element));
    }

    log(detail.map((e) => e.toMap().toString()).toList().toString());
    final data = OpnameModel(
      tanggal: DateTime.now().toIso8601String(),
      lstDetail: detail,
    );
    final result = await context.read<OpnameProvider>().createOpname(data);
    if (result && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OpnamelistitemPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pilih Produk"),
        actions: [
          if (selectedItems.isNotEmpty)
            TextButton.icon(
              iconAlignment: IconAlignment.end,
              onPressed: () {
                generateIraData();
              },
              label: Text("MULAI HITUNG"),
              icon: Icon(Icons.start),
            ),
        ],
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : (lstProduk.isEmpty
                ? Center(child: EmptydataElement())
                : Column(
                    children: [
                      if (lstProduk.length > 10)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Cari...",
                                  prefixIcon: Icon(Icons.search),
                                ),
                              ),
                            ),
                            Divider(),
                          ],
                        ),

                      ...lstProduk.map((item) {
                        return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          value: selectedItems.contains(item),
                          onChanged: (val) {
                            if (val!) {
                              setState(() {
                                selectedItems.add(item);
                              });
                            } else {
                              log("remove from selected");
                              setState(() {
                                selectedItems.removeWhere((e) => e == item);
                              });
                            }
                          },
                          title: Text(item.namaProduk!),
                        );
                      }),
                    ],
                  )),
    );
  }
}
