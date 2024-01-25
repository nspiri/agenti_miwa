import 'package:flutter/services.dart';
import 'package:foody/helpers/services/json_decoder.dart';
import 'dart:convert';
import 'package:foody/model/identifier_model.dart';

class Nazionalita extends IdentifierModel {
  String? codice;
  String? descrizione;

  Nazionalita(super.id, this.codice, this.descrizione);

  static Nazionalita fromJSON(Map<String, dynamic> json) {
    JSONDecoder decoder = JSONDecoder(json);

    String codice = decoder.getString('cod');
    String descrizione = decoder.getString('naz');

    return Nazionalita(decoder.getId, codice, descrizione);
  }

  static List<Nazionalita> listFromJSON(List<dynamic> list) {
    return list.map((e) => Nazionalita.fromJSON(e)).toList();
  }

  static List<Nazionalita>? _dummyList;

  static Future<List<Nazionalita>> get dummyList async {
    if (_dummyList == null) {
      dynamic data = json.decode(await getData());
      _dummyList = listFromJSON(data);
    }

    return _dummyList!;
  }

  static Future<String> getData() async {
    return await rootBundle.loadString('assets/data/nazionalita.json');
  }
}

class Paesi extends IdentifierModel {
  String? blacklist;
  String? sigla;
  String? iso;
  String? descrizione;
  String? codice;

  Paesi(super.id, this.blacklist, this.sigla, this.iso, this.descrizione,
      this.codice);

  static Paesi fromJSON(Map<String, dynamic> json) {
    JSONDecoder decoder = JSONDecoder(json);
    String? blacklist = decoder.getString('BackList');
    String? sigla = decoder.getString('Sigla');
    String? iso = decoder.getString('Iso');
    String? descrizione = decoder.getString('Paese');
    String? codice = decoder.getString('Codice');

    return Paesi(decoder.getId, blacklist, sigla, iso, descrizione, codice);
  }

  static List<Paesi> listFromJSON(List<dynamic> list) {
    return list.map((e) => Paesi.fromJSON(e)).toList();
  }

  static List<Paesi>? _dummyList;

  static Future<List<Paesi>> get dummyList async {
    if (_dummyList == null) {
      dynamic data = json.decode(await getData());
      _dummyList = listFromJSON(data);
    }

    return _dummyList!;
  }

  static Future<String> getData() async {
    String a = await rootBundle.loadString('assets/data/paesi.json');
    return a;
  }
}

class Comuni extends IdentifierModel {
  String? provincia;
  String? localita;
  String? cap;
  String? prefisso;

  Comuni(super.id, this.provincia, this.localita, this.cap, this.prefisso);

  static Comuni fromJSON(Map<String, dynamic> json) {
    JSONDecoder decoder = JSONDecoder(json);
    String? provincia = decoder.getString('Provincia');
    String? localita = decoder.getString('Localita');
    String? cap = decoder.getString('Cap');
    String? prefisso = decoder.getString('Prefisso');

    return Comuni(decoder.getId, provincia, localita, cap, prefisso);
  }

  static List<Comuni> listFromJSON(List<dynamic> list) {
    return list.map((e) => Comuni.fromJSON(e)).toList();
  }

  static List<Comuni>? _dummyList;

  static Future<List<Comuni>> get dummyList async {
    if (_dummyList == null) {
      dynamic data = json.decode(await getData());
      _dummyList = listFromJSON(data);
    }

    return _dummyList!;
  }

  static Future<String> getData() async {
    String a = await rootBundle.loadString('assets/data/comuni.json');
    return a;
  }
}
