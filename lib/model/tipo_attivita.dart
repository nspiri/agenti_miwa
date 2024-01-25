import 'dart:convert';
import 'package:foody/helpers/services/json_decoder.dart';
import 'package:foody/helpers/utils/do_http_request.dart';
import 'package:foody/model/identifier_model.dart';
import 'package:foody/model/request.dart';

class TipoAttivita extends IdentifierModel {
  int? numero;
  String? descrizione;

  TipoAttivita(super.id, this.numero, this.descrizione);

  static TipoAttivita fromJSON(Map<String, dynamic> json) {
    JSONDecoder decoder = JSONDecoder(json);

    int numero = decoder.getInt('num');
    String descrizione = decoder.getString('des');

    return TipoAttivita(decoder.getId, numero, descrizione);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['num'] = numero;
    data['des'] = descrizione;
    return data;
  }

  static List<TipoAttivita> listFromJSON(List<dynamic> list) {
    return list.map((e) => TipoAttivita.fromJSON(e)).toList();
  }

  static List<TipoAttivita>? _dummyList;

  static Future<List<TipoAttivita>> get dummyList async {
    if (_dummyList == null) {
      dynamic data = json.decode(await getData());
      _dummyList = listFromJSON(data);
    }

    return _dummyList!;
  }

  static Future<String> getData() async {
    Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrcli", etichettaCollage: "TIPO_ATTIVITA", dati: null);

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
