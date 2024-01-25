import 'dart:convert';
import 'package:foody/helpers/services/json_decoder.dart';
import 'package:foody/helpers/utils/do_http_request.dart';
import 'package:foody/model/identifier_model.dart';
import 'package:foody/model/request.dart';

class CustomerCategory extends IdentifierModel {
  int? idC;
  String? cxdes;

  CustomerCategory(super.id, this.idC, this.cxdes);

  static CustomerCategory fromJSON(Map<String, dynamic> json) {
    JSONDecoder decoder = JSONDecoder(json);

    int idC = decoder.getInt('id');
    String cxdes = decoder.getString('cxdes');

    return CustomerCategory(decoder.getId, idC, cxdes);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = idC;
    data['cxdes'] = cxdes;
    return data;
  }

  static List<CustomerCategory> listFromJSON(List<dynamic> list) {
    return list.map((e) => CustomerCategory.fromJSON(e)).toList();
  }

  static List<CustomerCategory>? _dummyList;

  static Future<List<CustomerCategory>> get dummyList async {
    if (_dummyList == null) {
      dynamic data = json.decode(await getData());
      _dummyList = listFromJSON(data);
    }

    return _dummyList!;
  }

  static Future<String> getData() async {
    Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrcli", etichettaCollage: "TAB_CATSTAT", dati: {});

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
