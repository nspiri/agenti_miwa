import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foody/helpers/storage/local_storage.dart';
import 'package:foody/helpers/utils/do_http_request.dart';
import 'package:foody/model/restaurant_data.dart';
import 'package:foody/model/scadenziario_cliente.dart';
import 'package:foody/views/my_controller.dart';
import 'package:foody/views/ui/Scadenziario/scadenziario_list.dart';
import 'package:get/get.dart';
import 'package:foody/model/request.dart' as r;

class RestaurantsListController extends MyController {
  List<ScadenziarioCliente> scadenziario = [];
  DataTableSource? data;
  bool dataAsc = true;

  @override
  void onInit() {
    super.onInit();
    getScadenziarioCliente();
  }

  getScadenziarioCliente() async {
    r.Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrcli",
        etichettaCollage: "GET_SCAD",
        dati: {
          "agente": LocalStorage.getLoggedUser()?.codiceAgente,
          "cliente": ""
        });

    if (res.code == 200) {
      var a = res.result as dynamic;
      List<dynamic> dati = json.decode(jsonEncode(a));
      if (dati != []) {
        scadenziario =
            dati.map((e) => ScadenziarioCliente.fromJson(e)).toList();
        scadenziario
            .sort((a, b) => int.parse(b.data!).compareTo(int.parse(a.data!)));
        data = MyDataDetailScadenziario(scadenziario);
      }
      update();
    } else {
      //ERRORE
      return null;
    }
  }

  void filterByName(String value) {
    if (value == "") {
      data = MyDataDetailScadenziario(scadenziario);
    } else {
      var filterCustomers = scadenziario
          .where((element) =>
              element.ragioneSociale!
                  .toLowerCase()
                  .contains(value.toLowerCase()) ||
              element.documento!.toLowerCase().contains(value.toLowerCase()))
          .toList();
      data = MyDataDetailScadenziario(filterCustomers);
    }
    update();
  }

  void orderByData() {
    if (dataAsc) {
      scadenziario
          .sort((a, b) => int.parse(a.data!).compareTo(int.parse(b.data!)));
      data = MyDataDetailScadenziario(scadenziario);
    } else {
      scadenziario
          .sort((a, b) => int.parse(b.data!).compareTo(int.parse(a.data!)));
      data = MyDataDetailScadenziario(scadenziario);
    }
    dataAsc = !dataAsc;
    update();
  }
}
