import 'dart:convert';
import 'package:mexalorder/helpers/services/json_decoder.dart';
import 'package:mexalorder/helpers/utils/do_http_request.dart';
import 'package:mexalorder/model/identifier_model.dart';
import 'package:mexalorder/model/request.dart';

class ZoneClienti extends IdentifierModel {
  int? idC;
  String? cydes;

  ZoneClienti(super.id, this.idC, this.cydes);

  static ZoneClienti fromJSON(Map<String, dynamic> json) {
    JSONDecoder decoder = JSONDecoder(json);

    int idC = decoder.getInt('id');
    String cydes = decoder.getString('cydes');

    return ZoneClienti(decoder.getId, idC, cydes);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = idC;
    data['cydes'] = cydes;
    return data;
  }

  static List<ZoneClienti> listFromJSON(List<dynamic> list) {
    return list.map((e) => ZoneClienti.fromJSON(e)).toList();
  }

  static List<ZoneClienti>? _dummyList;

  static Future<List<ZoneClienti>> get dummyList async {
    if (_dummyList == null) {
      dynamic data = json.decode(await getData());
      _dummyList = listFromJSON(data);
    }

    return _dummyList!;
  }

  static Future<String> getData() async {
    Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrcli", etichettaCollage: "TAB_ZONE", dati: {});

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
