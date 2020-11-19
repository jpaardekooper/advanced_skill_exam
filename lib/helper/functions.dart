import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static const String sharedPreferenceUserLoggedInKey = "USERLOGGEDINKEY";
  static const String sharedPreferenceUserNameKey = "USERNAMEKEY";
  static const String sharedPreferenceUserEmailKey = "USEREMAILKEY";
  static const String sharedPreferenceUserPassKey = "USERPASSKEY";
  static const String sharedPreferenceDisclaimerKey = "DISCLAIMERKEY";
  static const String sharedPreferenceUserRoleKey = "ROLE";

  static Future<bool> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<void> saveUserNameSharedPreference(String userName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(sharedPreferenceUserNameKey, userName);
  }

  static Future<void> saveUserEmailSharedPreference(String userEmail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(sharedPreferenceUserEmailKey, userEmail);
  }

  static Future<void> saveUserPasswordSharedPreference(String pass) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(sharedPreferenceUserPassKey, pass);
  }

  static Future<bool> saveDisclaimerSharedPreference(bool disclaimer) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setBool(sharedPreferenceDisclaimerKey, disclaimer);
  }

  static Future<void> saveUserRoleSharedPreference(String role) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(sharedPreferenceUserRoleKey, role);
  }

  /// This is awesome

  static Future<bool> getUserLoggedInSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(sharedPreferenceUserLoggedInKey);
  }

  static Future<String> getUserNameSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserNameKey);
  }

  static Future<String> getUserEmailSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserEmailKey);
  }

  static Future<String> getUserPasswordSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserPassKey);
  }

  static Future<bool> getDisclaimerSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(sharedPreferenceDisclaimerKey);
  }

  static Future<String> getUserRoleSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserRoleKey);
  }

//removing shared pref
  static Future<void> removeUserNameSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.remove(sharedPreferenceUserNameKey);
  }

  static Future<void> removeUserEmailSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.remove(sharedPreferenceUserEmailKey);
  }

  static Future<void> removeUserPasswordSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.remove(sharedPreferenceUserPassKey);
  }
}
