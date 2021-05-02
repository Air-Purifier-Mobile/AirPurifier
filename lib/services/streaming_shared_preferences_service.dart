import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class StreamingSharedPreferencesService {
  StreamingSharedPreferences preferences;

  Future init() async {
    preferences = await StreamingSharedPreferences.instance;
  }

  Future<void> changeStringListInStreamingSP(String key, List<String> list) {
    return preferences.setStringList(key, list);
  }

  List<String> readStringListFromStreamingSP(String key) {
    return preferences.getStringList(key, defaultValue: []).getValue();
  }

  Future<void> changeBoolInStreamingSP(String key, bool state) {
    return preferences.setBool(key, state);
  }

  bool readBoolFromStreamingSP(String key) {
    return preferences.getBool(key, defaultValue: false).getValue();
  }

  Future<void> changeStringInStreamingSP(String key, String value) {
    return preferences.setString(key, value);
  }

  String readStringFromStreamingSP(String key) {
    return preferences.getString(key, defaultValue: "null").getValue();
  }

  int readIntFromStreamingSP(String key) {
    return preferences.getInt(key, defaultValue: 0).getValue();
  }

  Future<void> changeIntInStreamingSP(String key, int value) {
    return preferences.setInt(key, value);
  }
}
