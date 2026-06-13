import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:simplepos/models/args_model.dart';
import 'package:simplepos/models/data/produk_model.dart';
import 'package:simplepos/models/data/produksat_model.dart';
import 'package:simplepos/providers/master_provider.dart';
import 'package:simplepos/services/utils/constant.dart';
import 'package:simplepos/services/utils/enums.dart';
import 'package:simplepos/services/utils/inputformater.dart';
import 'package:simplepos/ui/ref/kategori_page.dart';
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

  ProdukModel? data;
  ProdukModel? oldData;
  ProdukSatModel? satDasar;
  List<ProdukSatModel> satLain = [];

  // Widget spasi = PublicWidget.spasi();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.args.formMode == FormMode.update) {
      oldData = widget.args.data;
      data = oldData!.copyWith();

      txtNama.text = data!.namaProduk!;
      satDasar = data!.getSatuanDasar();
      satDasar!.stok = data!.stok;
      satLain = data!.lstSatuan!.skip(1).toList();

      setState(() {});
    } else {
      data = ProdukModel();
    }

    super.initState();
  }

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
        data!.tag!.removeWhere((e) => e == kat);
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
        if (satuan.tipe == 'K') {
          data!.lstSatuan!.removeWhere(
            (e) => e.satuan!.toLowerCase() == satuan.satuan!.toLowerCase(),
          );
          satLain.removeWhere((e) => e.satuan == satuan.satuan);
        } else {
          data!.lstSatuan!.clear();
        }
      });
    }
  }

  void validateForm() async {
    bool satDasarExist = data!.lstSatuan!.any((e) => e.tipe == "D");
    if (!satDasarExist) {
      PublicWidget.showMessage(
        message: "Satuan belum ditentukan",
        mode: MessageMode.warning,
      );
    } else if (data!.tag!.isEmpty) {
      PublicWidget.showMessage(
        message: "Setidaknya tentukan 1 kategori",
        mode: MessageMode.warning,
      );
    } else if (formKey.currentState!.validate()) {
      // Menambahkan satuan dasar di awal daftar satuan sebelum satuan lainnya
      List<ProdukSatModel> sat = [satDasar!];

      // Looping variabel satLain lokal untuk di tambahkan di variabel sat, setelah satuan dasar
      for (var satkov in satLain) {
        if (!sat.contains(satkov)) {
          sat.add(satkov);
        }
      }

      // inisialisasi awal variabel selesai = gagal
      bool done = false;

      if (widget.args.formMode == FormMode.input) {
        // jika mode input, buat instance kelas produk dengan data dari form

        done = await context.read<MasterProvider>().addNewProduk(data!);
      } else {
        done = await context.read<MasterProvider>().updateProduk(data!);
      }

      if (done) {
        if (mounted) {
          Navigator.pop(context);
        }
      }
    }
  }

  bool canPop() {
    if (widget.args.formMode == FormMode.input) return true;

    if (data == null) return false;
    bool retval = data!.compare(oldData!);
    log("$runtimeType : result $retval");
    return retval;
  }

  void updateField(String from, {dynamic value}) {
    switch (from) {
      case "nama":
        data!.namaProduk = txtNama.text;

        break;
      case "tag":
        if (value != null) {
          data!.tag!.clear();
          data!.tag!.addAll(value);
        }
        break;
      case "satuan":
        if (value != null) {
          if (value is ProdukSatModel) {
            if (value.tipe == 'D') {
              satDasar = value;
              data!.stok = value.stok;
            } else {
              if (satLain.any(
                (e) => e.satuan!.toLowerCase() == value.satuan!.toLowerCase(),
              )) {
                PublicWidget.showMessage(
                  message: "Satuan sudah ada!",
                  mode: MessageMode.info,
                );
              } else {
                satLain.add(value);
              }
            }
            data!.lstSatuan!.add(value);
          }
        }
        break;
      default:
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ThemeData tema = Theme.of(context);
    return PopScope(
      canPop: canPop(),
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final keluar = await PublicWidget.discardChange(context);

        if (keluar && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
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
                        Text(
                          "Informasi Umum",
                          style: tema.textTheme.titleMedium,
                        ),
                        SizedBox(height: 16),

                        TextFormField(
                          autofocus: widget.args.formMode == FormMode.input,
                          controller: txtNama,
                          onChanged: (val) {
                            txtNama.text = val;
                            updateField("nama");
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
      ),
    );
  }

  /// Widget grup satuan dan harga
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

          data!.lstSatuan!.isEmpty
              ? _noSatDasarWidget(context)
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _satDasar(tema),
                    Divider(),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (satLain.isNotEmpty)
                          ...data!.lstSatuan!.skip(1).map((e) {
                            return _satuanLainCard(tema, e);
                          }),

                        if (data!.lstSatuan!.length < 3)
                          Center(
                            child: Padding(
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
                                              "satuan_dasar": satDasar,
                                              "target_data": null,
                                            },
                                          ),
                                        );
                                    if (satKonv != null) {
                                      updateField("satuan", value: satKonv);
                                    }
                                  },
                                  child: Text("Satuan Lainnya"),
                                ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Satuan Lain",
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 2),
            leading: Icon(Icons.compare_arrows_outlined),
            title: Text(
              "${e.satuan} (${e.isi} ${satDasar!.satuan!})",
              style: tema.textTheme.titleSmall,
            ),
            subtitle: e.barcode!.isEmpty ? null : Text(e.barcode!),
            trailing: _popmenuSatuanLain(e),
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

  PopupMenuButton<String> _popmenuSatuanLain(ProdukSatModel satuan) {
    return PopupMenuButton(
      onSelected: (val) async {
        if (val == '/edit') {
          log(satuan.toMap().toString());
          final satLainCopy = satuan.copyWith();
          ProdukSatModel? satuanLain = await Navigator.pushNamed(
            context,
            rtFormSatuan,
            arguments: ArgsModel(
              formMode: FormMode.update,
              data: {
                "nama_item": txtNama.text,
                "satuan_dasar": satDasar,
                "target_data": satLainCopy,
              },
            ),
          );
          if (satuanLain != null) {
            int idx = data!.lstSatuan!.indexWhere(
              (e) => e.satuan == satuanLain.satuan,
            );
            data!.lstSatuan![idx] = satuanLain;
            satLain.clear();
            satLain.addAll(data!.lstSatuan!);
            setState(() {});
          }
        } else {
          deleteSatuan(satuan);
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: "/edit",
            child: ListTile(
              leading: Icon(Icons.edit, size: 18),
              title: Text("Edit"),
            ),
          ),
          PopupMenuItem(
            value: "/hapus",
            child: ListTile(
              leading: Icon(Icons.delete_forever, color: Colors.red, size: 18),
              title: Text("Hapus", style: TextStyle(color: Colors.red)),
            ),
          ),
        ];
      },
    );
  }

  void updateHarga(ProdukSatModel updatedData) {
    satDasar = updatedData;
    data!.lstSatuan!.clear();
    data!.lstSatuan!.add(satDasar!);

    double hPokok = satDasar!.hPokok!;
    double hJual = satDasar!.hJual!;
    for (var sat in satLain) {
      sat.hPokok = hPokok * sat.isi;
      sat.hJual = hJual * sat.isi;
      data!.lstSatuan!.add(sat);
    }

    setState(() {});
  }

  // Widget khusus untuk menampilkan satuan dasar
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
          Text(
            "Satuan Dasar",
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 2),
            leading: Icon(Symbols.filter_1),
            title: Text(
              data!.lstSatuan![0].satuan!,
              style: tema.textTheme.titleSmall,
            ),
            subtitle: data!.lstSatuan![0].barcode!.isEmpty
                ? null
                : Text(data!.lstSatuan![0].barcode!),
            trailing: _popmenuSatuanDasar(),
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

  PopupMenuButton<String> _popmenuSatuanDasar() {
    return PopupMenuButton(
      onSelected: (val) async {
        if (val == "/edit") {
          final copiedSat = satDasar!.copyWith();
          ProdukSatModel? newSatDasar = await Navigator.pushNamed(
            context,
            rtFormSatuan,
            arguments: ArgsModel(
              formMode: FormMode.update,
              data: {
                "nama_item": txtNama.text,
                "satuan_dasar": satDasar,
                "target_data": copiedSat,
              },
            ),
          );
          if (newSatDasar != null) {
            setState(() {
              satDasar = newSatDasar;
              data!.lstSatuan![0] = newSatDasar;
            });
          }
        } else {
          deleteSatuan(satDasar!);
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: "/edit",
            child: ListTile(
              leading: Icon(Icons.edit, size: 18),
              title: Text("Edit"),
            ),
          ),
          PopupMenuItem(
            enabled: satLain.isEmpty,
            value: "/hapus",
            child: ListTile(
              leading: Icon(
                Icons.delete_forever,
                size: 18,
                color: satLain.isEmpty ? Colors.red : Colors.grey,
              ),
              title: Text(
                "Hapus",
                style: TextStyle(
                  color: satLain.isEmpty ? Colors.red : Colors.grey,
                ),
              ),
            ),
          ),
        ];
      },
    );
  }

  /// Widget jika belum ada satuan sama sekali
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
                    data: {
                      "nama_item": txtNama.text,
                      "satuan_dasar": null,
                      "target_data": null,
                    },
                  ),
                );
                if (satuan != null) {
                  updateField("satuan", value: satuan);
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
                        builder: (_) => KategoriPage(currentTag: data!.tag!),
                      ),
                    );
                    if (kat != null) {
                      updateField("tag", value: kat);
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
            child: data!.tag!.isEmpty
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
                      children: data!.tag!.map((kat) {
                        return InputChip(
                          deleteIconColor: Colors.red,
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
