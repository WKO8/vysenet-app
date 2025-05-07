import 'package:shared_preferences/shared_preferences.dart';

class AuthSharedPreferences {
  static const String isLoggedInKey = 'isLoggedIn';

  static Future<void> saveLoggedInState(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isLoggedInKey, isLoggedIn);
  }

  static Future<bool> loadLoggedInState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLoggedInKey) ?? false;
  }
}