import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worker_task/models/worker.dart';

class SharedPrefs {
  static const String _keyLoginStatus = 'login_status';
  static const String _keyWorker = 'worker_data';

  static const String _keySavedEmail = 'saved_email';
  static const String _keySavedPassword = 'saved_password';
  static const String _keyRememberMe = 'remember_me';

  static Future<void> saveLoginStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoginStatus, status);
  }

  static Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoginStatus) ?? false;
  }

  static Future<void> saveWorker(Worker worker) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyWorker, jsonEncode(worker.toJson()));
  }

  static Future<Worker?> getWorker() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keyWorker);
    if (data != null) {
      return Worker.fromJson(jsonDecode(data));
    }
    return null;
  }

  // New methods for Remember Me:
  static Future<void> saveSavedEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySavedEmail, email);
  }

  static Future<String?> getSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keySavedEmail);
  }

  static Future<void> saveSavedPassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySavedPassword, password);
  }

  static Future<String?> getSavedPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keySavedPassword);
  }

  static Future<void> saveRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyRememberMe, value);
  }

  static Future<bool> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyRememberMe) ?? false;
  }

  static Future<void> clearSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keySavedEmail);
    await prefs.remove(_keySavedPassword);
    await prefs.setBool(_keyRememberMe, false);
  }
}
