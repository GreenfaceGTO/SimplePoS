import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simplepos/models/data/itemtransaksi_model.dart';
import 'package:simplepos/models/data/produk_model.dart';
import 'package:simplepos/models/data/produksat_model.dart';
import 'package:simplepos/ui/widget/reusable/public_widget.dart';
import 'package:simplepos/ui/widget/reusable/quantitystepper_element.dart';

class Trxsatuanbottomsheet extends StatefulWidget {
  const Trxsatuanbottomsheet({super.key, required this.item});

  final ProdukModel item;

  static Future<ItemtransaksiModel?> selectSatuan({
    required BuildContext context,
    required ProdukModel item,
  }) {
    return showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,

      context: context,
      builder: (ctx) => Trxsatuanbottomsheet(item: item),
    );
  }

  @override
  State<Trxsatuanbottomsheet> createState() => _TrxsatuanbottomsheetState();
}

class _TrxsatuanbottomsheetState extends State<Trxsatuanbottomsheet> {
  late List<ProdukSatModel> lstSatuan;
  late List<int> lstQuantity;
  int selectedIndex = 0;
  bool itemTidakCukup = false;

  @override
  void initState() {
    lstSatuan = widget.item.lstSatuan!.map((e) => e).toList();
    lstQuantity = List.generate(lstSatuan.length, (ind) => 1);

    super.initState();
  }

  void increase() {
    lstQuantity[selectedIndex]++;

    setState(() {});
  }

  void decrease() {
    lstQuantity[selectedIndex]--;

    setState(() {});
  }

  void showErrorMessage() {
    setState(() {
      itemTidakCukup = true;
    });
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        itemTidakCukup = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.item.namaProduk!,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text("Pilih Kemasan", style: Theme.of(context).textTheme.bodyLarge),
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 8,
              children: lstSatuan.map((sat) {
                return _satuanCard(sat, context);
              }).toList(),
            ),
          ),
          if (itemTidakCukup)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                "Stok tidak mencukupi!",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          Divider(height: 30),
          SizedBox(
            height: 45,
            child: OutlinedButton.icon(
              onPressed: () {},
              label: Text("MASUKKAN KERANJANG"),
              icon: Icon(Icons.add_shopping_cart),
            ),
          ),
        ],
      ),
    );
  }

  Widget _satuanCard(ProdukSatModel sat, BuildContext context) {
    final subTotal = sat.hJual! * lstQuantity[lstSatuan.indexOf(sat)];

    return Container(
      clipBehavior: Clip.antiAlias,
      constraints: BoxConstraints(minHeight: 110, maxWidth: 120),
      decoration: BoxDecoration(
        // color: selectedIndex==lstSatuan.indexOf(sat)?Colors.grey.s:,
        border: Border.all(
          color: selectedIndex == lstSatuan.indexOf(sat)
              ? Colors.teal
              : Colors.grey.shade600,
          width: selectedIndex == lstSatuan.indexOf(sat) ? 1 : 0.3,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              if (sat.isi < widget.item.stok!) {
                setState(() {
                  selectedIndex = lstSatuan.indexOf(sat);
                });
              } else {
                showErrorMessage();
              }
            },
            child: Column(
              children: [
                Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.all(8),
                  color: selectedIndex == lstSatuan.indexOf(sat)
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade500,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        sat.satuan!,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        PublicWidget.toRupiah.format(sat.hJual),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Text(
                    PublicWidget.toRupiah.format(subTotal),
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: selectedIndex == lstSatuan.indexOf(sat)
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                  ),
                ),
                Divider(height: 2),
              ],
            ),
          ),
          QuantityStepper(
            disabled: selectedIndex != lstSatuan.indexOf(sat),
            value: lstQuantity[lstSatuan.indexOf(sat)],
            tambah: canIncrease(sat)
                ? () {
                    increase();
                  }
                : null,

            kurang: lstQuantity[lstSatuan.indexOf(sat)] > 1
                ? () {
                    decrease();
                  }
                : null,
          ),
        ],
      ),
    );
  }

  bool canIncrease(ProdukSatModel sat) {
    int idx = lstSatuan.indexOf(sat);
    if (sat.tipe == 'D') {
      return lstQuantity[idx] < widget.item.stok!;
    } else {
      return (lstQuantity[idx] * sat.isi) < widget.item.stok!;
    }
  }

  bool canDecrease(ProdukSatModel sat) {
    int idx = lstSatuan.indexOf(sat);
    if (sat.tipe == "D") {
      return lstQuantity[idx] > 1;
    } else {
      return lstQuantity[idx] > sat.isi;
    }
  }
}
