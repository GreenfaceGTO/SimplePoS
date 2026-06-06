import 'package:flutter/material.dart';
import 'package:simplepos/models/data/produk_model.dart';
import 'package:simplepos/models/data/produksat_model.dart';

class Hargasatuanbottomsheet extends StatefulWidget {
  const Hargasatuanbottomsheet({
    super.key,
    required this.produk,
    required this.idSatuan,
  });
  final ProdukModel produk;
  final int idSatuan;

  static Future<ProdukSatModel?> show({
    required BuildContext context,
    required ProdukModel produk,
    required int idSatuan,
  }) {
    return showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) =>
          Hargasatuanbottomsheet(produk: produk, idSatuan: idSatuan),
    );
  }

  @override
  State<Hargasatuanbottomsheet> createState() => _HargasatuanbottomsheetState();
}

class _HargasatuanbottomsheetState extends State<Hargasatuanbottomsheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController txtHpokok;
  late final TextEditingController txtHjual;
  late ProdukSatModel dtSatuan;
  late String title;

  @override
  void initState() {
    super.initState();

    int idx = widget.produk.lstSatuan!.indexWhere(
      (e) => e.id == widget.idSatuan,
    );
    dtSatuan = widget.produk.lstSatuan![idx].copyWith();

    if (dtSatuan.tipe == 'D') {
      title = "Ubah Harga Satuan Dasar";
    } else {
      title = "Ubah Harga Satuan Lain";
    }

    txtHpokok = TextEditingController(
      text: dtSatuan.hPokok!.toStringAsFixed(0),
    );
    txtHjual = TextEditingController(text: dtSatuan.hJual!.toStringAsFixed(2));
  }

  @override
  void dispose() {
    txtHpokok.dispose();
    txtHjual.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    dtSatuan.hPokok = double.parse(txtHpokok.text);
    dtSatuan.hJual = double.parse(txtHjual.text);
    Navigator.pop(context, dtSatuan);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData tema = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        12,
        0,
        12,
        MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: tema.textTheme.titleMedium),
            SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    autofocus: true,
                    controller: txtHpokok,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(label: Text("Harga Pokok")),
                    validator: (val) {
                      if (val!.isEmpty) return "Wajib diisi";
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: txtHjual,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(label: Text("Harga Jual")),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Wajib diisi";
                      } else if (double.parse(txtHjual.text) <
                          double.parse(txtHpokok.text)) {
                        return "Harga jual lebih kecil";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 45,
                  child: TextButton(
                    onPressed: () {
                      _submit();
                    },
                    child: Text("SIMPAN"),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
