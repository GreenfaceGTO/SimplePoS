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
  bool searchMode = false;
  final _txtSearchCtr = TextEditingController();

  @override
  void dispose() {
    _txtSearchCtr.dispose();
    super.dispose();
  }

  void deleteProduk(ProdukModel produk) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          contentTextStyle: Theme.of(context).textTheme.bodyLarge,
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
      if (mounted) {
        context.read<MasterProvider>().deleteProduk(produk);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mstProv = Provider.of<MasterProvider>(context);
    final query = _txtSearchCtr.text.trim().toLowerCase();
    final filteredItem = mstProv.daftarProduk.where((p) {
      final cocokNama = p.namaProduk!.toLowerCase().contains(query);
      final cocokBarcode = p.lstSatuan!.any(
        (sat) => sat.barcode!.contains(query),
      );
      return cocokNama || cocokBarcode;
    }).toList();

    ThemeData tema = Theme.of(context);

    return PopScope(
      canPop: !searchMode,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _txtSearchCtr.clear();
        searchMode = false;
        setState(() {});
      },
      child: Scaffold(
        appBar: AppBar(
          title: searchMode
              ? TextFormField(
                  controller: _txtSearchCtr,
                  autofocus: true,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: "Cari...",
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: _txtSearchCtr.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                _txtSearchCtr.clear();
                              });
                            },
                            icon: Icon(Icons.clear_rounded),
                          )
                        : null,
                  ),
                )
              : Text("Katalog Produk"),
          actions: [
            !searchMode
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        searchMode = !searchMode;
                      });
                    },
                    icon: Icon(Icons.search),
                  )
                : SizedBox(width: 16),
          ],
        ),
        floatingActionButton: searchMode
            ? null
            : FloatingActionButton(
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
        body: filteredItem.isEmpty
            ? Center(child: EmptydataElement(caption: "Tidak ada data"))
            :
              // list of product
              ListView(
                padding: EdgeInsets.symmetric(horizontal: 12),
                children: filteredItem.map((item) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      border: Border.all(color: Colors.teal, width: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 45,
                          child: Row(
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
                        ),
                        Divider(height: 3),
                        Row(
                          children: [
                            _satuanDasar(item, tema),
                            SizedBox(
                              height: 60,
                              child: VerticalDivider(
                                thickness: 0.5,
                                color: Colors.black26,
                              ),
                            ),
                            _stok(item, tema),
                          ],
                        ),
                        Divider(height: 3),
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _satuanLain(tema, item),
                              VerticalDivider(),
                              _kategori(tema, item),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
      ),
    );
  }

  Expanded _satuanLain(ThemeData tema, ProdukModel item) {
    return Expanded(
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
            item.lstSatuan!
                .skip(1)
                .map((e) => "${e.satuan} (${e.isi})")
                .whereType<String>()
                .join(', '),
          ),
        ],
      ),
    );
  }

  Expanded _kategori(ThemeData tema, ProdukModel item) {
    return Expanded(
      flex: 5,
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
          Text(item.tag!.map((e) => e).whereType<String>().join(', ')),
        ],
      ),
    );
  }

  Expanded _stok(ProdukModel item, ThemeData tema) {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text("Stok"),
          SizedBox(height: 4),
          Text(item.stok.toString(), style: tema.textTheme.titleSmall),
        ],
      ),
    );
  }

  Expanded _satuanDasar(ProdukModel item, ThemeData tema) {
    return Expanded(
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
            if (item.lstSatuan![0].barcode!.isNotEmpty)
              CustomRowField(
                title: "Barcode :",
                value: Text(
                  item.lstSatuan![0].barcode!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            CustomRowField(
              title: "Harga Pokok :",
              value: Text(
                PublicWidget.toRupiah.format(item.getSatuanDasar()!.hPokok),
              ),
            ),
            CustomRowField(
              title: "Harga Jual :",
              value: Text(
                PublicWidget.toRupiah.format(item.getSatuanDasar()!.hJual),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuButton<String> _popMenuProduk(ProdukModel produk) {
    return PopupMenuButton(
      onSelected: (val) {
        switch (val) {
          case "/hapus":
            deleteProduk(produk);

            break;
          case "/edit":
            Navigator.pushNamed(
              context,
              rtFormKatalogProduk,
              arguments: ArgsModel(
                formMode: FormMode.update,
                data: produk.copyWith(),
              ),
            );
            break;
          case "/mutasi":
            Navigator.pushNamed(
              context,
              rtMutasiStok,
              arguments: ArgsModel(formMode: FormMode.view, data: produk),
            );
            break;
          default:
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
