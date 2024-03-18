import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foody/helpers/storage/local_storage.dart';
import 'package:foody/helpers/utils/do_http_request.dart';
import 'package:foody/helpers/utils/global.dart';
import 'package:foody/helpers/utils/utils.dart';
import 'package:foody/model/scadenziario_cliente.dart';
import 'package:foody/views/my_controller.dart';
import 'package:foody/views/ui/customer/scadenziario_customer_screen.dart';
import 'package:foody/model/request.dart' as r;

class ScadenziarioController extends MyController {
  List<ScadenziarioCliente> scadenziario = [];
  DataTableSource? data;
  bool? dataAsc = true, dataScad, importo, ragSoc, doc;
  String? codiceCliente;

  @override
  void onInit() {
    super.onInit();
    getScadenziarioCliente();
  }

  @override
  void onThemeChanged() {
    data = MyDataDetailScadenziarioCliente(scadenziario);
    update();
  }

  getScadenziarioCliente() async {
    codiceCliente = clienteSelezionato?.codiceCliente;
    r.Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrcli",
        etichettaCollage: "GET_SCAD",
        dati: {
          "agente": LocalStorage.getLoggedUser()?.codiceAgente,
          "cliente": clienteSelezionato?.codiceCliente ?? ""
        });

    if (res.code == 200) {
      var a = res.result as dynamic;
      List<dynamic> dati = json.decode(jsonEncode(a));
      if (dati != []) {
        scadenziario =
            dati.map((e) => ScadenziarioCliente.fromJson(e)).toList();
        scadenziario
            .sort((a, b) => int.parse(b.data!).compareTo(int.parse(a.data!)));
        data = MyDataDetailScadenziarioCliente(scadenziario);
      }
      update();
    } else {
      //ERRORE
      return null;
    }
  }

  String get totale {
    double totale = 0;
    for (var element in scadenziario) {
      totale = totale + (element.importo ?? 0).toDouble();
    }
    return Utils.formatStringDecimal(totale, 2);
  }

  void filterByName(String value) {
    if (value == "") {
      data = MyDataDetailScadenziarioCliente(scadenziario);
    } else {
      var filterCustomers = scadenziario
          .where((element) =>
              element.ragioneSociale!
                  .toLowerCase()
                  .contains(value.toLowerCase()) ||
              element.documento!.toLowerCase().contains(value.toLowerCase()))
          .toList();
      data = MyDataDetailScadenziarioCliente(filterCustomers);
    }
    update();
  }

  void orderByData() {
    ragSoc = null;
    doc = null;
    importo = null;
    dataScad = null;
    dataAsc ??= false;
    if (dataAsc!) {
      scadenziario
          .sort((a, b) => int.parse(a.data!).compareTo(int.parse(b.data!)));
      data = MyDataDetailScadenziarioCliente(scadenziario);
    } else {
      scadenziario
          .sort((a, b) => int.parse(b.data!).compareTo(int.parse(a.data!)));
      data = MyDataDetailScadenziarioCliente(scadenziario);
    }
    dataAsc = !dataAsc!;
    update();
  }

  void orderByDataScad() {
    ragSoc = null;
    doc = null;
    importo = null;
    dataAsc = null;
    dataScad ??= false;
    if (dataScad!) {
      scadenziario.sort((a, b) =>
          int.parse(a.dataScadenza!).compareTo(int.parse(b.dataScadenza!)));
      data = MyDataDetailScadenziarioCliente(scadenziario);
    } else {
      scadenziario.sort((a, b) =>
          int.parse(b.dataScadenza!).compareTo(int.parse(a.dataScadenza!)));
      data = MyDataDetailScadenziarioCliente(scadenziario);
    }
    dataScad = !dataScad!;
    update();
  }

  void orderByImporto() {
    ragSoc = null;
    doc = null;
    dataAsc = null;
    dataScad = null;
    importo ??= true;

    if (importo!) {
      scadenziario.sort((a, b) => a.importo!.compareTo(b.importo!));
      data = MyDataDetailScadenziarioCliente(scadenziario);
    } else {
      scadenziario.sort((a, b) => b.importo!.compareTo(a.importo!));
      data = MyDataDetailScadenziarioCliente(scadenziario);
    }
    importo = !importo!;
    update();
  }

  void orderByRagSoc() {
    doc = null;
    dataAsc = null;
    dataScad = null;
    importo = null;
    ragSoc ??= true;
    if (ragSoc!) {
      scadenziario
          .sort((a, b) => b.ragioneSociale!.compareTo(a.ragioneSociale!));
      data = MyDataDetailScadenziarioCliente(scadenziario);
    } else {
      scadenziario
          .sort((a, b) => a.ragioneSociale!.compareTo(b.ragioneSociale!));
      data = MyDataDetailScadenziarioCliente(scadenziario);
    }
    ragSoc = !ragSoc!;
    update();
  }

  void orderByDoc() {
    dataAsc = null;
    dataScad = null;
    importo = null;
    ragSoc = null;
    doc ??= true;
    if (doc!) {
      scadenziario.sort((a, b) => ("${b.documento}${b.serie}${b.numero}")
          .compareTo(("${a.documento}${a.serie}${a.numero}")));
      data = MyDataDetailScadenziarioCliente(scadenziario);
    } else {
      scadenziario.sort((a, b) => ("${a.documento}${a.serie}${a.numero}")
          .compareTo(("${b.documento}${b.serie}${b.numero}")));
      data = MyDataDetailScadenziarioCliente(scadenziario);
    }
    doc = !doc!;
    update();
  }
}
