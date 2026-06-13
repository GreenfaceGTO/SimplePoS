import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplepos/models/data/produk_model.dart';
import 'package:simplepos/providers/master_provider.dart';
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

  @override
  void dispose() {
    _txtSearchCtr.dispose();
    super.dispose();
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
                          childAspectRatio: 8 / 10,
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
                      Text(
                        "1 ${item.lstSatuan![0].satuan}",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        PublicWidget.toRupiah.format(item.lstSatuan![0].hJual),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (item.lstSatuan![0].barcode != null)
                        Text(item.lstSatuan![0].barcode!),
                    ],
                  ),
                ),

                InkWell(
                  onTap: item.lstSatuan!.length > 1
                      ? () {
                          _showSatuanLain(item);
                        }
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Satuan Lainnya...",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: item.lstSatuan!.length > 1
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade500,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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

  void _showSatuanLain(ProdukModel item) async {
    return showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (ctx) {
        return Container(
          width: double.maxFinite,
          padding: EdgeInsets.fromLTRB(12, 0, 12, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Satuan Lain"),
              Text(
                item.namaProduk!,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Divider(),
              ...item.lstSatuan!.skipWhile((e) => e.tipe == "D").map((sat) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "1 ${sat.satuan!} (${sat.isi} ${item.lstSatuan![0].satuan})",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      Text(
                        PublicWidget.toRupiah.format(sat.hJual),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                );
              }),
              SizedBox(height: 16),
            ],
          ),
        );
      },
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
            onPressed: () {
              Trxsatuanbottomsheet.selectSatuan(context: context, item: item);
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
