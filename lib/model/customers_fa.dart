import 'dart:convert';
import 'package:mexalorder/helpers/services/json_decoder.dart';
import 'package:mexalorder/helpers/utils/do_http_request.dart';
import 'package:mexalorder/model/identifier_model.dart';
import 'package:mexalorder/model/request.dart';
import '../helpers/storage/local_storage.dart';

class CustomersFA extends IdentifierModel {
  String? codice;
  String? descrizione;

  CustomersFA(super.id, this.codice, this.descrizione);

  static CustomersFA fromJSON(Map<String, dynamic> json) {
    JSONDecoder decoder = JSONDecoder(json);

    String pccod = decoder.getString('pccod');
    String pctel = decoder.getString('pcdes');

    return CustomersFA(decoder.getId, pccod, pctel);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pccod'] = codice;
    data['pcdes'] = descrizione;
    return data;
  }

  static List<CustomersFA> listFromJSON(List<dynamic> list) {
    return list.map((e) => CustomersFA.fromJSON(e)).toList();
  }

  static List<CustomersFA>? _dummyList;

  static Future<List<CustomersFA>> get dummyList async {
    if (_dummyList == null) {
      dynamic data = json.decode(await getData());
      _dummyList = listFromJSON(data);
    }

    return _dummyList!;
  }

  static Future<String> getData() async {
    Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrcli",
        etichettaCollage: "CLIENTI_FTA",
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
    //return await rootBundle.loadString('assets/data/clienti.json');
  }
}
