import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:simplepos/providers/master_provider.dart';
import 'package:simplepos/ui/widget/reusable/emptydata_element.dart';

class ProdukTabpage extends StatefulWidget {
  const ProdukTabpage({super.key});

  @override
  State<ProdukTabpage> createState() => _ProdukTabpageState();
}

class _ProdukTabpageState extends State<ProdukTabpage> {
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
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 16,
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            label: Text("Cari..."),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: Icon(Symbols.search),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Center(child: Text("Kategori horizontal scroll")),
                  ),
                  Expanded(
                    child: SizedBox(
                      child: SingleChildScrollView(child: Column()),
                    ),
                  ),
                ],
              );
      },
    );
  }
}
