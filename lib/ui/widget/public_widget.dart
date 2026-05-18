import 'package:flutter/material.dart';
import 'package:simplepos/services/utils/enums.dart';

class PublicWidget {
  static Widget appLogo({double size = 120}) => SizedBox(
    width: size,
    height: size * 0.5,
    child: Image.asset("assets/mbspos.png", fit: BoxFit.cover),
  );

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
}
