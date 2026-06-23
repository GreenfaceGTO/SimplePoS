import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplepos/providers/transaksi_provider.dart';
import 'package:simplepos/services/utils/extension.dart';
import 'package:simplepos/ui/widget/reusable/public_widget.dart';
import 'package:simplepos/ui/widget/reusable/rowfield_element.dart';

class TransaksiBrowser extends StatefulWidget {
  const TransaksiBrowser({super.key});

  @override
  State<TransaksiBrowser> createState() => _TransaksiBrowserState();
}

class _TransaksiBrowserState extends State<TransaksiBrowser> {
  // final TransaksiRepo _transaksiRepo = TransaksiRepo();
  late TransaksiProvider _trxProv;
  // List<TransaksiModel> data = [];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _trxProv = Provider.of(context, listen: false);
      // data = await _transaksiRepo.getTrxByPeriod();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Data Transaksi")),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Consumer<TransaksiProvider>(
          builder: (context, prov, _) {
            return Column(
              children: prov.daftarTrxHariIni.map((trx) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      CustomRowField(
                        title: "ID:",
                        value: Text(trx.id.toString()),
                      ),
                      CustomRowField(
                        title: "Tanggal:",
                        value: Text(
                          DateTime.parse(trx.tanggal!).toIndonesianDate(),
                        ),
                      ),
                      CustomRowField(title: "Tipe:", value: Text(trx.tipe!)),
                      CustomRowField(
                        title: "Status:",
                        value: Text(trx.status!),
                      ),
                      CustomRowField(
                        title: "Total :",
                        value: Text(trx.total.toString()),
                      ),
                      Divider(),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Detail :"),
                      ),
                      Container(
                        constraints: BoxConstraints(minHeight: 40),
                        child: Column(
                          children: trx.lstDetail.map((dtl) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                title: Text(dtl.namaProduk!),
                                subtitle: Text(
                                  "Harga: ${PublicWidget.toRupiah.format(dtl.harga)}",
                                ),
                                trailing: Text(dtl.qty.toString()),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Divider(),
                      // IconButton(
                      //   onPressed: () {_transaksiRepo.deleteCart(data)},
                      //   icon: Icon(Icons.delete_forever),
                      // ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
