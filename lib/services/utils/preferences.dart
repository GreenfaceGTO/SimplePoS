import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  Preference._();
  static final Preference _instance = Preference._();

  factory Preference() => _instance;

  late SharedPreferences _pref;

  Future<void> init({bool clear = false}) async {
    _pref = await SharedPreferences.getInstance();
    if (clear) {
      _pref.clear();
    }
  }

  //******************************
  // BEGIN OF STRING PREFERENCE
  //******************************
  void setPrefString({required String key, required String value}) {
    _pref.setString(key, value);
  }

  String? getPrefString({required String key}) => _pref.getString(key);

  // *************************
  // BEGIN OF BOOl PREFERENCE
  // **************************
  bool getPrefBool({required String key}) => _pref.getBool(key) ?? false;

  void setPrefBool({required String key, required bool value}) {
    _pref.setBool(key, value);
  }

  void delAllPref() {
    _pref.clear();
  }

  void delByKey({required String key}) {
    _pref.remove(key);
  }
}
