import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String toIndonesianDate({bool withTime = false, bool showDayName = false}) {
    if (withTime) {
      if (showDayName) {
        return DateFormat('EEEE, dd MMM yyy  HH:mm', 'id_ID').format(this);
      } else {
        return DateFormat('dd MMM yyy  HH:mm').format(this);
      }
    } else {
      if (showDayName) {
        return DateFormat('EEEE, dd MMM yyy', 'id_ID').format(this);
      } else {
        return DateFormat('dd MMM yyy').format(this);
      }
    }
  }
}

extension StringExtension on String {
  // ------------------------------------------------------------------
  /// merubah huruf diawal kata pertama dalam kalimat menjadi capital
  // ------------------------------------------------------------------
  String capitalizeFirst() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  // -----------------------------------------------------------
  /// merubah setiap huruf awal dalam kalimat menjadi capital
  // -----------------------------------------------------------
  String capitalizeEachWord() {
    if (isEmpty) return this;
    return split(' ')
        .map(
          (word) =>
              word.isEmpty ? word : word[0].toUpperCase() + word.substring(1),
        )
        .join(' ');
  }
}
