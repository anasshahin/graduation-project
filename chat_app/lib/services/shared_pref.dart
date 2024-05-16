import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static  SharedPreferences ?_prefs;

  static Future<SharedPreferences?> init() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  static Future<bool?> setStringValue(String key, String value) async {
    return await _prefs?.setString(key, value);
  }

  static Future<bool?> setBooleanValue(String key, bool value) async {
    return await _prefs?.setBool(key, value);
  }

  static Future<bool?> setIntValue(String key, int value) async {
    return await _prefs?.setInt(key, value);
  }

  static Future<bool?> setDoubleValue(String key, double value) async {
    return await _prefs?.setDouble(key, value);
  }

  static Future<bool?> setStingList(String key, List<String> value) async {
    return await _prefs?.setStringList(key, value);
  }

  // ----------------------------------------

  static String? getStringValue(String key) {
    return _prefs?.getString(key);
  }

  static int? getIntValue(String key) {
    return _prefs?.getInt(key);
  }

  static double? getDoubleValue(String key) {
    return _prefs?.getDouble(key);
  }

  static bool? getBooleanValue(String key) {
    return _prefs?.getBool(key);
  }

  static List<String>? getStringListValue(String key) {
    return _prefs?.getStringList(key);
  }

  //--------------
/*
  static bool? containsKey(String key) {
    return _prefs.containsKey(key);
  }

  static Future<bool> removeValue(String key) async {
    return await _prefs.remove(key);
  }

  static Future<bool> clear() async {
    return await _prefs.clear();
  }*/
}
