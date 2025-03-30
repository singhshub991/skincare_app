import 'package:shared_preferences/shared_preferences.dart';

// TODO : Think of constant constructor
class StorageUtils{
  static Future saveInt(String key, int value) async => (await SharedPreferences.getInstance()).setInt(key, value);

  static Future<int?> getInt(String key) async => (await SharedPreferences.getInstance()).getInt(key);

  static Future<bool> saveBool(String key, bool value) async => (await SharedPreferences.getInstance()).setBool(key, value);

  static Future<bool?> getBool(String key) async => (await SharedPreferences.getInstance() ).getBool(key);

  static Future<bool> saveString(String key, String value)  async => (await SharedPreferences.getInstance()).setString(key, value);

  static Future<String?> getString(String key) async => (await SharedPreferences.getInstance()).getString(key);

  static Future<bool> setDouble(String key, double value)  async => (await SharedPreferences.getInstance()).setDouble(key, value);

  static Future<double?> getDouble(String key) async => (await SharedPreferences.getInstance()).getDouble(key);

  static Future<bool> setList(String key,value)  async => (await SharedPreferences.getInstance()).setStringList(key, value);

  static Future<List<String>?> getList(String key) async => (await SharedPreferences.getInstance()).getStringList(key);

  static Future<bool> remove(String key) async => (await SharedPreferences.getInstance()).remove(key);

  static Future<bool> clear() async {
    List<String> keyToKeep = ["remember_me","loginId","password","AuthType","message"];
    Set<String> keys = (await SharedPreferences.getInstance()).getKeys();
    keys.forEach((element) async {
      if(!keyToKeep.contains(element)){
        (await SharedPreferences.getInstance()).remove(element);
      }
    });
    return true;
  }

}