import 'package:simplepos/services/utils/constant.dart';
import 'package:simplepos/services/utils/preferences.dart';

mixin CacheManager {
  final Preference _pref = Preference();

  void setShowHideSatDasarInfo(bool value) =>
      _pref.setPrefBool(key: pkShowSatDasarInfo, value: value);

  bool getShowHideSatDasarInfo() => !_pref.getPrefBool(key: pkShowSatDasarInfo);
}
