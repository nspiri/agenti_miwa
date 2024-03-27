import 'dart:convert';

import 'package:foody/helpers/localizations/language.dart';
import 'package:foody/helpers/services/auth_services.dart';
import 'package:foody/helpers/theme/theme_customizer.dart';
import 'package:foody/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _loggedInUserKey = "user";
  static const String _themeCustomizerKey = "theme_customizer";
  static const String _loggedUserKey = "logged_user";
  static const String _languageKey = "lang_code";
  static const String _tokenKey = "token";

  static SharedPreferences? _preferencesInstance;

  static SharedPreferences get preferences {
    if (_preferencesInstance == null) {
      throw ("Call LocalStorage.init() to initialize local storage");
    }
    return _preferencesInstance!;
  }

  static Future<void> init() async {
    _preferencesInstance = await SharedPreferences.getInstance();
    await initData();
  }

  static Future<void> initData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    AuthService.isLoggedIn = preferences.getBool(_loggedInUserKey) ?? false;
    ThemeCustomizer.fromJSON(preferences.getString(_themeCustomizerKey));
  }

  static Future<bool> setLoggedInUser(bool loggedIn) async {
    return preferences.setBool(_loggedInUserKey, loggedIn);
  }

  static Future<bool> setCustomizer(ThemeCustomizer themeCustomizer) {
    return preferences.setString(_themeCustomizerKey, themeCustomizer.toJSON());
  }

  static Future<bool> setLanguage(Language language) {
    return preferences.setString(_languageKey, language.locale.languageCode);
  }

  static String? getLanguage() {
    return preferences.getString(_languageKey);
  }

  static Future<bool> removeLoggedInUser() async {
    return preferences.remove(_loggedInUserKey);
  }

  static Future<bool> setLoggedUser(User user) {
    return preferences.setString(_loggedUserKey, jsonEncode(user.toJson()));
  }

  static Future<bool> setToken(String token) {
    return preferences.setString(_tokenKey, token);
  }

  static String? getToken() {
    return preferences.getString(_tokenKey);
  }

  static User? getLoggedUser() {
    User user =
        User.fromJson(jsonDecode(preferences.getString(_loggedUserKey) ?? ""));
    return user;
  }
}
