import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:simplepos/models/args_model.dart';
import 'package:simplepos/models/data/produksat_model.dart';
import 'package:simplepos/providers/master_provider.dart';
import 'package:simplepos/services/utils/cache_manager.dart';
import 'package:simplepos/services/utils/enums.dart';
import 'package:simplepos/ui/widget/reusable/public_widget.dart';

class SatuanForm extends StatefulWidget with CacheManager {
  SatuanForm({super.key, required this.args});
  final ArgsModel args;

  @override
  State<SatuanForm> createState() => _SatuanFormState();
}

class _SatuanFormState extends State<SatuanForm> {
  String tipe = 'D'; //tipe satuan dasar

  // hanya terisi jika input satuan lain
  ProdukSatModel? satDasar;
  ProdukSatModel? targetData;
  ProdukSatModel? oldData;

  String? namaItem;
  String? selectedSat;
  final TextEditingController txtbarcode = TextEditingController();
  final TextEditingController txtIsi = TextEditingController();
  final TextEditingController txtStok = TextEditingController();
  final TextEditingController txtHpokok = TextEditingController();
  final TextEditingController txtHJual = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool showSatDasarInfo = false;

  @override
  void initState() {
    // Ambil data yang di terima dari halaman pemanggil, pastikan tipenya adalah map
    // format data seperti ini : {'nama_item':,'satuan_dasar':,'target_data':}
    final data = widget.args.data as Map;

    // ambil nama produk dari data, untuk ditampilkan di halaman, agar pengguna tau satuan untuk produk apa yang akan dibuat
    namaItem = data['nama_item'];

    if (widget.args.formMode == FormMode.input) {
      _prepareForInput(data);
    } else {
      // form update menerima data yang memiliki field ['target_data'] sebagai data yang akan diubah. copy data tersebut untuk dibandingkan dengan data yang akan diubah
      targetData = data['target_data'];
      // log("target Data : ${targetData!.toMap()}");
      satDasar = data['satuan_dasar'];
      tipe = targetData!.tipe!;
      _prepareForEdit(data);
    }
    super.initState();
  }

  void _prepareForInput(Map data) {
    if (data['satuan_dasar'] != null) {
      tipe = "K";
      satDasar = data['satuan_dasar'];
      txtHpokok.text = data['satuan_dasar'].hPokok.toStringAsFixed(0);
    } else {
      txtIsi.text = "1";
      showSatDasarInfo = widget.getShowHideSatDasarInfo();
    }
  }

  void _prepareForEdit(Map data) {
    oldData = targetData!.copyWith();
    selectedSat = targetData!.satuan;
    txtbarcode.text = targetData!.barcode ?? '';
    txtIsi.text = targetData!.isi.toString();
    txtStok.text = targetData!.stok.toString();
    txtHpokok.text = targetData!.hPokok!.toStringAsFixed(0);
    txtHJual.text = targetData!.hJual!.toStringAsFixed(0);
  }

  void hitungHarga({required String dari}) {
    double pokok = 0;
    double jual = 0;
    switch (dari) {
      case "isi":
        if (txtIsi.text.isNotEmpty) {
          pokok = satDasar!.hPokok! * int.parse(txtIsi.text);
          txtHpokok.text = pokok.toStringAsFixed(0);
          jual = satDasar!.hJual! * int.parse(txtIsi.text);
          txtHJual.text = jual.toStringAsFixed(0);
        }
        break;
      case "pokok":
        break;
      default:
    }
    setState(() {});
  }

  void _updateField(String from, {dynamic value}) {
    switch (from) {
      case "satuan":
        targetData!.satuan = value;

      case "barcode":
        targetData!.barcode = value;

      case "stok":
        targetData!.stok = value;

      case "hpokok":
        targetData!.hPokok = value;

      case "hjual":
        targetData!.hJual = value;

      case "isi":
        targetData!.isi = value;

      default:
    }
    setState(() {});
  }

