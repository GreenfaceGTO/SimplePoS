import 'package:flutter/material.dart';
import 'package:simplepos/models/data/produk_model.dart';
import 'package:simplepos/models/data/produksat_model.dart';
import 'package:simplepos/ui/widget/reusable/public_widget.dart';

class Trxsatuanbottomsheet extends StatefulWidget {
  const Trxsatuanbottomsheet({super.key, required this.item});

  final ProdukModel item;

  static Future<ProdukSatModel?> selectSatuan({
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
  @override
  void initState() {
    lstSatuan = widget.item.lstSatuan!.map((e) => e).toList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Pilih Kemasan", style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.start,
              spacing: 8,
              runSpacing: 8,
              children: lstSatuan.map((sat) {
                return Material(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.blueGrey, width: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            sat.satuan!,
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                          Text("isi ${sat.isi}"),
                          Text(
                            PublicWidget.toRupiah.format(sat.hJual),
                            style: Theme.of(context).textTheme.titleSmall!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
