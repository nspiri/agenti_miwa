import 'dart:convert';
import 'package:foody/helpers/services/json_decoder.dart';
import 'package:foody/helpers/utils/do_http_request.dart';
import 'package:foody/model/identifier_model.dart';
import 'package:foody/model/request.dart';

class Pagamenti extends IdentifierModel {
  int? numero;
  String? descrizione;

  Pagamenti(super.id, this.numero, this.descrizione);

  static Pagamenti fromJSON(Map<String, dynamic> json) {
    JSONDecoder decoder = JSONDecoder(json);

    int numero = decoder.getInt('cpnum');
    String descrizione = decoder.getString('cpdes');

    return Pagamenti(decoder.getId, numero, descrizione);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cpnum'] = numero;
    data['cpdes'] = descrizione;
    return data;
  }

  static List<Pagamenti> listFromJSON(List<dynamic> list) {
    return list.map((e) => Pagamenti.fromJSON(e)).toList();
  }

  static List<Pagamenti>? _dummyList;

  static Future<List<Pagamenti>> get dummyList async {
    if (_dummyList == null) {
      dynamic data = json.decode(await getData());
      _dummyList = listFromJSON(data);
    }

    return _dummyList!;
  }

  static Future<String> getData() async {
    Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrcli", etichettaCollage: "PAGAMENTI", dati: null);

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
