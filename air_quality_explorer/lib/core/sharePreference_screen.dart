// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

/// Set Language local
setLocale(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("Locale", value.toString());
}

/// Get Language local
Future<String> getLocaleLanguage() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? getLocal = pref.getString('Locale');

  return getLocal ?? "";
}

/// Set alrady save data
setAlreadyInsertData(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("AlradyInsert", value);
}

/// Get insert data value
Future<bool> getAlreadyInsertData() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  bool? getLocal = pref.getBool('AlradyInsert');
  return getLocal ?? false;
}
