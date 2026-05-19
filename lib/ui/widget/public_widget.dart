import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simplepos/services/utils/enums.dart';

class PublicWidget {
  // ====== Widget Logo Aplikasi ======
  static Widget appLogo({double size = 120}) => SizedBox(
    width: size,
    height: size * 0.5,
    child: Image.asset("assets/mbspos.png", fit: BoxFit.cover),
  );

  // ====== Widget Spasi ======
  static Widget spasi({
    OrientationMode mode = OrientationMode.vertical,
    double jarak = 8,
  }) {
    if (mode == OrientationMode.horizontal) {
      return SizedBox(width: jarak, height: 0);
    } else {
      return SizedBox(height: jarak, width: 0);
    }
  }

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
          padding: EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: lstOpsi.map((opsi) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (opsi['label'] == 'Gallery') {
                      Navigator.pop(context, ImageSource.gallery);
                    } else {
                      Navigator.pop(context, ImageSource.camera);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          opsi['icon'],
                          color: Theme.of(context).primaryColor,
                          size: 40,
                        ),
                        Text(
                          opsi['label'],
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
