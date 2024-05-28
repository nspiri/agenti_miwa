import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:mexalorder/helpers/services/json_decoder.dart';
import 'package:mexalorder/model/identifier_model.dart';

class TipoSocieta extends IdentifierModel {
  String? numero;
  String? descrizione;

  TipoSocieta(super.id, this.numero, this.descrizione);

  static TipoSocieta fromJSON(Map<String, dynamic> json) {
    JSONDecoder decoder = JSONDecoder(json);

    String numero = decoder.getString('numero');
    String descrizione = decoder.getString('desc');

    return TipoSocieta(decoder.getId, numero, descrizione);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['numero'] = numero;
    data['desc'] = descrizione;
    return data;
  }

  static List<TipoSocieta> listFromJSON(List<dynamic> list) {
    return list.map((e) => TipoSocieta.fromJSON(e)).toList();
  }

  static List<TipoSocieta>? _dummyList;

  static Future<List<TipoSocieta>> get dummyList async {
    if (_dummyList == null) {
      dynamic data = json.decode(await getData());
      _dummyList = listFromJSON(data);
    }

    return _dummyList!;
  }

  static Future<String> getData() async {
    return await rootBundle.loadString('assets/data/tipo_soc.json');
  }
}
