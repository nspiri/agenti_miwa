import 'dart:convert';
import 'package:foody/helpers/services/json_decoder.dart';
import 'package:foody/helpers/utils/do_http_request.dart';
import 'package:foody/model/identifier_model.dart';
import 'package:foody/model/request.dart';
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
    if (_dummyList == null) {
      dynamic data = json.decode(await getData());
      _dummyList = listFromJSON(data);
    }

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
      return jsonEncode(a);
    } else {
      return "";
    }
    //return await rootBundle.loadString('assets/data/clienti.json');
  }
}





/*class CustomersList extends IdentifierModel {
  final String customerName, email, phone, status;
  final int order;
  final double totalOrders;
  final DateTime customerSince;

  CustomersList(super.id, this.customerName, this.email, this.phone,
      this.status, this.order, this.totalOrders, this.customerSince);

  static CustomersList fromJSON(Map<String, dynamic> json) {
    JSONDecoder decoder = JSONDecoder(json);

    String customerName = decoder.getString('customer_name');
    String email = decoder.getString('email');
    String phone = decoder.getString('phone');
    String status = decoder.getString('status');
    int order = decoder.getInt('order');
    double totalOrders = decoder.getDouble('total_orders');
    DateTime customerSince = decoder.getDateTime('customer_since');

    return CustomersList(decoder.getId, customerName, email, phone, status,
        order, totalOrders, customerSince);
  }

  static List<CustomersList> listFromJSON(List<dynamic> list) {
    return list.map((e) => CustomersList.fromJSON(e)).toList();
  }

  static List<CustomersList>? _dummyList;

  static Future<List<CustomersList>> get dummyList async {
    if (_dummyList == null) {
      dynamic data = json.decode(await getData());
      _dummyList = listFromJSON(data);
    }

    return _dummyList!.sublist(0, 50);
  }

  static Future<String> getData() async {
    return await rootBundle.loadString('assets/data/customers_list.json');
  }
}
*/