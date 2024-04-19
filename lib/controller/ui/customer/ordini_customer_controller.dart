import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foody/helpers/storage/local_storage.dart';
import 'package:foody/helpers/utils/do_http_request.dart';
import 'package:foody/helpers/utils/global.dart';
import 'package:foody/model/customer_detail.dart';
import 'package:foody/model/ordine.dart';
import 'package:foody/views/my_controller.dart';
import 'package:foody/views/ui/customer/ordini_customer_screen.dart';
import 'package:get/get.dart';
import 'package:foody/model/request.dart' as r;

class OrdiniListCustomerController extends MyController {
  List<Ordine> ordini = [];
  DataTableSource? data;
  bool? dataAsc = true, doc, ragSoc, localita, totale;
  CustomerDetail? clienteSelezionato;
  bool isLoading = true;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onThemeChanged() {
    data = MyDataDetailOrdiniCustomer(ordini, this);
    update();
  }

  getOrdini(CustomerDetail cliente) async {
    isLoading = true;
    update();
    clienteSelezionato = cliente;
    r.Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrdoc",
        etichettaCollage: "OC_ELENCO",
        dati: {
          "agente": LocalStorage.getLoggedUser()?.codiceAgente,
          "cliente": cliente.codCliFattA != ""
              ? cliente.codCliFattA
              : cliente.codiceCliente
        });
    isLoading = false;
    update();
    if (res.code == 200) {
      var a = res.result as dynamic;
      List<dynamic> dati = json.decode(jsonEncode(a));
      if (dati != []) {
        ordini = dati.map((e) => Ordine.fromJson(e)).toList();
        ordini
            .sort((a, b) => int.parse(b.ocdat!).compareTo(int.parse(a.ocdat!)));
        data = MyDataDetailOrdiniCustomer(ordini, this);
      }
      update();
    } else {
      //ERRORE
      return null;
    }
  }

  goToDettaglio(Ordine ordine) async {
    ordineSelezionato = ordine;
    Get.toNamed('/admin/orderdetail', arguments: ordine);
    /* for (var element in ordini) {
      if ("${element.ocsig}${element.ocser}${element.ocnum}" ==
          "${ordine.ocsig}${ordine.ocser}${ordine.ocnum}") {
        if (element.rigaDettaglio.isEmpty) {
          element.rigaDettaglio = await getDettalioOrdine(ordine);
        }
        Get.toNamed('/admin/orderdetail', arguments: element);
      }
    }*/
  }

  getDettalioOrdine(Ordine ordine) async {
    r.Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrdoc",
        etichettaCollage: "OC_DETTAGLIO",
        dati: {
          "sigla": ordine.ocsig,
          "serie": ordine.ocser,
          "numero": ordine.ocnum
        });

    if (res.code == 200) {
      var a = res.result as dynamic;
      List<dynamic> dati = json.decode(jsonEncode(a));
      if (dati != []) {
        List<RigaDettaglio> dett =
            dati.map((e) => RigaDettaglio.fromJson(e)).toList();
        return dett;
      }
    } else {
      //ERRORE
      return null;
    }
  }

  void filterByName(String value) {
    if (value == "") {
      data = MyDataDetailOrdiniCustomer(ordini, this);
    } else {
      var filterCustomers = ordini
          .where((element) =>
              element.occliDesc!.toLowerCase().contains(value.toLowerCase()) ||
              element.ocsig!.toLowerCase().contains(value.toLowerCase()))
          .toList();
      data = MyDataDetailOrdiniCustomer(filterCustomers, this);
    }
    update();
  }

  void orderByDoc() {
    ragSoc = null;
    totale = null;
    localita = null;
    dataAsc = null;
    doc ??= true;
    if (doc!) {
      ordini.sort((a, b) => ("${a.ocsig}${a.ocser}${a.ocnum}")
          .compareTo(("${b.ocsig}${b.ocser}${b.ocnum}")));
      data = MyDataDetailOrdiniCustomer(ordini, this);
    } else {
      ordini.sort((a, b) => ("${b.ocsig}${b.ocser}${b.ocnum}")
          .compareTo(("${a.ocsig}${a.ocser}${a.ocnum}")));
      data = MyDataDetailOrdiniCustomer(ordini, this);
    }
    doc = !doc!;
    update();
  }

  void orderByData() {
    ragSoc = null;
    doc = null;
    totale = null;
    localita = null;
    dataAsc ??= false;
    if (dataAsc!) {
      ordini.sort((a, b) => int.parse(a.ocdat!).compareTo(int.parse(b.ocdat!)));
      data = MyDataDetailOrdiniCustomer(ordini, this);
    } else {
      ordini.sort((a, b) => int.parse(b.ocdat!).compareTo(int.parse(a.ocdat!)));
      data = MyDataDetailOrdiniCustomer(ordini, this);
    }
    dataAsc = !dataAsc!;
    update();
  }

  void orderByRagSoc() {
    doc = null;
    totale = null;
    localita = null;
    dataAsc = null;
    ragSoc ??= true;
    if (ragSoc!) {
      ordini.sort((a, b) => a.occliDesc!.compareTo(b.occliDesc!));
      data = MyDataDetailOrdiniCustomer(ordini, this);
    } else {
      ordini.sort((a, b) => b.occliDesc!.compareTo(a.occliDesc!));
      data = MyDataDetailOrdiniCustomer(ordini, this);
    }
    ragSoc = !ragSoc!;
    update();
  }

  void orderByLocalita() {
    doc = null;
    totale = null;
    dataAsc = null;
    ragSoc = null;
    localita ??= true;
    if (localita!) {
      ordini.sort((a, b) => a.occliLoc!.compareTo(b.occliLoc!));
      data = MyDataDetailOrdiniCustomer(ordini, this);
    } else {
      ordini.sort((a, b) => b.occliLoc!.compareTo(a.occliLoc!));
      data = MyDataDetailOrdiniCustomer(ordini, this);
    }
    localita = !localita!;
    update();
  }

  void orderByTot() {
    doc = null;
    dataAsc = null;
    ragSoc = null;
    localita = null;
    totale ??= true;
    if (totale!) {
      ordini.sort((a, b) => a.octdp!.compareTo(b.octdp!));
      data = MyDataDetailOrdiniCustomer(ordini, this);
    } else {
      ordini.sort((a, b) => b.octdp!.compareTo(a.octdp!));
      data = MyDataDetailOrdiniCustomer(ordini, this);
    }
    totale = !totale!;
    update();
  }
}
