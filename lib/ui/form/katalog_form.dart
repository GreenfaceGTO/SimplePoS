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
  List<ProdukSatModel> satLain = [];
  List<String> lstKategori = [];

  // Widget spasi = PublicWidget.spasi();
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
          title: Text("Konfirmasi"),
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

  void deleteSatuan(ProdukSatModel satuan) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Konfirmasi"),
          content: Text("Satuan ${satuan.satuan} ingin dihapus?"),
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
        if (satuan.isi > 1) {
          satLain.removeWhere((e) => e.satuan == satuan.satuan);
        } else {
          satDasar = null;
        }
      });
    }
  }

  void validateForm() {
    if (satDasar == null) {
      PublicWidget.showMessage(
        message: "Satuan belum ditentukan",
        mode: MessageMode.warning,
      );
    } else if (lstKategori.isEmpty) {
      PublicWidget.showMessage(
        message: "Setidaknya tentukan 1 kategori",
        mode: MessageMode.warning,
      );
    } else if (formKey.currentState!.validate()) {
      List<ProdukSatModel> sat = [satDasar!];
      for (var satkov in satLain) {
        if (!sat.contains(satkov)) {
          sat.add(satkov);
        }
      }
      ProdukModel newProduk = ProdukModel(
        namaProduk: txtNama.text,
        tag: lstKategori,
        stok: double.parse(satDasar!.stok.toString()),
        lstSatuan: sat,
      );
      log(newProduk.toMap().toString());
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
            onPressed: () {
              validateForm();
            },
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
                      SizedBox(height: 16),

                      TextFormField(
                        autofocus: true,
                        controller: txtNama,
                        onChanged: (val) {
                          setState(() {});
                        },
                        inputFormatters: [CapitalizeEachWord()],
                        decoration: InputDecoration(
                          label: Text("Nama Produk"),
                          hintText: "Masukkan nama produk",
                        ),
                        validator: (val) {
                          if (val!.isEmpty) return "Wajib diisi";
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
                      _tagKategori(tema),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                _satuanSection(tema, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _satuanSection(ThemeData tema, BuildContext context) {
    return Container(
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
          SizedBox(height: 16),

          satDasar == null
              ? _noSatDasarWidget(context)
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _satDasar(tema),
                    Divider(),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (satLain.isNotEmpty)
                          ...satLain.map((e) {
                            return _satuanLainCard(tema, e);
                          }),
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: SizedBox(
                            height: 45,
                            child: OutlinedButton(
                              onPressed: () async {
                                ProdukSatModel? satKonv =
                                    await Navigator.pushNamed(
                                      context,
                                      rtFormSatuan,
                                      arguments: ArgsModel(
                                        formMode: FormMode.input,
                                        data: {
                                          "nama_item": txtNama.text,
                                          "sat_dasar": satDasar,
                                        },
                                      ),
                                    );
                                if (satKonv != null) {
                                  setState(() {
                                    satLain.add(satKonv);
                                  });
                                }
                              },
                              child: Text("Satuan Lainnya"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Container _satuanLainCard(ThemeData tema, ProdukSatModel e) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 2),
            leading: Icon(Icons.compare_arrows_outlined),
            title: Text(
              "${e.satuan} (${e.isi} ${satDasar!.satuan!})",
              style: tema.textTheme.titleSmall,
            ),
            trailing: IconButton(
              onPressed: () {
                deleteSatuan(e);
              },
              icon: Icon(
                Icons.delete_forever_outlined,
                size: 18,
                color: Colors.red,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Harga Pokok"),
                      Text(
                        PublicWidget.toRupiah.format(e.hPokok),
                        style: tema.textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Harga Jual"),
                      Text(
                        PublicWidget.toRupiah.format(e.hJual),
                        style: tema.textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _satDasar(ThemeData tema) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 2),
            leading: Icon(Symbols.filter_1),
            title: Text(satDasar!.satuan!, style: tema.textTheme.titleSmall),
            subtitle: Text("Satuan Dasar"),
            trailing: satLain.isEmpty
                ? IconButton(
                    onPressed: () {
                      deleteSatuan(satDasar!);
                    },
                    icon: Icon(
                      Icons.delete_forever_outlined,
                      size: 18,
                      color: Colors.red,
                    ),
                  )
                : null,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Harga Pokok"),
                      Text(
                        PublicWidget.toRupiah.format(satDasar!.hPokok),
                        style: tema.textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Harga Jual"),
                      Text(
                        PublicWidget.toRupiah.format(satDasar!.hJual),
                        style: tema.textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _noSatDasarWidget(BuildContext context) {
    return SizedBox(
      height: 45,
      child: OutlinedButton.icon(
        onPressed: txtNama.text.isNotEmpty
            ? () async {
                ProdukSatModel? satuan = await Navigator.pushNamed(
                  context,
                  rtFormSatuan,
                  arguments: ArgsModel(
                    formMode: FormMode.input,
                    data: {"nama_item": txtNama.text, "sat_dasar": null},
                  ),
                );
                if (satuan != null) {
                  setState(() {
                    satDasar = satuan;
                  });
                }
              }
            : null,
        label: Text("Satuan Dasar"),
        icon: Icon(Icons.add),
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
}
