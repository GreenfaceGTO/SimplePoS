import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:simplepos/models/args_model.dart';
import 'package:simplepos/models/data/produk_model.dart';
import 'package:simplepos/providers/master_provider.dart';
import 'package:simplepos/services/utils/enums.dart';
import 'package:simplepos/ui/widget/reusable/public_widget.dart';

class SatuanForm extends StatefulWidget {
  const SatuanForm({super.key, required this.args});
  final ArgsModel args;

  @override
  State<SatuanForm> createState() => _SatuanFormState();
}

class _SatuanFormState extends State<SatuanForm> {
  String tipe = 'D'; //tipe satuan dasar

  // hanya terisi jika input satuan lain
  ProdukSatModel? satDasar;

  String? namaItem;
  String? selectedSat;
  final TextEditingController txtbarcode = TextEditingController();
  final TextEditingController txtIsi = TextEditingController();
  final TextEditingController txtStok = TextEditingController();
  final TextEditingController txtHpokok = TextEditingController();
  final TextEditingController txtHJual = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    namaItem = widget.args.data['nama_item'];
    if (widget.args.data['sat_dasar'] != null) {
      tipe = "K";
      satDasar = widget.args.data['sat_dasar'];
      txtHpokok.text = widget.args.data['sat_dasar'].hPokok.toStringAsFixed(0);
    } else {
      txtIsi.text = "1";
    }

    super.initState();
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

  @override
  Widget build(BuildContext context) {
    ThemeData tema = Theme.of(context);
    return Scaffold(
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
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 12),
                  width: double.infinity,
                  child: ListTile(
                    visualDensity: VisualDensity(vertical: -4),

                    title: Text("Nama Produk", style: tema.textTheme.bodySmall),
                    subtitle: Text(
                      namaItem!,
                      style: tema.textTheme.titleMedium,
                    ),
                  ),
                  // Text(namaItem!, style: TextStyle(color: Colors.red)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _opsiSatuan(tema),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: txtbarcode,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (val) {
                          FocusScope.of(context).nextFocus();
                        },
                        decoration: InputDecoration(
                          label: Text("Barcode"),
                          hintText: "Masukkan atau scan barcode",
                          suffixIcon: IconButton(
                            onPressed: () async {
                              String? scanned = await PublicWidget.scanBarcode(
                                context,
                              );
                              if (scanned != null) {
                                setState(() {
                                  txtbarcode.text = scanned;
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
                              },
                              decoration: InputDecoration(label: Text("Isi")),
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
                              decoration: InputDecoration(
                                // errorMaxLines: 2,
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
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
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
                  child: DropdownButtonFormField(
                    style: tema.textTheme.titleSmall,
                    value: selectedSat,
                    items: prov.daftarSatuan.map((sat) {
                      return DropdownMenuItem(value: sat, child: Text(sat));
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedSat = val;
                      });
                    },
                    hint: Text(tipe == 'D' ? "Satuan Dasar" : "Satuan Lain"),
                  ),
                ),
                IconButton(
                  onPressed: () async {
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
                  },
                  icon: Icon(
                    Icons.add_circle,
                    size: 18,
                    color: tema.primaryColor,
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
