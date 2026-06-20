import 'package:flutter/material.dart';
import 'package:simplepos/services/utils/extension.dart';
import 'package:simplepos/ui/widget/reusable/public_widget.dart';

class DashboardTabpage extends StatefulWidget {
  const DashboardTabpage({super.key});

  @override
  State<DashboardTabpage> createState() => _DashboardTabpageState();
}

class _DashboardTabpageState extends State<DashboardTabpage> {
  @override
  Widget build(BuildContext context) {
    ThemeData tema = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Ringkasan Harian", style: tema.textTheme.titleLarge),
                Text(DateTime.now().toIndonesianDate(showDayName: true)),
              ],
            ),
          ),
          _summaryCard(
            tema,
            leadingIcon: Icon(Icons.payments_outlined, color: Colors.teal),
            title: 'Total Penjualan',
            child: Text(
              PublicWidget.toRupiah.format(1240000),
              style: tema.textTheme.titleLarge!.copyWith(fontSize: 30),
            ),
            trailling: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                "+ 12.5 %",
                style: tema.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          _summaryCard(
            tema,
            leadingIcon: Icon(Icons.receipt_long_outlined, color: Colors.amber),
            trailling: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                "84 Orders",
                style: tema.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            title: "Jumlah Transaksi",
            child: Text(
              "142",
              style: tema.textTheme.titleLarge!.copyWith(fontSize: 30),
            ),
          ),
          _summaryCard(
            tema,
            leadingIcon: Icon(Icons.insights_outlined, color: Colors.blue),
            title: "Rata-rata Transaksi",
            child: Text(
              PublicWidget.toRupiah.format(10500),
              style: tema.textTheme.titleLarge!.copyWith(fontSize: 30),
            ),
          ),
          _trendPenjualan(tema),
          _summaryCard(
            tema,
            leadingIcon: Icon(Icons.wallet_membership, color: Colors.indigo),
            title: "Riwayat Mutasi Saldo",
            trailling: Text("Lihat Semua"),
            child: Column(
              children: List.generate(5, (index) {
                return ListTile(
                  shape: RoundedRectangleBorder(side: BorderSide()),
                  title: Text("Jenis Mutasi $index"),
                  subtitle: Text("Header Transaksi $index"),
                  trailing: Text("Jlh Mutasi $index"),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Container _trendPenjualan(ThemeData tema) {
    return Container(
      margin: EdgeInsets.fromLTRB(12, 4, 12, 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black45, width: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Trend Penjualan", style: tema.textTheme.titleMedium),
              Container(
                // padding: EdgeInsets.all(4),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  border: Border.all(color: Colors.black45, width: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                      decoration: BoxDecoration(color: Colors.teal),
                      child: Text(
                        "Jam",
                        style: tema.textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                      decoration: BoxDecoration(color: null),
                      child: Text(
                        "Hari",
                        style: tema.textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(border: Border.all()),
            width: double.infinity,
            height: 300,
            child: Center(child: Text("Grafik")),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(
    ThemeData tema, {
    required Widget leadingIcon,
    Widget? trailling,
    required String title,
    required Widget child,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38, width: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal, width: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: leadingIcon,
              ),
              trailling ?? SizedBox(),
            ],
          ),
          SizedBox(height: 10),
          Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
          child,
        ],
      ),
    );
  }
}
