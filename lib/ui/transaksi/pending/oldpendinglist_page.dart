import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplepos/models/data/transaksi_model.dart';
import 'package:simplepos/providers/transaksi_provider.dart';
import 'package:simplepos/services/utils/extension.dart';
import 'package:simplepos/ui/transaksi/pending/itempendingbottomsheet.dart';
import 'package:simplepos/ui/widget/reusable/public_widget.dart';
import 'package:simplepos/ui/widget/reusable/rowfield_element.dart';

class OldpendinglistPage extends StatefulWidget {
  const OldpendinglistPage({super.key});

  @override
  State<OldpendinglistPage> createState() => _OldpendinglistPageState();
}

class _OldpendinglistPageState extends State<OldpendinglistPage> {
  // jendela konfirmasi hapus
  void deleteData(TransaksiProvider prov, TransaksiModel data) async {
    bool? result = await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("KONFIRMASI"),
          content: Text.rich(
            TextSpan(
              text: "Anda ingin menghapus transaksi nomor ",
              children: [
                TextSpan(
                  text: data.id.toString().padLeft(6, '0'),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(text: " senilai "),
                TextSpan(
                  text: PublicWidget.toRupiah.format(data.total),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(text: " ini ?"),
              ],
            ),
            style: TextStyle(fontSize: 14),
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
    if (result != null && result) {
      prov.deleteCart(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Transaksi Tunda Sebelumnya")),
      body: Consumer<TransaksiProvider>(
        builder: (context, prov, _) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Column(
              children: prov.daftarPendingTrx.map((data) {
                return Container(
                  padding: EdgeInsets.fromLTRB(12, 12, 12, 4),
                  margin: EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38, width: 0.3),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 3,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomRowField(
                        title: "Tanggal:",
                        value: Text(
                          DateTime.parse(
                            data.tanggal!,
                          ).toIndonesianDate(withTime: true),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      CustomRowField(
                        title: "No. Transaksi:",
                        value: Text(
                          data.id.toString().padLeft(6, "0"),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      CustomRowField(
                        title: "Jumlah Item:",
                        value: Text(
                          data.lstDetail.length.toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      CustomRowField(
                        title: "Total:",
                        value: Text(
                          PublicWidget.toRupiah.format(data.total),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Divider(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                IconButton(
                                  tooltip: "Detail",
                                  onPressed: () {
                                    Itempendingbottomsheet.showDetail(
                                      context: context,
                                      data: data,
                                    );
                                  },
                                  icon: Icon(Icons.list_alt, size: 18),
                                ),
                                IconButton(
                                  tooltip: "Bayar",
                                  onPressed: () {},
                                  icon: Icon(Icons.payment_outlined, size: 18),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: "Hapus",
                            onPressed: () {
                              deleteData(prov, data);
                            },
                            icon: Icon(
                              Icons.delete_forever_outlined,
                              color: Colors.red,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
