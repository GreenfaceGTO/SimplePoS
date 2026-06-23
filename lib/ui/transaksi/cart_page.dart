import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplepos/models/data/itemtransaksi_model.dart';
import 'package:simplepos/providers/transaksi_provider.dart';
import 'package:simplepos/ui/widget/reusable/emptydata_element.dart';
import 'package:simplepos/ui/widget/reusable/public_widget.dart';
import 'package:simplepos/ui/widget/reusable/quantitystepper_element.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
  }

  // Menghitung total belanja
  double hitungTotalCart(TransaksiProvider trxProv) {
    double total = 0;
    for (var item in trxProv.currentTransaksi!.lstDetail) {
      total += (item.qty! * item.harga!);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Keranjang Belanja")),
      body: Consumer<TransaksiProvider>(
        builder: (context, prov, _) {
          return prov.currentTransaksi == null
              ? Center(child: EmptydataElement(caption: "Belum ada transaksi"))
              : Column(
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: SingleChildScrollView(
                          child: Column(
                            children: prov.currentTransaksi!.lstDetail.map((
                              dtl,
                            ) {
                              return _itemCard(dtl, prov, context);
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.black, width: 0.5),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Belanja:",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                PublicWidget.toRupiah.format(
                                  hitungTotalCart(prov),
                                ),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: SizedBox(
                                  height: 45,
                                  child: OutlinedButton.icon(
                                    onPressed: () {},
                                    label: Text("Pending"),
                                    icon: Icon(Icons.pending_actions),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                flex: 3,
                                child: SizedBox(
                                  height: 45,
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    label: Text("Checkout"),
                                    icon: Icon(
                                      Icons.shopping_cart_checkout_outlined,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }

  void deleteItem(
    BuildContext context,
    TransaksiProvider trxProv,
    ItemtransaksiModel data,
  ) async {
    bool delTransaksi = trxProv.currentTransaksi!.lstDetail.length == 1;

    final confirm =
        await confirmDelete(
          data.id!,
          delTransaksi
              ? Text(
                  "Menghapus item ${data.namaProduk!.trim()} ini akan membatalkan transaksi.\n",
                )
              : Text(
                  "Anda ingin menghapus item ${data.namaProduk!.trim()} ini?",
                ),
        ) ??
        false;

    if (confirm) {
      if (delTransaksi) {
        await trxProv.deleteCart();
        if (context.mounted) {
          Navigator.pop(context);
        }
      } else {
        await trxProv.delCartDetail(data);
      }
    }
    // }
  }

  Future<bool?> confirmDelete(int idDetail, Widget content) async {
    final result = await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("KONFIRMASI"),
          content: content,
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
    return result;
  }

  Container _itemCard(
    ItemtransaksiModel dtl,
    TransaksiProvider trxProv,
    BuildContext context,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey.shade300, width: 0.3),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: Offset(3, 3),
            blurRadius: 3,
            spreadRadius: 3,
          ),
        ],
      ),

      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  dtl.namaProduk!,
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                ),
              ),
              IconButton(
                onPressed: () {
                  deleteItem(context, trxProv, dtl);
                },
                icon: Icon(
                  Icons.delete_forever_outlined,
                  size: 18,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dtl.namaSatuan!),
              SizedBox(
                width: 100,
                child: QuantityStepper(
                  value: dtl.qty!,
                  tambah: () {},
                  kurang: () {},
                ),
              ),
            ],
          ),
          Divider(thickness: 0.8, color: Colors.black),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${PublicWidget.toRupiah.format(dtl.harga)} x ${dtl.qty}"),
              Text(
                PublicWidget.toRupiah.format(dtl.qty! * dtl.harga!),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
