import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplepos/providers/transaksi_provider.dart';
import 'package:simplepos/services/utils/extension.dart';
import 'package:simplepos/ui/widget/reusable/rowfield_element.dart';

class PendinglistPage extends StatefulWidget {
  const PendinglistPage({super.key});

  @override
  State<PendinglistPage> createState() => _PendinglistPageState();
}

class _PendinglistPageState extends State<PendinglistPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Transaksi Tertunda")),
      body: Consumer<TransaksiProvider>(
        builder: (context, prov, _) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Column(
              children: prov.daftarPendingTrx.map((data) {
                return Container(
                  padding: EdgeInsets.all(8),
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
                          DateTime.parse(data.tanggal!).toIndonesianDate(),
                        ),
                      ),
                      CustomRowField(
                        title: "No. Transaksi:",
                        value: Text(data.id.toString().padLeft(6, "0")),
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
