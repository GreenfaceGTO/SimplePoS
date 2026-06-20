import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplepos/models/data/itemtransaksi_model.dart';
import 'package:simplepos/models/data/produk_model.dart';
import 'package:simplepos/providers/master_provider.dart';
import 'package:simplepos/providers/transaksi_provider.dart';
import 'package:simplepos/ui/transaksi/trxsatuanbottomsheet.dart';
import 'package:simplepos/ui/widget/reusable/emptydata_element.dart';
import 'package:simplepos/ui/widget/reusable/public_widget.dart';

class KasirTabpage extends StatefulWidget {
  const KasirTabpage({super.key});

  @override
  State<KasirTabpage> createState() => _KasirTabpageState();
}

class _KasirTabpageState extends State<KasirTabpage> {
  final _txtSearchCtr = TextEditingController();
  late TransaksiProvider trxProv;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      trxProv = Provider.of<TransaksiProvider>(context, listen: false);
    });
    super.initState();
  }

  @override
  void dispose() {
    _txtSearchCtr.dispose();
    super.dispose();
  }

  Future<void> newItemAdded(ItemtransaksiModel newDetail) async {
    // final trxProv = Provider.of<TransaksiProvider>(context);
    log("$runtimeType : ${newDetail.toMap().toString()}");
    if (trxProv.currentTransaksi == null) {
      if (await trxProv.addNewTransaksi(newDetail)) {
        PublicWidget.showMessage(
          message:
              "${newDetail.qty} item ${newDetail.namaProduk} ditambahkan ke keranjang",
        );
      }
    } else {
      log("$runtimeType : Tambahkan detail pada current transaksi");
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData tema = Theme.of(context);

    final masterProv = Provider.of<MasterProvider>(context);
    final querySearch = _txtSearchCtr.text.trim().toLowerCase();

    final filteredProduct = masterProv.daftarProduk.where((p) {
      final cocokNama = p.namaProduk!.toLowerCase().contains(querySearch);
      final cocokbarcode = p.lstSatuan!.any(
        (sat) => sat.barcode!.contains(querySearch),
      );

      return cocokNama || cocokbarcode;
    }).toList();

    return Consumer<MasterProvider>(
      builder: (context, prov, _) {
        return Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              height: 60,
              child: TextFormField(
                controller: _txtSearchCtr,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: "Cari...",
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: _txtSearchCtr.text.isEmpty
                      ? IconButton(
                          onPressed: () async {
                            String? scanedBarcode =
                                await PublicWidget.scanBarcode(context);
                            if (scanedBarcode != null) {
                              setState(() {
                                _txtSearchCtr.text = scanedBarcode;
                              });
                            }
                          },
                          icon: Icon(Icons.qr_code_scanner_outlined, size: 18),
                        )
                      : IconButton(
                          onPressed: () {
                            _txtSearchCtr.clear();
                            setState(() {});
                          },
                          icon: Icon(Icons.clear_rounded),
                        ),
                ),
              ),
            ),
            filteredProduct.isEmpty
                ? _emptyDataBody(tema)
                : Expanded(
                    child: SizedBox(
                      child: GridView.builder(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        itemCount: filteredProduct.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 8 / 9,
                        ),
                        itemBuilder: (context, idx) {
                          final item = filteredProduct[idx];

                          // prov.daftarProduk[idx];
                          return _itemCard(item, context);
                        },
                      ),
                    ),
                  ),
          ],
        );
      },
    );
  }

  Container _itemCard(ProdukModel item, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.indigo.shade600, width: 0.3),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: Tooltip(
              message: "${item.namaProduk}",
              child: Text(
                item.namaProduk!,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ),
          ),
          SizedBox(height: 4),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (item.lstSatuan![0].barcode != null)
                        Text(
                          item.lstSatuan![0].barcode!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      Text(
                        PublicWidget.toRupiah.format(item.lstSatuan![0].hJual),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        "/${item.lstSatuan![0].satuan!.toUpperCase()}",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1),

          _itemCardFooter(item, context),
        ],
      ),
    );
  }

  Container _itemCardFooter(ProdukModel item, BuildContext context) {
    return Container(
      // height: 60,
      color: Colors.blueGrey.shade50,
      padding: EdgeInsets.only(left: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            padding: EdgeInsets.all(4),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "STOK",
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  item.stok.toString(),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              final result = await Trxsatuanbottomsheet.selectSatuan(
                context: context,
                item: item,
              );
              if (result != null) {
                // log("$runtimeType : ${result.toMap().toString()}");
                newItemAdded(result);
              }
            },
            icon: Icon(Icons.add_shopping_cart, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _emptyDataBody(ThemeData tema) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            EmptydataElement(),
            SizedBox(height: 8),
            Text(
              "Kelola produk dari menu Katalog Produk",
              style: tema.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
