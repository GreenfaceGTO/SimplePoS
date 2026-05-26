import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:simplepos/models/args_model.dart';
import 'package:simplepos/models/data/produk_model.dart';
import 'package:simplepos/services/utils/constant.dart';
import 'package:simplepos/services/utils/enums.dart';
import 'package:simplepos/services/utils/inputformater.dart';
import 'package:simplepos/ui/page/kategori_page.dart';
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

  ProdukSatModel? satDasar;
  List<String> lstKategori = [];

  Widget spasi = PublicWidget.spasi();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    txtNama.dispose();
    super.dispose();
  }

  void deleteKategori(String kat) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Konfirm"),
          content: Text(
            "Kategori $kat ingin dihapus?",
            style: Theme.of(ctx).textTheme.bodyLarge,
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
    if (confirm != null && confirm) {
      setState(() {
        lstKategori.removeWhere((e) => e == kat);
      });
    }
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
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38, width: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Informasi Umum", style: tema.textTheme.titleMedium),
                      spasi,
                      spasi,
                      TextFormField(
                        controller: txtNama,
                        onChanged: (val) {
                          setState(() {});
                        },
                        inputFormatters: [CapitalizeEachWord()],
                        decoration: InputDecoration(
                          label: Text("Nama Produk"),
                          hintText: "Masukkan nama produk",
                        ),
                      ),
                      spasi,
                      _tagKategori(tema),
                    ],
                  ),
                ),
                spasi,
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38, width: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Satuan & Harga", style: tema.textTheme.titleMedium),
                      spasi,
                      spasi,
                      satDasar == null
                          ? SizedBox(
                              height: 45,
                              child: OutlinedButton.icon(
                                onPressed: txtNama.text.isNotEmpty
                                    ? () {
                                        Navigator.pushNamed(
                                          context,
                                          rtFormSatuan,
                                          arguments: ArgsModel(
                                            formMode: FormMode.input,
                                            data: {
                                              "nama_item": txtNama.text,
                                              "sat_dasar": null,
                                            },
                                          ),
                                        );
                                      }
                                    : null,
                                label: Text("Satuan Dasar"),
                                icon: Icon(Icons.add),
                              ),
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [Text("Satuan Lain")],
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _tagKategori(ThemeData tema) {
    return Container(
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
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black45, width: 0.3),
              ),
            ),
            // color: tema.primaryColorLight,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Kategori",
                    style: tema.textTheme.bodyLarge!.copyWith(
                      // color: Colors.white,
                      fontWeight: FontWeight.w700,
                      // color: Colors.black87,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    List<String>? kat = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => KategoriPage(currentTag: lstKategori),
                      ),
                    );
                    if (kat != null) {
                      setState(() {
                        lstKategori.clear();
                        lstKategori.addAll(kat);
                      });
                    }
                  },
                  icon: Icon(
                    Symbols.browse,
                    size: 18,
                    color: tema.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: lstKategori.isEmpty
                ? Center(
                    child: EmptydataElement(
                      caption: "Belum ada Kategori",
                      iconSize: 30,
                    ),
                  )
                : SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.start,
                      children: lstKategori.map((kat) {
                        return InputChip(
                          label: Text(kat),
                          onDeleted: () {
                            deleteKategori(kat);
                          },
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
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

  // Row _satuanDasar(ThemeData tema) {
  //   return Row(
  //     children: [
  //       Expanded(
  //         flex: 7,
  //         child: Container(
  //           height: 48,
  //           padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
  //           decoration: BoxDecoration(
  //             border: Border.all(color: Colors.black54),
  //             borderRadius: BorderRadius.circular(4),
  //           ),
  //           child: Row(
  //             children: [
  //               Expanded(
  //                 child: Consumer<MasterProvider>(
  //                   builder: (context, prov, _) {
  //                     return DropdownButton(
  //                       value: satDasar,
  //                       underline: SizedBox(),
  //                       isExpanded: true,
  //                       items: prov.daftarSatuan.map((sat) {
  //                         return DropdownMenuItem(
  //                           child: ListTile(title: Text(sat)),
  //                         );
  //                       }).toList(),
  //                       onChanged: (val) {},
  //                       hint: Text(
  //                         "Satuan Dasar",
  //                         style: tema.textTheme.bodyLarge!.copyWith(
  //                           color: Colors.black87,
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               ),
  //               IconButton(
  //                 onPressed: () {},
  //                 icon: Icon(
  //                   Icons.add_circle_outline,
  //                   size: 18,
  //                   color: tema.primaryColor,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //       PublicWidget.spasi(mode: OrientationMode.horizontal),
  //       Expanded(
  //         flex: 3,
  //         child: TextField(
  //           decoration: InputDecoration(label: Text("Stok Awal")),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
