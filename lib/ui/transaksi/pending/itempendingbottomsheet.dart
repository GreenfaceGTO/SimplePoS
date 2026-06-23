import 'package:flutter/material.dart';
import 'package:simplepos/models/data/transaksi_model.dart';
import 'package:simplepos/services/utils/extension.dart';
import 'package:simplepos/ui/widget/reusable/public_widget.dart';

class Itempendingbottomsheet extends StatefulWidget {
  const Itempendingbottomsheet({super.key, required this.data});
  final TransaksiModel data;

  static Future<void> showDetail({
    required BuildContext context,
    required TransaksiModel data,
  }) => showModalBottomSheet(
    showDragHandle: true,
    isScrollControlled: true,
    context: context,
    builder: (ctx) => Itempendingbottomsheet(data: data),
  );

  @override
  State<Itempendingbottomsheet> createState() => _ItempendingbottomsheetState();
}

class _ItempendingbottomsheetState extends State<Itempendingbottomsheet> {
  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("DETAIL TRANSAKSI", style: tema.textTheme.titleLarge),
          Text(
            "No: ${widget.data.id.toString().padLeft(6, '0')}",
            style: tema.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          Text(
            "Tgl: ${DateTime.parse(widget.data.tanggal!).toIndonesianDate(withTime: true)}",
            style: tema.textTheme.bodyLarge,
          ),
          SizedBox(height: 20),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.data.lstDetail.map((dtl) {
              return ListTile(
                title: Text(dtl.namaProduk!),
                subtitle: Text(
                  "${dtl.qty} x @${PublicWidget.toRupiah.format(dtl.harga)}",
                ),
                trailing: Text(
                  PublicWidget.toRupiah.format(dtl.qty! * dtl.harga!),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
