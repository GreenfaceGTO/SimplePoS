import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:simplepos/main.dart';
import 'package:simplepos/services/utils/enums.dart';
import 'package:simplepos/services/utils/inputformater.dart';

class PublicWidget {
  // ====== Meampilkan jendela konfirmasi ketika user ingin menutup halaman tapi data yang sedang di edit belum disimpan ========
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

  // ====== Widget Logo Aplikasi ======
  static Widget appLogo({double size = 120}) => SizedBox(
    width: size,
    height: size * 0.5,
    child: Image.asset("assets/mbspos.png", fit: BoxFit.cover),
  );

  // ====== Widget bottomsheet opsi sumber pengambilan gambar ======
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

  // ======== Mengambil gambar dari kamera atau gallery ===========
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

  // ====== Widget penampil pesan toast (snackbar) ==========
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

  // =========Metode konversi angka ke rupiah=========
  static NumberFormat toRupiah = NumberFormat.currency(
    locale: 'ID',
    symbol: "Rp. ",
    decimalDigits: 2,
  );

  // ====== Jendela dialog input referensi kategori & satuan
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

  // ============Metode scan barcode============
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
