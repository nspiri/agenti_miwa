import 'dart:convert';

import 'package:foody/helpers/services/json_decoder.dart';
import 'package:foody/helpers/utils/do_http_request.dart';
import 'package:foody/model/identifier_model.dart';
import 'package:foody/model/request.dart';

class Articolo extends IdentifierModel {
  String? codArt;
  int? codCatSconti;
  String? descrizione;
  int? codCatListini;
  String? catStatistica;
  String? codAlt;
  String? um1;
  String? iva;
  int? confArt;
  int? codCatScontiQta;
  int? numDecArt;
  String? notaArt;
  int? disponibile;
  int? codCatProvv;
  int? esistenza;
  List<Arprz>? prezzoListini;

  Articolo(
      super.id,
      this.codArt,
      this.codCatSconti,
      this.descrizione,
      this.codCatListini,
      this.catStatistica,
      this.codAlt,
      this.um1,
      this.iva,
      this.confArt,
      this.codCatScontiQta,
      this.numDecArt,
      this.notaArt,
      this.disponibile,
      this.codCatProvv,
      this.esistenza,
      this.prezzoListini);

  static Articolo fromJSON(Map<String, dynamic> json) {
    JSONDecoder decoder = JSONDecoder(json);

    String codArt = decoder.getString('arcod');
    int codCatSconti = decoder.getInt('arscq');
    String descrizione = decoder.getString('ardsc');
    int codCatListini = decoder.getInt('arlis');
    String catStatistica = decoder.getString('mydes');
    String codAlt = decoder.getString('aralt');
    String um1 = decoder.getString('arum1');
    String iva = decoder.getString('ariva');
    int confArt = decoder.getInt('arcon');
    int codCatScontiQta = decoder.getInt('arscq');
    int numDecArt = decoder.getInt('ardec');
    String notaArt = decoder.getString('arnds');
    int disponibile = decoder.getInt('aqdin');
    int codCatProvv = decoder.getInt('arpro');
    int esistenza = decoder.getInt('aqesi');
    List<Arprz> prezzoListini = [];
    if (json['arprz'] != null) {
      prezzoListini = <Arprz>[];
      json['arprz'].forEach((v) {
        prezzoListini.add(new Arprz.fromJson(v));
      });
    }

    return Articolo(
        decoder.getId,
        codArt,
        codCatSconti,
        descrizione,
        codCatListini,
        catStatistica,
        codAlt,
        um1,
        iva,
        confArt,
        codCatScontiQta,
        numDecArt,
        notaArt,
        disponibile,
        codCatProvv,
        esistenza,
        prezzoListini);
  }

  static List<Articolo> listFromJSON(List<dynamic> list) {
    return list.map((e) => Articolo.fromJSON(e)).toList();
  }

  static List<Articolo>? _dummyList;

  static Future<List<Articolo>> get dummyList async {
    if (_dummyList == null) {
      dynamic data = json.decode(await getData());
      _dummyList = listFromJSON(data);
    }

    return _dummyList!;
  }

  static Future<String> getData() async {
    Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrart",
        etichettaCollage: "ARTICOLI",
        dati: {"magazzino": 1});

    if (res.code == 200) {
      var a = res.result as List<dynamic>;
      if (a.isEmpty) {
        return "";
      }
      return jsonEncode(a);
    } else {
      return "";
    }
    //return await rootBundle.loadString('assets/data/clienti.json');
  }
}

class Arprz {
  int? listino;
  double? valore;

  Arprz({this.listino, this.valore});

  Arprz.fromJson(Map<String, dynamic> json) {
    listino = json['listino'];
    valore = json['valore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['listino'] = listino;
    data['valore'] = valore;
    return data;
  }
}