  bool canPop() {
    if (widget.args.formMode == FormMode.input) return true;
    log("sat Dasar : ${satDasar!.toMap()}");
    log("target Data : ${targetData!.toMap()}");
    bool retVal = targetData!.compare(oldData!);

    return retVal;
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
          title: Text(tipe == 'D' ? "Satuan Dasar" : "Satuan Lain"),
          actions: [
            IconButton(
              onPressed: () {
                if (selectedSat != null) {
                  if (formKey.currentState!.validate()) {
                    ProdukSatModel retVal = ProdukSatModel(
                      satuan: selectedSat,
                      barcode: txtbarcode.text,
                      isi: int.parse(txtIsi.text),
                      tipe: tipe,
                      stok: tipe == 'D' ? int.parse(txtStok.text) : 0,
                      hPokok: double.parse(txtHpokok.text),
                      hJual: double.parse(txtHJual.text),
                    );
                    Navigator.pop(context, retVal);
                    // log(retVal.toMap().toString());
                  }
                } else {
                  PublicWidget.showMessage(
                    message: "Satuan belum dipilih",
                    mode: MessageMode.warning,
                  );
                }
              },
              icon: Icon(Icons.done),
            ),
          ],
        ),
        body: Consumer<MasterProvider>(
          builder: (context, prov, _) {
            return Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (showSatDasarInfo) _bannerInfo(),
                    Container(
                      margin: EdgeInsets.only(bottom: 12),
                      width: double.infinity,
                      child: ListTile(
                        visualDensity: VisualDensity(vertical: -4),

                        title: Text(
                          "Nama Produk",
                          style: tema.textTheme.bodySmall,
                        ),
                        subtitle: Text(
                          namaItem!,
                          style: tema.textTheme.titleMedium,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _opsiSatuan(tema),
                          SizedBox(height: 8),
                          TextFormField(
                            autofocus: widget.args.formMode == FormMode.update,
                            controller: txtbarcode,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            onFieldSubmitted: (val) {
                              FocusScope.of(context).nextFocus();
                            },
                            onChanged: (val) {
                              _updateField("barcode", value: val);
                            },
                            decoration: InputDecoration(
                              label: Text("Barcode"),
                              hintText: "Masukkan atau scan barcode",
                              suffixIcon: IconButton(
                                onPressed: () async {
                                  String? scanned =
                                      await PublicWidget.scanBarcode(context);
                                  if (scanned != null) {
                                    setState(() {
                                      txtbarcode.text = scanned;
                                      _updateField("barcode", value: scanned);
                                    });
                                  }
                                },
                                icon: Icon(
                                  Symbols.barcode_scanner,
                                  size: 18,
                                  color: tema.primaryColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  enabled: tipe != 'D',
                                  controller: txtIsi,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  onChanged: (val) {
                                    hitungHarga(dari: "isi");
                                    _updateField("isi", value: int.parse(val));
                                  },
                                  decoration: InputDecoration(
                                    label: Text("Isi"),
                                  ),
                                  validator: tipe == "K"
                                      ? (val) {
                                          if (val!.isEmpty) {
                                            return "Wajib diisi";
                                          } else if (int.parse(val) < 2) {
                                            return "Harus lebih dari 1";
                                          }
                                          return null;
                                        }
                                      : null,
                                ),
                              ),
                              SizedBox(width: 8),

                              Expanded(
                                child: tipe == "D"
                                    ? TextFormField(
                                        controller: txtStok,
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        onChanged: (val) {
                                          _updateField(
                                            "stok",
                                            value: int.parse(val),
                                          );
                                        },
                                        decoration: InputDecoration(
                                          label: Text("Stok Awal"),
                                        ),
                                      )
                                    : SizedBox(),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: txtHpokok,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  errorBuilder: (context, errorText) => Text(
                                    errorText,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  onChanged: (val) {
                                    _updateField(
                                      "hpkoko",
                                      value: double.parse(val),
                                    );
                                  },
                                  decoration: InputDecoration(
                                    label: Text("Harga Pokok"),
                                  ),
                                  validator: (val) {
                                    if (tipe == 'K') {
                                      // log(tipe.toString());
                                      if (val!.isEmpty) {
                                        return "Wajib diisi";
                                      } else if (txtIsi.text.isNotEmpty) {
                                        if (double.parse(val) <
                                            (satDasar!.hPokok! *
                                                int.parse(txtIsi.text))) {
                                          return "Terlalu kecil dari harga konversi satuan dasar";
                                        }
                                      }
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  controller: txtHJual,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    label: Text("Harga Jual"),
                                  ),
                                  onChanged: (val) {
                                    _updateField(
                                      "hjual",
                                      value: double.parse(val),
                                    );
                                  },
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "Wajib diisi";
                                    } else if (double.parse(val) <=
                                        double.parse(txtHpokok.text)) {
                                      return "Harga jual salah!";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _bannerInfo() {
    return MaterialBanner(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      contentTextStyle: TextStyle(
        color: Colors.yellowAccent.shade100,
        fontWeight: FontWeight.w400,
      ),
      forceActionsBelow: true,

      elevation: 3,
      backgroundColor: Colors.teal,
      leading: Icon(
        Icons.info_outline,
        color: Colors.yellowAccent.shade100,
        size: 35,
        weight: 20,
      ),
      minActionBarHeight: 40,
      content: Text(
        "Nama satuan dasar bersifat permanen.\nTidak dapat diubah lagi setelah disimpan.",
      ),

      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              showSatDasarInfo = false;
              widget.setShowHideSatDasarInfo(!showSatDasarInfo);
            });
          },
          child: Text("OK, MENGERTI", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _opsiSatuan(ThemeData tema) {
    return Column(
      children: [
        Consumer<MasterProvider>(
          builder: (context, prov, _) {
            return Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    style: tema.textTheme.titleSmall,
                    value: selectedSat,
                    items: prov.daftarSatuan.map((sat) {
                      return DropdownMenuItem(value: sat, child: Text(sat));
                    }).toList(),
                    onChanged: widget.args.formMode == FormMode.input
                        ? (val) {
                            setState(() {
                              selectedSat = val;
                              _updateField("satuan", value: val);
                            });
                          }
                        : null,
                    hint: Text(tipe == 'D' ? "Satuan Dasar" : "Satuan Lain"),
                  ),
                ),
                IconButton(
                  onPressed: widget.args.formMode == FormMode.input
                      ? () async {
                          String? sat = await PublicWidget.showRefForm(
                            context,
                            title: "Satuan",
                          );
                          if (sat != null) {
                            if (await prov.addNewSatuan(sat)) {
                              setState(() {
                                selectedSat = sat;
                              });
                            }
                          }
                        }
                      : null,
                  icon: Icon(
                    Icons.add_circle,
                    size: 18,
                    color: widget.args.formMode == FormMode.input
                        ? tema.primaryColor
                        : Colors.grey,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
