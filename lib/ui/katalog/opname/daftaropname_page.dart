import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplepos/providers/opname_provider.dart';
import 'package:simplepos/services/utils/extension.dart';
import 'package:simplepos/ui/katalog/opname/opnamelistitem_page.dart';
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
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<OpnameProvider>().loadData();
    });
    super.initState();
  }

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
                      final progress = opn.progress();
                      log(opn.toMap().toString());
                      return Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: currentTask
                              ? Theme.of(context).primaryColorLight
                              : null,
                          border: Border.all(
                            color: Colors.orange.shade500,
                            width: 0.3,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: currentTask
                              ? [
                                  BoxShadow(
                                    blurRadius: 5,
                                    offset: Offset(1, 3),
                                    color: Colors.black26,
                                  ),
                                ]
                              : null,
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
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),

                            if (prov.currentTask != null &&
                                opn.id == prov.currentTask!.id)
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomRowField(
                                    title: "Kemajuan:",
                                    value: Text(
                                      "${progress['complete']}/${opn.lstDetail!.length}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  CustomRowField(
                                    title: "Status:",
                                    value: Text(
                                      "Belum selesai",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  SizedBox(
                                    height: 45,
                                    child: OutlinedButton.icon(
                                      iconAlignment: IconAlignment.end,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OpnamelistitemPage(),
                                          ),
                                        );
                                      },
                                      label: Text("LANJUTKAN"),
                                      icon: Icon(Icons.arrow_forward),
                                    ),
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
