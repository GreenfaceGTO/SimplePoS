import 'package:flutter/services.dart';
import 'package:simplepos/services/utils/extension.dart';

class CapitalizeEachWord extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text.capitalizeEachWord();
    return newValue.copyWith(text: newText, selection: newValue.selection);
  }
}
