import 'dart:convert';

import 'package:foody/helpers/services/json_decoder.dart';
import 'package:foody/helpers/utils/do_http_request.dart';
import 'package:foody/model/identifier_model.dart';
import 'package:foody/model/request.dart';

class Listino extends IdentifierModel {
  String? descrizione;
  int? numero;

  Listino(super.id, this.descrizione, this.numero);

  static Listino fromJSON(Map<String, dynamic> json) {
    JSONDecoder decoder = JSONDecoder(json);

    String descrizione = decoder.getString('mldes');
    int numero = decoder.getInt('mlnum');

    return Listino(
      decoder.getId,
      descrizione,
      numero,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mldes'] = descrizione;
    data['mlnum'] = numero;
    return data;
  }

  static List<Listino> listFromJSON(List<dynamic> list) {
    return list.map((e) => Listino.fromJSON(e)).toList();
  }

  static List<Listino>? _dummyList;

  static Future<List<Listino>> get dummyList async {
    if (_dummyList == null) {
      dynamic data = json.decode(await getData());
      _dummyList = listFromJSON(data);
    }

    return _dummyList!;
  }

  static Future<String> getData() async {
    Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrart", etichettaCollage: "LISTINI", dati: {});

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
