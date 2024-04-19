import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foody/helpers/utils/do_http_request.dart';
import 'package:foody/helpers/utils/global.dart';
import 'package:foody/helpers/utils/show_message_dialogs.dart';
import 'package:foody/helpers/utils/utils.dart';
import 'package:foody/model/customer_detail.dart';
import 'package:foody/model/customer_list.dart';
import 'package:foody/model/request.dart' as r;
import 'package:foody/views/my_controller.dart';
import 'package:foody/views/ui/customer/customer_list_screen.dart';
import 'package:get/get.dart';

class CustomerListController extends MyController {
  List<CustomersList> customers = [], filterCustomers = [];
  DataTableSource? data;
  BuildContext context;
  bool loading = true;

  bool? ragSoc = false, localita, provincia, ultCons;

  final ScrollController controllerScroll = ScrollController();
  final FocusNode focusNode = FocusNode();

  CustomerListController({required this.context});

  @override
  void onInit() {
    //init();
    super.onInit();
  }

  void init() {
    CustomersList.dummyList.then((value) {
      customers = value; //.sublist(10, value.length);
      filterCustomers = customers;
      filterCustomers.sort((a, b) =>
          a.descrizione!.toLowerCase().compareTo(b.descrizione!.toLowerCase()));
      data = MyData(filterCustomers, this);
      loading = false;
      update();
    });
  }

  @override
  void onThemeChanged() {
    data = MyData(filterCustomers, this);
    update();
  }

  void handleKeyEvent(RawKeyEvent event) {
    var offset = controllerScroll.offset;
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (kReleaseMode) {
        controllerScroll.animateTo(offset - 30,
            duration: Duration(milliseconds: 1), curve: Curves.ease);
      } else {
        controllerScroll.animateTo(offset - 30,
            duration: Duration(milliseconds: 1), curve: Curves.ease);
      }
      update();
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (kReleaseMode) {
        controllerScroll.animateTo(offset + 30,
            duration: Duration(milliseconds: 1), curve: Curves.ease);
      } else {
        controllerScroll.animateTo(offset + 30,
            duration: Duration(milliseconds: 1), curve: Curves.ease);
      }
      update();
    }
  }

  goToOrder(String codCliente) async {
    if (clienteSelezionato != null && carrelloGlobale.length > 0) {
      if (clienteSelezionato?.codiceCliente == codCliente) {
        CustomerDetail destinazione = await getCliente(codCliente);
        clienteSelezionato = destinazione;
        Get.toNamed('/cart', arguments: destinazione);
      } else {
        showErrorMessage(context, "Attenzione",
            "Hai gia un ordine in corso su un'altro cliente.");
      }
    } else {
      CustomerDetail destinazione = await getCliente(codCliente);
      clienteSelezionato = destinazione;
      Get.toNamed('/cart', arguments: destinazione);
    }
  }

  goToDetail(String codCliente) async {
    if (clienteSelezionato != null && carrelloGlobale.length > 0) {
      if (clienteSelezionato?.codiceCliente == codCliente) {
        clienteSelezionato = await getCliente(codCliente);
        Get.toNamed('/admin/customers/detail', arguments: clienteSelezionato);
      } else {
        showErrorMessage(context, "Attenzione",
            "Hai gia un ordine in corso su un'altro cliente.");
      }
    } else {
      clienteSelezionato = await getCliente(codCliente);
      Get.toNamed('/admin/customers/detail', arguments: clienteSelezionato);
    }
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
      filterCustomers = customers
          .where((element) =>
              element.descrizione!
                  .toLowerCase()
                  .contains(value.toLowerCase()) ||
              element.localita!.toLowerCase().contains(value.toLowerCase()) ||
              element.provincia!.toLowerCase().contains(value.toLowerCase()))
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
      filterCustomers.sort((a, b) =>
          a.descrizione!.toLowerCase().compareTo(b.descrizione!.toLowerCase()));
      data = MyData(filterCustomers, this);
    } else {
      filterCustomers.sort((a, b) =>
          b.descrizione!.toLowerCase().compareTo(a.descrizione!.toLowerCase()));
      data = MyData(filterCustomers, this);
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
      filterCustomers.sort((a, b) =>
          a.localita!.toLowerCase().compareTo(b.localita!.toLowerCase()));
      data = MyData(filterCustomers, this);
    } else {
      filterCustomers.sort((a, b) =>
          b.localita!.toLowerCase().compareTo(a.localita!.toLowerCase()));
      data = MyData(filterCustomers, this);
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
      filterCustomers.sort((a, b) =>
          a.provincia!.toLowerCase().compareTo(b.provincia!.toLowerCase()));
      data = MyData(filterCustomers, this);
    } else {
      filterCustomers.sort((a, b) =>
          b.provincia!.toLowerCase().compareTo(a.provincia!.toLowerCase()));
      data = MyData(filterCustomers, this);
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
      filterCustomers.sort((a, b) =>
          Utils.stringToDate(a.dataUltimaConsegna!.toLowerCase()).compareTo(
              Utils.stringToDate(b.dataUltimaConsegna!.toLowerCase())));
      data = MyData(filterCustomers, this);
    } else {
      filterCustomers.sort((a, b) =>
          Utils.stringToDate(b.dataUltimaConsegna!.toLowerCase()).compareTo(
              Utils.stringToDate(a.dataUltimaConsegna!.toLowerCase())));
      data = MyData(filterCustomers, this);
    }
    ultCons = !ultCons!;
    update();
  }
}
