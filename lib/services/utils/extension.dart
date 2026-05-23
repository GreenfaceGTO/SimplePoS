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
