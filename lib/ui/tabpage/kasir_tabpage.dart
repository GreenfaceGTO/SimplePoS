import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplepos/models/data/produk_model.dart';
import 'package:simplepos/providers/master_provider.dart';
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
        return filteredProduct.isEmpty
            ? _emptyDataBody(tema)
            : Column(
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

                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.qr_code_scanner_outlined),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
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
                          childAspectRatio: 7 / 10,
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
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(color: Colors.indigo.shade100),
            child: Tooltip(
              message: "${item.id} ${item.namaProduk}",
              child: Text(
                "${item.id} ${item.namaProduk!}",
                style: Theme.of(
                  context,
                ).textTheme.titleSmall!.copyWith(color: Colors.indigo),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: item.lstSatuan!.map((sat) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${sat.id} ${sat.satuan}"),
                            Text(PublicWidget.toRupiah.format(sat.hJual)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text("Barcode")],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          _itemCardFooter(item, context),
        ],
      ),
    );
  }

  Container _itemCardFooter(ProdukModel item, BuildContext context) {
    return Container(
      height: 60,
      color: Colors.blueGrey.shade50,
      padding: EdgeInsets.only(left: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            padding: EdgeInsets.all(4),
            // decoration: BoxDecoration(
            //   border: Border.all(color: Colors.black38, width: 0.3),
            //   borderRadius: BorderRadius.circular(4),
            // ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("STOK"),
                Text(
                  item.stok.toString(),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.add_shopping_cart,
              // size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Center _emptyDataBody(ThemeData tema) {
    return Center(
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
    );
  }
}
