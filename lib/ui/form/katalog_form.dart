import 'package:flutter/material.dart';
import 'package:simplepos/models/args_model.dart';
import 'package:simplepos/services/utils/enums.dart';
import 'package:simplepos/ui/widget/reusable/emptydata_element.dart';
import 'package:simplepos/ui/widget/reusable/public_widget.dart';

class KatalogForm extends StatefulWidget {
  const KatalogForm({super.key, required this.args});
  final ArgsModel args;

  @override
  State<KatalogForm> createState() => _KatalogFormState();
}

class _KatalogFormState extends State<KatalogForm> {
  final TextEditingController txtNama = TextEditingController();
  final TextEditingController txtStok = TextEditingController();
  final TextEditingController txtBarcode = TextEditingController();
  final TextEditingController txtHpokok = TextEditingController();
  final TextEditingController txtHjual = TextEditingController();

  Widget spasi = PublicWidget.spasi();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    txtNama.dispose();
    txtStok.dispose();
    txtBarcode.dispose();
    txtHpokok.dispose();
    txtHjual.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData tema = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.args.formMode == FormMode.input
              ? "Produk Baru"
              : "Update Produk",
        ),
        actions: [
          IconButton(
            tooltip: "Simpan",
            onPressed: () {},
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: txtNama,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(label: Text("Nama Produk")),
                  onFieldSubmitted: (val) {
                    FocusScope.of(context).nextFocus();
                  },
                  validator: (val) {
                    if (val!.isEmpty) return "Wajib diisi";
                    return null;
                  },
                ),
                spasi,

                _satuanDasar(tema),
                spasi,
                TextFormField(
                  controller: txtBarcode,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    label: Text("Barcode"),
                    hintText: "Masukkan atau scan",
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.qr_code_scanner_outlined,
                        size: 18,
                        color: tema.primaryColor,
                      ),
                    ),
                  ),
                  onFieldSubmitted: (val) {
                    FocusScope.of(context).nextFocus();
                  },
                ),

                spasi,
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
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
                    PublicWidget.spasi(mode: OrientationMode.horizontal),
                    Expanded(
                      child: TextField(
                        controller: txtHjual,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(label: Text("Harga Jual")),
                      ),
                    ),
                  ],
                ),
                spasi,
                Container(
                  clipBehavior: Clip.antiAlias,
                  constraints: BoxConstraints(minHeight: 100),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54, width: 0.3),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 8,
                        ),
                        color: tema.primaryColor,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Kategori",
                                style: tema.textTheme.bodyLarge!.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.add_circle_outline,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Center(
                          child: EmptydataElement(
                            caption: "Belum ada Kategori",
                            iconSize: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                spasi,
                Divider(),
                spasi,
                _satuanLain(tema),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _satuanLain(ThemeData tema) {
    return Container(
      constraints: BoxConstraints(minHeight: 100),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54, width: 0.5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: tema.primaryColor,
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Satuan Lainnya",
                    style: tema.textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  icon: Icon(
                    Icons.add_circle_outline,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: EmptydataElement(
                iconSize: 30,
                caption: "Belum ada satuan lain",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row _satuanDasar(ThemeData tema) {
    return Row(
      children: [
        Expanded(
          flex: 7,
          child: Container(
            height: 48,
            padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton(
                    underline: SizedBox(),
                    isExpanded: true,
                    items: [],
                    onChanged: (val) {},
                    hint: Text(
                      "Satuan Dasar",
                      style: tema.textTheme.bodyLarge!.copyWith(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.add_circle_outline,
                    size: 18,
                    color: tema.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        PublicWidget.spasi(mode: OrientationMode.horizontal),
        Expanded(
          flex: 3,
          child: TextField(
            decoration: InputDecoration(label: Text("Stok Awal")),
          ),
        ),
      ],
    );
  }
}
