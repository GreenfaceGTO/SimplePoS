import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplepos/providers/master_provider.dart';
import 'package:simplepos/ui/widget/reusable/emptydata_element.dart';
import 'package:simplepos/ui/widget/reusable/public_widget.dart';
import 'package:simplepos/ui/widget/reusable/tagselector.dart';

class ProdukTabpage extends StatefulWidget {
  const ProdukTabpage({super.key});

  @override
  State<ProdukTabpage> createState() => _ProdukTabpageState();
}

class _ProdukTabpageState extends State<ProdukTabpage> {
  String? selectedTag;
  @override
  Widget build(BuildContext context) {
    ThemeData tema = Theme.of(context);

    return Consumer<MasterProvider>(
      builder: (context, prov, _) {
        return prov.daftarProduk.isEmpty
            ? Center(
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
              )
            : Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    height: 60,
                    child: Tagselector(
                      selectedTag: selectedTag,
                      tags: prov.daftarKategori,
                      onChange: (val) {
                        setState(() {
                          selectedTag = val;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      child: GridView.builder(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        itemCount: prov.daftarProduk.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 9 / 10,
                        ),
                        itemBuilder: (context, idx) {
                          final item = prov.daftarProduk[idx];
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.indigo.shade600,
                                width: 0.3,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.indigo.shade100,
                                  ),
                                  child: Text(
                                    item.namaProduk!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(color: Colors.indigo),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Column(
                                      children: item.lstSatuan!.map((sat) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("1 ${sat.satuan}"),
                                              Text(
                                                PublicWidget.toRupiah.format(
                                                  sat.hJual,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),

                                Container(
                                  height: 60,
                                  color: Colors.blueGrey.shade50,
                                  padding: EdgeInsets.only(left: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                          vertical: 4,
                                        ),
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black38,
                                            width: 0.3,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text("STOK"),
                                            Text(
                                              item.stok.toString(),
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleSmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.add_shopping_cart,
                                          size: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
      },
    );
  }
}
