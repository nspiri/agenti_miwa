import 'dart:convert';
import 'dart:typed_data';

import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';
import 'package:mexalorder/helpers/services/json_decoder.dart';
import 'package:mexalorder/helpers/storage/local_storage.dart';
import 'package:mexalorder/helpers/utils/do_http_request.dart';
import 'package:mexalorder/model/identifier_model.dart';
import 'package:mexalorder/model/request.dart';

class Articolo extends IdentifierModel {
  String? codArt;
  int? codCatSconti;
  String? descrizione;
  int? codCatListini;
  String? catStatistica;
  String? codAlt;
  String? um1;
  String? iva;
  double? conf = 0;
  double? qtaArt;
  int? codCatScontiQta;
  int? numDecArt;
  String? notaArt;
  double? disponibile;
  int? codCatProvv;
  int? esistenza;
  List<Arprz>? prezzoListini;
  Uint8List? icona;
  PrezzoArticolo? prezzoArticolo;
  Arprz? listinoSelezionato;
  ScalaSconti? scontoSelezionato;
  double importo = 0;
  double importoTotale = 0;
  bool applicaOmaggio = false;
  bool /*loading = true,*/ loadingPrezzo = false;
  int? nrVendite;
  String? ultimaVendita;
  final TextEditingController textControllerListino = TextEditingController();
  final SuggestionsBoxController controllerListino = SuggestionsBoxController();
  final TextEditingController textControllerSconto = TextEditingController();
  final SuggestionsBoxController controllerSconto = SuggestionsBoxController();

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
      this.qtaArt,
      this.codCatScontiQta,
      this.numDecArt,
      this.notaArt,
      this.disponibile,
      this.codCatProvv,
      this.esistenza,
      this.prezzoListini,
      this.nrVendite,
      this.ultimaVendita,
      this.conf,
      this.listinoSelezionato);

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
    double qtaArt = decoder.getDouble('arcon');
    int codCatScontiQta = decoder.getInt('arscq');
    int numDecArt = decoder.getInt('ardec');
    String notaArt = decoder.getString('arnds');
    double disponibile = decoder.getDouble('aqdin');
    int codCatProvv = decoder.getInt('arpro');
    int esistenza = decoder.getInt('aqesi');
    int nrVendite = decoder.getInt('nr_vendite');
    double conf = decoder.getDouble('conf');
    String ultimaVendita = decoder.getString('ultima_vendita');
    List<Arprz> prezzoListini = [];
    if (json['arprz'] != null) {
      prezzoListini = <Arprz>[];
      json['arprz'].forEach((v) {
        prezzoListini.add(new Arprz.fromJson(v));
      });
    }
    Arprz? listinoSelezionato;
    if (json['listino_sel'] != null) {
      listinoSelezionato = Arprz.fromJson(json['listino_sel']);
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
        qtaArt,
        codCatScontiQta,
        numDecArt,
        notaArt,
        disponibile,
        codCatProvv,
        esistenza,
        prezzoListini,
        nrVendite,
        ultimaVendita,
        conf,
        listinoSelezionato);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['arcod'] = codArt;
    data['ardsc'] = descrizione;
    data['aralt'] = codAlt;
    data['arsco'] = codCatSconti;
    data['ariva'] = iva;
    data['aqdin'] = disponibile;
    data['arum1'] = um1;
    data['arlis'] = codCatListini;
    data['ardec'] = numDecArt;
    data['aqesi'] = esistenza;
    data['arpro'] = codCatProvv;
    data['arcon'] = qtaArt;
    data['mydes'] = catStatistica;
    data['arnds'] = notaArt;
    data['conf'] = conf;
    if (prezzoListini != null) {
      data['arprz'] = prezzoListini?.map((v) => v.toJson()).toList();
    }
    data['listino_sel'] = listinoSelezionato;
    data['arscq'] = codCatScontiQta;
    return data;
  }

  static List<Articolo> listFromJSON(List<dynamic> list) {
    return list.map((e) => Articolo.fromJSON(e)).toList();
  }

  static List<Articolo>? _dummyList;

  static Future<List<Articolo>> get dummyList async {
    if (_dummyList == null) {
      bool offline = LocalStorage.getOffline();
      if (offline) {
        return LocalStorage.getArticoli() ?? [];
      } else {
        dynamic data = json.decode(await getData());
        _dummyList = listFromJSON(data);
      }
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
  String? descrizione = "";

  Arprz({this.listino, this.valore, this.descrizione});

  Arprz.fromJson(Map<String, dynamic> json) {
    listino = json['listino'];
    valore = json['valore'];
    descrizione = json['descrizione'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['listino'] = listino;
    data['valore'] = valore;
    data['descrizione'] = descrizione;
    return data;
  }
}

class PrezzoArticolo {
  double? prezzo;
  Omaggio? omaggio;
  String? sconto;
  List<ScalaSconti>? scalaSconti;
  String? tipoProvvigione;
  double? provvigione;

  PrezzoArticolo(
      {this.prezzo,
      this.omaggio,
      this.sconto,
      this.scalaSconti,
      this.tipoProvvigione,
      this.provvigione});

  PrezzoArticolo.fromJson(Map<String, dynamic> json) {
    prezzo = json['prezzo'];
    omaggio =
        json['omaggio'] != null ? new Omaggio.fromJson(json['omaggio']) : null;
    sconto = json['sconto'];
    if (json['scala_sconti'] != null) {
      scalaSconti = <ScalaSconti>[];
      json['scala_sconti'].forEach((v) {
        scalaSconti!.add(new ScalaSconti.fromJson(v));
      });
    }
    tipoProvvigione = json['tipo_provvigione'];
    provvigione = json['provvigione'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prezzo'] = prezzo;
    if (omaggio != null) {
      data['omaggio'] = omaggio!.toJson();
    }
    data['sconto'] = sconto;
    if (scalaSconti != null) {
      data['scala_sconti'] = scalaSconti!.map((v) => v.toJson()).toList();
    }
    data['tipo_provvigione'] = tipoProvvigione;
    data['provvigione'] = provvigione;
    return data;
  }
}

class Omaggio {
  int? qtaPresa;
  int? qtaPagata;

  Omaggio({this.qtaPresa, this.qtaPagata});

  Omaggio.fromJson(Map<String, dynamic> json) {
    qtaPresa = json['qta_presa'];
    qtaPagata = json['qta_pagata'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['qta_presa'] = qtaPresa;
    data['qta_pagata'] = qtaPagata;
    return data;
  }
}

class ScalaSconti {
  double? prezzo;
  String? sconto;
  String? tipoProvvigione;
  double? provvigione;

  ScalaSconti(
      {this.prezzo, this.sconto, this.tipoProvvigione, this.provvigione});

  ScalaSconti.fromJson(Map<String, dynamic> json) {
    prezzo = json['prezzo'];
    sconto = json['sconto'];
    tipoProvvigione = json['tipo_provvigione'];
    provvigione = json['provvigione'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prezzo'] = prezzo;
    data['sconto'] = sconto;
    data['tipo_provvigione'] = tipoProvvigione;
    data['provvigione'] = provvigione;
    return data;
  }
}

class CondDoc {
  String? aralt;
  int? ardec;
  String? arcod;
  double? arcon;
  String? ardsc;
  int? prezzoDecimali;
  String? arum1;
  int? arsco;
  Omaggio? omaggio;
  String? ariva;
  double? aqdin;
  String? mydes;
  List<dynamic>? arime;
  String? arnds;
  int? arscq;
  int? arlis;
  double? provvigione;
  int? arpro;
  double? aqesi;
  Uint8List? arcae;
  List<dynamic>? arice;
  List<Arprz>? arprz;
  double? prezzo;
  String? sconto;
  String? tipoProvvigione;
  List<ScalaSconti>? scalaSconti;

  CondDoc(
      {this.aralt,
      this.ardec,
      this.arcod,
      this.arcon,
      this.ardsc,
      this.prezzoDecimali,
      this.arum1,
      this.arsco,
      this.omaggio,
      this.ariva,
      this.aqdin,
      this.mydes,
      this.arime,
      this.arnds,
      this.arscq,
      this.arlis,
      this.provvigione,
      this.arpro,
      this.aqesi,
      this.arcae,
      this.arice,
      this.arprz,
      this.prezzo,
      this.sconto,
      this.tipoProvvigione,
      this.scalaSconti});

  CondDoc.fromJson(Map<String, dynamic> json) {
    aralt = json['aralt'];
    ardec = json['ardec'];
    arcod = json['arcod'];
    arcon = json['arcon'];
    ardsc = json['ardsc'];
    prezzoDecimali = json['prezzo_decimali'];
    arum1 = json['arum1'];
    arsco = json['arsco'];
    omaggio =
        json['omaggio'] != null ? new Omaggio.fromJson(json['omaggio']) : null;
    ariva = json['ariva'];
    aqdin = json['aqdin'];
    mydes = json['mydes'];
    arime = getImmagineArticolo(json['arime']);
    arnds = json['arnds'];
    arscq = json['arscq'];
    arlis = json['arlis'];
    provvigione = json['provvigione'];
    arpro = json['arpro'];
    aqesi = json['aqesi'];
    arcae = getImmagineArticolo(json['arcae']);
    arice = getImmagineArticolo(json['arice']);
    if (json['arprz'] != null) {
      arprz = <Arprz>[];
      json['arprz'].forEach((v) {
        arprz!.add(new Arprz.fromJson(v));
      });
    }
    prezzo = json['prezzo'];
    sconto = json['sconto'];
    tipoProvvigione = json['tipo_provvigione'];
    if (json['scala_sconti'] != null) {
      scalaSconti = <ScalaSconti>[];
      json['scala_sconti'].forEach((v) {
        scalaSconti!.add(new ScalaSconti.fromJson(v));
      });
    }
  }

  Uint8List? getImmagineArticolo(List<dynamic>? result) {
    String img = "";
    if (result != null) {
      if (result.isNotEmpty) {
        for (String element in result) {
          img += element;
        }
        return base64
            .decode(img.replaceAll(RegExp(r'\s+'), '').replaceAll("[", ""));
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['aralt'] = aralt;
    data['ardec'] = ardec;
    data['arcod'] = arcod;
    data['arcon'] = arcon;
    data['ardsc'] = ardsc;
    data['prezzo_decimali'] = prezzoDecimali;
    data['arum1'] = arum1;
    data['arsco'] = arsco;
    if (omaggio != null) {
      data['omaggio'] = omaggio!.toJson();
    }
    data['ariva'] = ariva;
    data['aqdin'] = aqdin;
    data['mydes'] = mydes;
    data['arime'] = arime;
    data['arnds'] = arnds;
    data['arscq'] = arscq;
    data['arlis'] = arlis;
    data['provvigione'] = provvigione;
    data['arpro'] = arpro;
    data['aqesi'] = aqesi;
    data['arcae'] = arcae;
    data['arice'] = arice;
    if (arprz != null) {
      data['arprz'] = arprz!.map((v) => v.toJson()).toList();
    }
    data['prezzo'] = prezzo;
    data['sconto'] = sconto;
    data['tipo_provvigione'] = tipoProvvigione;
    if (scalaSconti != null) {
      data['scala_sconti'] = scalaSconti!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
