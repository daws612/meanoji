import 'package:shared_preferences/shared_preferences.dart';

class MeanojiPreferences {
  static final String _userName = "UserName";

  static Future<String> getUserName() async {
	final SharedPreferences prefs = await SharedPreferences.getInstance();

	return prefs.getString(_userName) ?? null;
  }

  static Future<bool> setUserName(String value) async {
	final SharedPreferences prefs = await SharedPreferences.getInstance();

	return prefs.setString(_userName, value);
  }

  // static bool contains(String value) async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   bool CheckValue = prefs.containsKey(value);
  // }
}