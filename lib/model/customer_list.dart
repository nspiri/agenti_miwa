import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mexalorder/helpers/services/json_decoder.dart';
import 'package:mexalorder/helpers/utils/do_http_request.dart';
import 'package:mexalorder/model/identifier_model.dart';
import 'package:mexalorder/model/request.dart';
import '../helpers/storage/local_storage.dart';

class CustomersList extends IdentifierModel {
  String? codice;
  String? telefono;
  String? email;
  String? indirizzo;
  String? descrizione;
  String? localita;
  String? provincia;
  String? dataUltimaConsegna;
  String? pIva;
  String? fatturareA;
  bool? loadingDownloadOffline = false;

  CustomersList(
      super.id,
      this.codice,
      this.telefono,
      this.email,
      this.indirizzo,
      this.descrizione,
      this.localita,
      this.provincia,
      this.dataUltimaConsegna,
      this.pIva,
      this.fatturareA);

  static CustomersList fromJSON(Map<String, dynamic> json) {
    JSONDecoder decoder = JSONDecoder(json);

    String pccod = decoder.getString('pccod');
    String pctel = decoder.getString('pctel');
    String pcint = decoder.getString('pcint');
    String pcind = decoder.getString('pcind');
    String pcdes = decoder.getString('pcdes');
    String pcloc = decoder.getString('pcloc');
    String pcpro = decoder.getString('pcpro');
    String pcduc = decoder.getString('pcduc');
    String pcnpi = decoder.getString('pcnpi');
    String pcfta = decoder.getString('pcfta');

    return CustomersList(decoder.getId, pccod, pctel, pcint, pcind, pcdes,
        pcloc, pcpro, pcduc, pcnpi, pcfta);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pccod'] = codice;
    data['pctel'] = telefono;
    data['pcint'] = email;
    data['pcind'] = indirizzo;
    data['pcdes'] = descrizione;
    data['pcloc'] = localita;
    data['pcpro'] = provincia;
    data['pcduc'] = dataUltimaConsegna;
    data['pcnpi'] = pIva;
    data['pcfta'] = fatturareA;
    return data;
  }

  static List<CustomersList> listFromJSON(List<dynamic> list) {
    return list.map((e) => CustomersList.fromJSON(e)).toList();
  }

  static List<CustomersList>? _dummyList;

  static Future<List<CustomersList>> get dummyList async {
    dynamic data = jsonDecode(await getData());
    _dummyList = listFromJSON(data);

    return _dummyList!;
  }

  static Future<String> getData() async {
    Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrcli",
        etichettaCollage: "CLIENTI",
        dati: {"agente": LocalStorage.getLoggedUser()?.codiceAgente});

    if (res.code == 200) {
      var a = res.result as List<dynamic>;
      if (a.isEmpty) {
        return "";
      }
      return json.encode(a);
    } else {
      return "";
    }
    //return await rootBundle.loadString('assets/data/clienti.json');
  }
}

class StatoCliente extends IdentifierModel {
  String? data;
  String? pccod;
  int? counter;
  String? pcdes;
  String? stato;
  bool? parcheggiare = false,
      riprovare = false,
      ferie = false,
      editable = true,
      gestito;
  TextEditingController controller = TextEditingController();

  StatoCliente(
      super.id, this.data, this.pccod, this.counter, this.pcdes, this.stato);

  static StatoCliente fromJSON(Map<String, dynamic> json) {
    JSONDecoder decoder = JSONDecoder(json);

    String data = decoder.getString('data');
    String pccod = decoder.getString('pccod');
    int counter = decoder.getInt('counter');
    String pcdes = decoder.getString('pcdes');
    String stato = decoder.getString('stato');

    return StatoCliente(decoder.getId, data, pccod, counter, pcdes, stato);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = data;
    data['pccod'] = pccod;
    data['counter'] = counter;
    data['pcdes'] = pcdes;
    data['stato'] = stato;
    return data;
  }

  static List<StatoCliente> listFromJSON(List<dynamic> list) {
    return list.map((e) => StatoCliente.fromJSON(e)).toList();
  }

  static List<StatoCliente>? _dummyList;

  static Future<List<StatoCliente>> get dummyList async {
    String dati = await getData();
    if (dati == "") {
      return [];
    }
    dynamic data = json.decode(await getData());
    _dummyList = listFromJSON(data);

    return _dummyList!;
  }

  static Future<String> getData() async {
    Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrcli",
        etichettaCollage: "CLIENTI_STATO",
        dati: {"agente": LocalStorage.getLoggedUser()?.codiceAgente});

    if (res.code == 200) {
      var a = res.result as List<dynamic>;
      if (a.isEmpty) {
        return "";
      }
      return jsonEncode(a);
    } else {
      return "";
    }
  }
}
