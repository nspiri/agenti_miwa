import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foody/helpers/utils/do_http_request.dart';
import 'package:foody/model/customer_detail.dart';
import 'package:foody/model/order_detail.dart';
import 'package:foody/model/request.dart';
import 'package:foody/model/storico.dart';
import 'package:foody/views/my_controller.dart';
import 'package:foody/views/ui/customer/customer_detail_screen.dart';

class CustomerDetailController extends MyController {
  List<OrderDetail> ordersDetail = [];
  CustomerDetail? dettaglio;
  Storico? storico;
  DataTableSource? data;

  String codCliente;

  CustomerDetailController({required this.codCliente});

  @override
  void onInit() {
    OrderDetail.dummyList.then((value) {
      ordersDetail = value.sublist(0, 10);
      data = MyDataDetailOrder(ordersDetail);
      update();
    });
    //getDettaglioCliente(codCliente).then((value) => dettaglio = value);
    super.onInit();
  }

  getData(String codCliente) async {
    getDettaglioCliente(codCliente);
    getStoricoCliente(codCliente);
  }

  getDettaglioCliente(String codCliente) async {
    Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrcli",
        etichettaCollage: "CLIENTE",
        dati: {"cliente": codCliente});

    if (res.code == 200) {
      var a = res.result as dynamic;
      dynamic data = json.decode(jsonEncode(a));
      dettaglio = CustomerDetail.listFromJSON(data[0]);
      update();
    } else {
      //ERRORE
      return null;
    }
  }

  getStoricoCliente(String codCliente) async {
    Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrcli",
        etichettaCollage: "STORICO",
        dati: {"cliente": codCliente, "articolo": ""});

    if (res.code == 200) {
      var a = res.result as dynamic;
      dynamic data = json.decode(jsonEncode(a));
      storico = Storico.fromJson(data[0] ?? []);
      update();
    } else {
      //ERRORE
      return null;
    }
  }
}
