import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:simplepos/main.dart';
import 'package:simplepos/services/utils/constant.dart';
import 'package:simplepos/services/utils/enums.dart';
import 'package:simplepos/services/utils/inputformater.dart';

class PublicWidget {
  // ------------------------
  // Custom periode picker
  // ------------------------
  static Future<DateTime?> customPeriodPicker(
    BuildContext context, {
    required DateTime initial,
  }) async {
    int selectedMonth = initial.month;
    int selectedYear = initial.year;
    return showDialog<DateTime>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Pilih Periode"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text("Tahun:"),
                      SizedBox(width: 8),
                      SizedBox(
                        width: 100,
                        child: DropdownButton<int>(
                          isExpanded: true,
                          isDense: true,
                          value: selectedYear,
                          items: List.generate(10, (i) => selectedYear - 5 + i)
                              .map(
                                (year) => DropdownMenuItem(
                                  value: year,
                                  child: Text(
                                    "$year",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                selectedYear = val;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    childAspectRatio: 9 / 3,
                    children: List.generate(12, (index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedMonth = index + 1;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: selectedMonth == index + 1
                                ? Theme.of(context).colorScheme.secondary
                                : null,
                            border: Border.all(
                              color: Colors.black38,
                              width: 0.3,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              lstNamaBulan[index],
                              style: TextStyle(
                                fontSize: 12,
                                color: selectedMonth == index + 1
                                    ? Colors.white
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              actions: [
                SizedBox(
                  height: 45,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        DateTime(selectedYear, selectedMonth),
                      );
                    },
                    child: Text("OK"),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Meampilkan jendela konfirmasi ketika user ingin menutup halaman tapi data
  // yang sedang di edit belum disimpan
  // ---------------------------------------------------------------------------
  static Future<bool> discardChange(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Konfirmasi"),
            content: Text("Perubahan belum disimpan!! Keluar tanpa menyimpan?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx, true);
                },
                child: Text("KELUAR"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx, false);
                },
                child: Text("BATAL"),
              ),
            ],
          ),
        ) ??
        false;
  }

  // -------------------------
  // Widget Logo Aplikasi
  // -------------------------
  static Widget appLogo({double size = 120}) => SizedBox(
    width: size,
    height: size * 0.5,
    child: Image.asset("assets/mbspos.png", fit: BoxFit.cover),
  );

  // ---------------------------------------------------
  // Widget bottomsheet opsi sumber pengambilan gambar
  // ---------------------------------------------------
  static Future<ImageSource?> showImageSourceOption(
    BuildContext context,
  ) async {
    List<Map<String, dynamic>> lstOpsi = [
      {"icon": Icons.photo_library_outlined, "label": "Gallery"},
      {"icon": Icons.camera_alt_outlined, "label": "Kamera"},
    ];

    return await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(12, 12, 12, 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: lstOpsi.map((opsi) {
              return SizedBox(
                height: 45,
                child: OutlinedButton.icon(
                  onPressed: () {
                    if (opsi['label'] == 'Gallery') {
                      Navigator.pop(context, ImageSource.gallery);
                    } else {
                      Navigator.pop(context, ImageSource.camera);
                    }
                  },
                  label: Text(opsi['label']),
                  icon: Icon(opsi['icon']),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // --------------------------------------------
  // Mengambil gambar dari kamera atau gallery
  // --------------------------------------------
  static Future<File?> pickImage({
    ImageSource source = ImageSource.gallery,
  }) async {
    final ImagePicker imgPicker = ImagePicker();

    final XFile? image = await imgPicker.pickImage(
      source: source,
      imageQuality: 60,
      maxWidth: 640,
      maxHeight: 640,
    );
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  // -----------------------------------------
  // Widget penampil pesan toast (snackbar)
  // -----------------------------------------
  static void showMessage({
    required String message,
    MessageMode mode = MessageMode.info,
    int durasi = 3,
  }) {
    Color bgColor = Colors.teal;
    Color frColor = Colors.white;
    if (mode == MessageMode.error) {
      bgColor = Colors.red;
    } else if (mode == MessageMode.warning) {
      bgColor = Colors.amberAccent;
      frColor = Colors.black;
    }

    final messenger = rootScaffoldMessengerKey.currentState;
    // ScaffoldMessenger.maybeOf(context) ??

    messenger?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: frColor,
          ),
        ),
        backgroundColor: bgColor,
        duration: Duration(seconds: durasi),
      ),
    );
  }

  // ----------------------------------
  // Metode konversi angka ke rupiah
  // ----------------------------------
  static NumberFormat toRupiah = NumberFormat.currency(
    locale: 'ID',
    symbol: "Rp. ",
    decimalDigits: 2,
  );

  // --------------------------------------------------
  // Jendela dialog input referensi kategori & satuan
  // --------------------------------------------------
  static Future<String?> showRefForm(
    BuildContext context, {
    required String title,
  }) async {
    TextEditingController txtRef = TextEditingController();
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          content: TextFormField(
            controller: txtRef,
            autofocus: true,
            inputFormatters: [CapitalizeEachWord()],
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.done,
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (txtRef.text.isNotEmpty) {
                  Navigator.pop(ctx, txtRef.text);
                }
              },
              child: const Text("SIMPAN"),
            ),
          ],
        );
      },
      barrierDismissible: true,
    );
  }

  // -----------------------
  // Metode scan barcode
  // -----------------------
  static Future<String?> scanBarcode(BuildContext context) async {
    String? result = await SimpleBarcodeScanner.scanBarcode(
      context,
      barcodeAppBar: const BarcodeAppBar(
        appBarTitle: "Scan barcode",
        centerTitle: false,
        enableBackButton: true,
        backButtonIcon: Icon(Icons.chevron_left),
      ),
      isShowFlashIcon: true,
      cancelButtonText: "BATAL",
      delayMillis: 500,
      cameraFace: CameraFace.back,
      scanFormat: ScanFormat.ONLY_BARCODE,
    );

    if (result != null && result != '-1') {
      return result;
    }
    return null;
  }
}
