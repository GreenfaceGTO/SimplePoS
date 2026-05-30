import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplepos/models/args_model.dart';
import 'package:simplepos/models/data/produk_model.dart';
import 'package:simplepos/providers/master_provider.dart';
import 'package:simplepos/services/utils/constant.dart';
import 'package:simplepos/services/utils/enums.dart';
import 'package:simplepos/ui/widget/reusable/emptydata_element.dart';
import 'package:simplepos/ui/widget/reusable/public_widget.dart';
import 'package:simplepos/ui/widget/reusable/rowfield_element.dart';

class KatalogProdukPage extends StatefulWidget {
  const KatalogProdukPage({super.key});

  @override
  State<KatalogProdukPage> createState() => _KatalogProdukPageState();
}

class _KatalogProdukPageState extends State<KatalogProdukPage> {
  void deleteProduk(ProdukModel produk) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Konfirmasi"),
          content: Text(
            "Yakin ingin menghapus produk ${produk.namaProduk} ini?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx, true);
              },
              child: Text("HAPUS"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx, false);
              },
              child: Text("BATAL"),
            ),
          ],
        );
      },
    );

    if (confirm != null && confirm) {
      log("Hapus");
    }
  }

  void showSatuanLain(ProdukSatModel satuan) async {
    return await showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Column(mainAxisSize: MainAxisSize.min),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData tema = Theme.of(context);
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
              : _listData(prov, tema);
        },
      ),
    );
  }

  ListView _listData(MasterProvider prov, ThemeData tema) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 12),
      children: prov.daftarProduk.map((item) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 4),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border.all(color: Colors.teal, width: 0.8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.namaProduk!,
                      style: tema.textTheme.titleSmall,
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _popMenuProduk(item),
                ],
              ),
              Divider(height: 3),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomRowField(
                            title: "Satuan Dasar :",
                            value: Text(
                              "${item.getSatuanDasar()!.satuan}",
                              style: tema.textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          CustomRowField(
                            title: "Harga Pokok :",
                            value: Text(
                              PublicWidget.toRupiah.format(
                                item.getSatuanDasar()!.hPokok,
                              ),
                            ),
                          ),
                          CustomRowField(
                            title: "Harga Jual :",
                            value: Text(
                              PublicWidget.toRupiah.format(
                                item.getSatuanDasar()!.hJual,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    child: VerticalDivider(
                      thickness: 0.5,
                      color: Colors.black26,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Stok"),
                        SizedBox(height: 4),
                        Text(
                          item.stok.toString(),
                          style: tema.textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Kategori :",
                          style: tema.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          item.tag!
                              .map((e) => e)
                              .whereType<String>()
                              .join(', '),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40, child: VerticalDivider()),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Satuan Lainnya :",
                          style: tema.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          item.lstSatuan
                              .map((e) => e.satuan)
                              .whereType<String>()
                              .join(', '),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  PopupMenuButton<String> _popMenuProduk(ProdukModel produk) {
    return PopupMenuButton(
      onSelected: (val) {
        if (val == "/mutasi") {
          log(produk.toMap().toString());
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: "/edit",
            child: ListTile(
              leading: Icon(Icons.edit, size: 18),
              title: Text("Edit"),
            ),
          ),
          PopupMenuItem(
            value: "/hapus",
            child: ListTile(
              leading: Icon(Icons.delete_forever, size: 18, color: Colors.red),
              title: Text("Hapus", style: TextStyle(color: Colors.red)),
            ),
          ),
          PopupMenuDivider(),
          PopupMenuItem(
            value: "/mutasi",
            child: ListTile(
              leading: Icon(Icons.traffic, size: 18),
              title: Text("Mutasi"),
            ),
          ),
        ];
      },
    );
  }
}
