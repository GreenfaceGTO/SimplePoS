import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplepos/providers/opname_provider.dart';
import 'package:simplepos/services/utils/extension.dart';
import 'package:simplepos/ui/katalog/opname/produkbrowser.dart';
import 'package:simplepos/ui/widget/reusable/emptydata_element.dart';
import 'package:simplepos/ui/widget/reusable/rowfield_element.dart';

class DaftaropnamePage extends StatefulWidget {
  const DaftaropnamePage({super.key});

  @override
  State<DaftaropnamePage> createState() => _DaftaropnamePageState();
}

class _DaftaropnamePageState extends State<DaftaropnamePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<OpnameProvider>(
      builder: (context, prov, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Stok Opname"),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.help_outline_outlined, size: 18),
              ),
            ],
          ),
          floatingActionButton: prov.daftarOpname.isEmpty
              ? null
              : prov.currentTask == null
              ? FloatingActionButton.extended(
                  onPressed: () {},
                  heroTag: "opname",
                  label: Text("Opname Baru"),
                  icon: Icon(Icons.add),
                )
              : null,
          body: prov.daftarOpname.isEmpty
              ? Center(child: belumAdaData(context))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: prov.daftarOpname.map((opn) {
                      bool currentTask =
                          prov.currentTask != null &&
                          opn.id == prov.currentTask!.id;

                      return Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: currentTask ? Colors.orange.shade50 : null,
                          border: Border.all(color: Colors.black38, width: 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomRowField(
                              title: "Tanggal:",
                              value: Text(
                                DateTime.parse(
                                  opn.tanggal!,
                                ).toIndonesianDate(withTime: true),
                              ),
                            ),
                            CustomRowField(
                              title: "Jlh. Produk:",
                              value: Text(opn.lstDetail!.length.toString()),
                            ),
                            if (prov.currentTask != null &&
                                opn.id == prov.currentTask!.id)
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomRowField(
                                    title: "Status:",
                                    value: Text("Belum Selesai"),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
        );
      },
    );
  }

  Widget belumAdaData(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        EmptydataElement(caption: "Belum ada riwayat opname"),
        SizedBox(height: 8),
        SizedBox(
          height: 45,
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProdukBrowser()),
              );
            },
            label: Text("Mulai Opname"),
          ),
        ),
      ],
    );
  }
}
