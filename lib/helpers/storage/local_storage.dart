import 'dart:convert';

import 'package:foody/helpers/localizations/language.dart';
import 'package:foody/helpers/services/auth_services.dart';
import 'package:foody/helpers/theme/theme_customizer.dart';
import 'package:foody/model/articolo.dart';
import 'package:foody/model/customer_detail.dart';
import 'package:foody/model/listino.dart';
import 'package:foody/model/ordine.dart';
import 'package:foody/model/scadenziario_cliente.dart';
import 'package:foody/model/storico.dart';
import 'package:foody/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _loggedInUserKey = "user";
  static const String _themeCustomizerKey = "theme_customizer";
  static const String _loggedUserKey = "logged_user";
  static const String _languageKey = "lang_code";
  static const String _tokenKey = "token";

  static const String _articoli = "articoli";
  static const String _topArticoli = "topArt";
  static const String _listini = "listini";
  static const String _dettCliente = "dettCliente";
  static const String _ordini = "ordini";
  static const String _scadenzario = "scadenzario";
  static const String _storico = "storico";
  static const String _offline = "offline";
  static const String _note = "note";
  static const String _fattA = "fattA";
  static const String _carrello = "carrello";
  static const String _notaIncasso = "notaIncasso";
  static const String _notaConsegna = "notaConsegna";
  static const String _carrelloGlobale = "carrelloGlobale";

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

  static Future<bool> setNotaIncasso(String token) {
    return preferences.setString(_notaIncasso, token);
  }

  static String? getNotaIncasso() {
    return preferences.getString(_notaIncasso);
  }

  static Future<bool> setNotaConsegna(String token) {
    return preferences.setString(_notaConsegna, token);
  }

  static String? getNotaConsegna() {
    return preferences.getString(_notaConsegna);
  }

  static User? getLoggedUser() {
    User user = User.fromJson(
        jsonDecode(preferences.getString(_loggedUserKey) ?? "{}"));
    return user;
  }

  static Future<bool> setArticoli(List<Articolo> articoli) {
    return preferences.setString(
        _articoli, jsonEncode(articoli.map((v) => v.toJson()).toList()));
  }

  static List<Articolo>? getArticoli() {
    dynamic data = Articolo.listFromJSON(
        jsonDecode(preferences.getString(_articoli) ?? "[]"));
    return data;
  }

  static Future<bool> setTopArticoli(List<Articolo> articoli) {
    return preferences.setString(
        _topArticoli, jsonEncode(articoli.map((v) => v.toJson()).toList()));
  }

  static List<Articolo>? getTopArticoli() {
    dynamic data = Articolo.listFromJSON(
        jsonDecode(preferences.getString(_topArticoli) ?? "[]"));
    return data;
  }

  static Future<bool> setCarrello(List<Articolo> articoli) {
    var a = articoli.map((v) => v.toJson()).toList();
    return preferences.setString(
        _carrello, jsonEncode(articoli.map((v) => v.toJson()).toList()));
  }

  static List<Articolo>? getCarrello() {
    dynamic data = Articolo.listFromJSON(
        jsonDecode(preferences.getString(_carrello) ?? "[]"));
    return data;
  }

  static Future<bool> setCarrelloGlobale(List<Articolo> articoli) {
    var a = articoli.map((v) => v.toJson()).toList();
    return preferences.setString(
        _carrelloGlobale, jsonEncode(articoli.map((v) => v.toJson()).toList()));
  }

  static List<Articolo>? getCarrelloGlobale() {
    dynamic data = Articolo.listFromJSON(
        jsonDecode(preferences.getString(_carrelloGlobale) ?? "[]"));
    return data;
  }

  static Future<bool> setListini(List<Listino> listini) {
    return preferences.setString(
        _listini, jsonEncode(listini.map((v) => v.toJson()).toList()));
  }

  static List<Listino>? getListini() {
    dynamic data = Listino.listFromJSON(
        jsonDecode(preferences.getString(_listini) ?? "[]"));
    return data;
  }

  static Future<bool> setDettCli(CustomerDetail? dett) {
    if (dett == null) {
      return preferences.remove(_dettCliente);
    } else {
      return preferences.setString(_dettCliente, jsonEncode(dett.toJson()));
    }
  }

  static CustomerDetail? getDettCli() {
    var a = preferences.getString(_dettCliente);
    dynamic data = CustomerDetail.fromJSON(
        jsonDecode(preferences.getString(_dettCliente) ?? "{}"));
    return data;
  }

  static Future<bool> setFattA(CustomerDetail? fattA) {
    if (fattA == null) {
      return preferences.remove(_fattA);
    } else {
      return preferences.setString(_fattA, jsonEncode(fattA.toJson()));
    }
  }

  static CustomerDetail? getFattA() {
    dynamic data = CustomerDetail.fromJSON(
        jsonDecode(preferences.getString(_fattA) ?? "{}"));
    return data;
  }

  static Future<bool> setOrdini(List<Ordine> ordini) {
    var a = ordini.map((v) => v.toJson()).toList();
    return preferences.setString(
        _ordini, jsonEncode(ordini.map((v) => v.toJson()).toList()));
  }

  static List<Ordine>? getOrdini() {
    dynamic data =
        Ordine.listFromJSON(jsonDecode(preferences.getString(_ordini) ?? "[]"));
    return data;
  }

  static Future<bool> setScadenzario(List<ScadenziarioCliente> scad) {
    return preferences.setString(
        _scadenzario, jsonEncode(scad.map((v) => v.toJson()).toList()));
  }

  static List<ScadenziarioCliente>? getScadenzario() {
    dynamic data = ScadenziarioCliente.listFromJSON(
        jsonDecode(preferences.getString(_scadenzario) ?? "[]"));
    return data;
  }

  static Future<bool> setStorico(List<Storico> storico) {
    return preferences.setString(
        _storico, jsonEncode(storico.map((v) => v.toJson()).toList()));
  }

  static List<Storico>? getStorico() {
    dynamic data = Storico.listFromJSON(
        jsonDecode(preferences.getString(_storico) ?? "[]"));
    return data;
  }

  static Future<bool> setOffline(bool offline) {
    return preferences.setString(_offline, jsonEncode(offline));
  }

  static bool getOffline() {
    dynamic data = json.decode(preferences.getString(_offline) ?? "false");
    return data ?? false;
  }

  static Future<bool> setNote(String note) {
    return preferences.setString(_note, note);
  }

  static String getNote() {
    dynamic data = preferences.getString(_note) ?? "";
    return data;
  }
}
