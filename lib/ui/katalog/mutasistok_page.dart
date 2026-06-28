import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplepos/models/args_model.dart';
import 'package:simplepos/models/data/mutasistok_model.dart';
import 'package:simplepos/models/data/produk_model.dart';
import 'package:simplepos/providers/master_provider.dart';
import 'package:simplepos/services/utils/constant.dart';
import 'package:simplepos/services/utils/extension.dart';
import 'package:simplepos/ui/widget/reusable/public_widget.dart';

class MutasistokPage extends StatefulWidget {
  const MutasistokPage({super.key, required this.args});
  final ArgsModel args;

  @override
  State<MutasistokPage> createState() => _MutasistokPageState();
}

class _MutasistokPageState extends State<MutasistokPage> {
  late ProdukModel produk;
  List<MutasistokModel> lstMutasi = [];
  String? selectedMonth;
  String? selectedYear;

  @override
  void initState() {
    produk = widget.args.data as ProdukModel;
    final today = DateTime.now();
    selectedMonth = lstNamaBulan[today.month - 1];
    selectedYear = today.year.toString().substring(0, 4);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchData(today.year, today.month);
    });

    super.initState();
  }

  void fetchData(int year, int month) async {
    lstMutasi = await context.read<MasterProvider>().getMutasiStok(
      idProduk: produk.id!,
      tahun: year,
      bulan: month,
    );
    log(lstMutasi.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text("Mutasi Stok")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(produk.namaProduk!, style: tema.textTheme.titleMedium),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Satuan: ${produk.lstSatuan![0].satuan}"),
                if (produk.lstSatuan![0].barcode!.isNotEmpty)
                  Text("Barcode: ${produk.lstSatuan![0].barcode}"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              width: 200,
              child: TextFormField(
                controller: TextEditingController(
                  text: "$selectedMonth $selectedYear",
                ),
                decoration: InputDecoration(
                  label: Text("Periode"),
                  // border: InputBorder.none,
                  suffixIcon: IconButton(
                    onPressed: () async {
                      final result = await PublicWidget.customPeriodPicker(
                        context,
                        initial: DateTime.now(),
                      );
                      if (result != null) {
                        setState(() {
                          selectedMonth = lstNamaBulan[result.month - 1];
                          selectedYear = result.year.toString();
                        });
                        fetchData(
                          int.parse(selectedYear!),
                          lstNamaBulan.indexOf(selectedMonth!) + 1,
                        );
                      }
                    },
                    icon: Icon(
                      Icons.calendar_month,
                      size: 18,
                      color: tema.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(color: Colors.cyan.shade100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Stok Akhir:", style: tema.textTheme.titleSmall),
                Text(produk.stok.toString(), style: tema.textTheme.titleSmall),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              // color: Colors.red,
              width: double.infinity,
              child: DataTable(
                border: TableBorder(
                  verticalInside: BorderSide(color: Colors.black38, width: 0.3),
                  top: BorderSide(color: Colors.black38, width: 1),
                ),
                headingRowColor: WidgetStatePropertyAll(Colors.cyan.shade100),
                columnSpacing: 20,
                horizontalMargin: 16,
                columns: [
                  DataColumn(label: Text("Tanggal")),
                  DataColumn(label: Text("Keterangan")),
                  DataColumn(label: Text("Masuk"), numeric: true),
                  DataColumn(label: Text("Keluar"), numeric: true),
                  DataColumn(label: Text("Sisa"), numeric: true),
                ],
                rows: lstMutasi.map((mts) {
                  int sisa = 0;
                  if (lstMutasi.indexOf(mts) == 0) {
                    sisa = mts.qty!;
                  } else if (mts.pos == "IN") {
                    sisa = sisa + mts.qty!;
                  } else {
                    sisa = sisa - mts.qty!;
                  }
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          DateTime.parse(
                            mts.tanggal!,
                          ).toIndonesianDate(withTime: true),
                        ),
                      ),
                      DataCell(Text(mts.keterangan!)),
                      DataCell(
                        mts.pos == null || mts.pos == 'OUT'
                            ? Text("-")
                            : Text(mts.qty.toString()),
                      ),
                      DataCell(
                        mts.pos == null || mts.pos == 'IN'
                            ? Text("-")
                            : Text(mts.qty.toString()),
                      ),
                      DataCell(
                        Text(
                          sisa.toStringAsFixed(0),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
