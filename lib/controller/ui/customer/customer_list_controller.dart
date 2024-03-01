import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foody/helpers/utils/do_http_request.dart';
import 'package:foody/helpers/utils/global.dart';
import 'package:foody/helpers/utils/utils.dart';
import 'package:foody/model/customer_detail.dart';
import 'package:foody/model/customer_list.dart';
import 'package:foody/model/request.dart' as r;
import 'package:foody/views/my_controller.dart';
import 'package:foody/views/ui/customer/customer_list_screen.dart';
import 'package:get/get.dart';

class CustomerListController extends MyController {
  List<CustomersList> customers = [];
  DataTableSource? data;
  bool loading = true;

  bool? ragSoc = false, localita, provincia, ultCons;

  @override
  void onInit() {
    //init();
    super.onInit();
  }

  void init() {
    CustomersList.dummyList.then((value) {
      customers = value; //.sublist(10, value.length);
      customers.sort((a, b) =>
          a.descrizione!.toLowerCase().compareTo(b.descrizione!.toLowerCase()));
      data = MyData(customers, this);
      loading = false;
      update();
    });
  }

  @override
  void onThemeChanged() {
    data = MyData(customers, this);
    update();
  }

  goToOrder(String codCliente) async {
    CustomerDetail destinazione = await getCliente(codCliente);
    clienteSelezionato = destinazione;
    /* CustomerDetail? fattA;
    if (destinazione.codCliFattA != "") {
      fattA = await getCliente(destinazione.codCliFattA!);
    }*/
    Get.toNamed('/cart', arguments: destinazione);
  }

  goToDetail(String codCliente) async {
    clienteSelezionato = await getCliente(codCliente);
    Get.toNamed('/admin/customers/detail', arguments: clienteSelezionato);
  }

  getCliente(String codCliente) async {
    r.Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrcli",
        etichettaCollage: "CLIENTE",
        dati: {"cliente": codCliente});

    if (res.code == 200) {
      var a = res.result as dynamic;
      dynamic data = json.decode(jsonEncode(a));
      return CustomerDetail.listFromJSON(data[0]);
    } else {
      //ERRORE
      return null;
    }
  }

  void gotoCustomerAdd() {
    Get.toNamed('/admin/customers/create');
  }

  void filterByName(String value) {
    if (value == "") {
      data = MyData(customers, this);
    } else {
      var filterCustomers = customers
          .where((element) =>
              element.descrizione!.toLowerCase().contains(value.toLowerCase()))
          .toList();
      data = MyData(filterCustomers, this);
    }
    update();
  }

  void orderByName() {
    localita = null;
    provincia = null;
    ultCons = null;
    ragSoc ??= true;
    if (ragSoc!) {
      customers.sort((a, b) =>
          a.descrizione!.toLowerCase().compareTo(b.descrizione!.toLowerCase()));
      data = MyData(customers, this);
    } else {
      customers.sort((a, b) =>
          b.descrizione!.toLowerCase().compareTo(a.descrizione!.toLowerCase()));
      data = MyData(customers, this);
    }
    ragSoc = !ragSoc!;
    update();
  }

  void orderByLocalita() {
    ragSoc = null;
    provincia = null;
    ultCons = null;
    localita ??= true;
    if (localita!) {
      customers.sort((a, b) =>
          a.localita!.toLowerCase().compareTo(b.localita!.toLowerCase()));
      data = MyData(customers, this);
    } else {
      customers.sort((a, b) =>
          b.localita!.toLowerCase().compareTo(a.localita!.toLowerCase()));
      data = MyData(customers, this);
    }
    localita = !localita!;
    update();
  }

  void orderByProvincia() {
    ragSoc = null;
    localita = null;
    ultCons = null;
    provincia ??= true;

    if (provincia!) {
      customers.sort((a, b) =>
          a.provincia!.toLowerCase().compareTo(b.provincia!.toLowerCase()));
      data = MyData(customers, this);
    } else {
      customers.sort((a, b) =>
          b.provincia!.toLowerCase().compareTo(a.provincia!.toLowerCase()));
      data = MyData(customers, this);
    }
    provincia = !provincia!;
    update();
  }

  /*void orderByIndirizzo() {
    customers.sort((a, b) =>
        a.indirizzo!.toLowerCase().compareTo(b.indirizzo!.toLowerCase()));
    data = MyData(customers, this);
    update();
  }

  void orderByEmail() {
    customers.sort(
        (a, b) => a.email!.toLowerCase().compareTo(b.email!.toLowerCase()));
    data = MyData(customers, this);
    update();
  }*/

  void orderByUltimaConsegna() {
    ragSoc = null;
    localita = null;
    provincia = null;
    ultCons ??= true;

    if (ultCons!) {
      customers.sort((a, b) =>
          Utils.stringToDate(a.dataUltimaConsegna!.toLowerCase()).compareTo(
              Utils.stringToDate(b.dataUltimaConsegna!.toLowerCase())));
      data = MyData(customers, this);
    } else {
      customers.sort((a, b) =>
          Utils.stringToDate(b.dataUltimaConsegna!.toLowerCase()).compareTo(
              Utils.stringToDate(a.dataUltimaConsegna!.toLowerCase())));
      data = MyData(customers, this);
    }
    ultCons = !ultCons!;
    update();
  }
}
