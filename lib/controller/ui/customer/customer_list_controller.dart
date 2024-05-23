import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foody/helpers/storage/local_storage.dart';
import 'package:foody/helpers/utils/do_http_request.dart';
import 'package:foody/helpers/utils/global.dart';
import 'package:foody/helpers/utils/show_message_dialogs.dart';
import 'package:foody/helpers/utils/utils.dart';
import 'package:foody/model/articolo.dart';
import 'package:foody/model/customer_detail.dart';
import 'package:foody/model/customer_list.dart';
import 'package:foody/model/listino.dart';
import 'package:foody/model/nota.dart';
import 'package:foody/model/ordine.dart';
import 'package:foody/model/request.dart' as r;
import 'package:foody/model/scadenziario_cliente.dart';
import 'package:foody/model/storico.dart';
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
    clienteSelezionato = LocalStorage.getDettCli();
    if (clienteSelezionato != null &&
        (LocalStorage.getCarrelloGlobale() ?? []).length > 0) {
      if (clienteSelezionato?.codiceCliente == codCliente) {
        CustomerDetail destinazione = await getCliente(codCliente);
        clienteSelezionato = destinazione;
        LocalStorage.setDettCli(destinazione);
        if (clienteSelezionato?.attivo == true) {
          Get.toNamed('/cart',
              arguments: PassaggioDatiOrdine(cliente: destinazione));
        }
      } else {
        showErrorMessage(context, "Attenzione",
            "Hai gia un ordine in corso su un'altro cliente.");
      }
    } else {
      CustomerDetail destinazione = await getCliente(codCliente);
      clienteSelezionato = destinazione;
      LocalStorage.setDettCli(destinazione);
      if (clienteSelezionato?.attivo == true) {
        Get.toNamed('/cart',
            arguments: PassaggioDatiOrdine(cliente: destinazione));
      }
    }
  }

  goToDetail(String codCliente) async {
    clienteSelezionato = LocalStorage.getDettCli();
    if (clienteSelezionato != null &&
        (LocalStorage.getCarrelloGlobale() ?? []).length > 0) {
      if (clienteSelezionato?.codiceCliente == codCliente) {
        clienteSelezionato = await getCliente(codCliente);
        LocalStorage.setDettCli(clienteSelezionato);
        Get.toNamed('/admin/customers/detail', arguments: clienteSelezionato);
      } else {
        showErrorMessage(context, "Attenzione",
            "Hai gia un ordine in corso su un'altro cliente.");
      }
    } else {
      clienteSelezionato = await getCliente(codCliente);
      LocalStorage.setDettCli(clienteSelezionato);
      Get.toNamed('/admin/customers/detail', arguments: clienteSelezionato);
    }
  }

  scaricaDatiCliente(CustomersList cli) async {
    cli.loadingDownloadOffline = true;
    data = MyData(filterCustomers, this);
    update();
    CustomerDetail dettCliente = await getCliente(cli.codice ?? "");
    LocalStorage.setDettCli(dettCliente);
    clienteSelezionato = dettCliente;

    if (clienteSelezionato?.codCliFattA != "") {
      CustomerDetail dettCliente =
          await getCliente(clienteSelezionato?.codCliFattA ?? "");
      LocalStorage.setFattA(dettCliente);
    }

    String note = await getNoteCliente(cli.codice ?? "");
    LocalStorage.setNote(note);

    List<Ordine> ordini = await getOrdini(dettCliente);
    LocalStorage.setOrdini(ordini);

    List<ScadenziarioCliente> scadenziario =
        await getScadenziarioCliente(dettCliente);
    LocalStorage.setScadenzario(scadenziario);

    List<Storico> storico = await getStoricoCliente(cli.codice ?? "");
    LocalStorage.setStorico(storico);

    List<Listino> listini = await Utils.getNomeListini();
    LocalStorage.setListini(listini);

    List<Articolo> topArticoli = await top10(cli.codice ?? "");
    LocalStorage.setTopArticoli(topArticoli);

    Articolo.dummyList.then((value) {
      LocalStorage.setArticoli(value);
      //showSuccessMessage(context, "Articoli scaricati!", "");
      azzeraPinClienti();
      cli.loadingDownloadOffline = null;
      data = MyData(filterCustomers, this);
      LocalStorage.setOffline(true);
      update();
      Get.toNamed('/admin/customers/detail', arguments: clienteSelezionato);
    });
  }

  azzeraPinClienti() {
    for (var element in filterCustomers) {
      element.loadingDownloadOffline ??= false;
    }
  }

  top10(String codCli) async {
    List<Articolo> articoli = [];
    r.Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrart",
        etichettaCollage: "TOP_VENDITE",
        dati: {
          "magazzino": 1,
          "cliente": codCli,
          "top": 70,
          "agente": LocalStorage.getLoggedUser()?.codiceAgente,
        });

    if (res.code == 200) {
      var a = res.result as List<dynamic>;
      if (a.isEmpty) {
        articoli = [];
      }
      dynamic dati = json.decode(jsonEncode(a));
      articoli = Articolo.listFromJSON(dati);
      return articoli;
    } else {
      showErrorMessage(context, "Errore", "Si è verificato un errore");
      return [];
    }
  }

  getNoteCliente(String codCliente) async {
    r.Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrcli",
        etichettaCollage: "GET_CLI_NOTE",
        dati: {
          "agente": LocalStorage.getLoggedUser()?.codiceAgente,
          "cliente": codCliente
        });

    if (res.code == 200) {
      var a = res.result as dynamic;
      String note = "";
      List<dynamic> dati = json.decode(jsonEncode(a));
      if (dati != []) {
        List<Nota> nota = dati.map((e) => Nota.fromJson(e)).toList();
        for (var element in nota) {
          note += "${element.nota}";
        }
      }
      return note;
    } else {
      showErrorMessage(context, "Errore", "Si è verificato un errore");
      return "";
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
      showErrorMessage(context, "Errore", "Si è verificato un errore");
      return null;
    }
  }

  getOrdini(CustomerDetail cliente) async {
    List<Ordine> ordini = [];
    r.Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrdoc",
        etichettaCollage: "OC_ELENCO",
        dati: {
          "agente": LocalStorage.getLoggedUser()?.codiceAgente,
          "cliente": cliente.codCliFattA != ""
              ? cliente.codCliFattA
              : cliente.codiceCliente
        });
    if (res.code == 200) {
      var a = res.result as dynamic;
      List<dynamic> dati = json.decode(jsonEncode(a));
      if (dati != []) {
        ordini = dati.map((e) => Ordine.fromJson(e)).toList();
        ordini
            .sort((a, b) => int.parse(b.ocdat!).compareTo(int.parse(a.ocdat!)));
        return ordini;
      }
      update();
    } else {
      showErrorMessage(context, "Errore", "Si è verificato un errore");
      return [];
    }
  }

  getScadenziarioCliente(CustomerDetail cliente) async {
    List<ScadenziarioCliente> scadenziario = [];
    String codiceCliente = cliente.codCliFattA != ""
        ? cliente.codCliFattA ?? ""
        : cliente.codiceCliente ?? "";
    r.Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrcli",
        etichettaCollage: "GET_SCAD",
        dati: {
          "agente": LocalStorage.getLoggedUser()?.codiceAgente,
          "cliente": codiceCliente
        });
    if (res.code == 200) {
      var a = res.result as dynamic;
      List<dynamic> dati = json.decode(jsonEncode(a));
      if (dati != []) {
        scadenziario =
            dati.map((e) => ScadenziarioCliente.fromJson(e)).toList();
        return scadenziario;
      }
      update();
    } else {
      showErrorMessage(context, "Errore", "Si è verificato un errore");
      return [];
    }
  }

  getStoricoCliente(String codCliente) async {
    List<Storico> storico = [];
    r.Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrcli",
        etichettaCollage: "STORICO",
        dati: {
          "agente": LocalStorage.getLoggedUser()?.codiceAgente,
          "cliente": codCliente,
          "articolo": ""
        });
    if (res.code == 200) {
      var a = res.result as dynamic;
      List<dynamic> dati = json.decode(jsonEncode(a));
      if (dati != []) {
        storico = dati.map((e) => Storico.fromJson(e)).toList();
        return storico;
      }
      update();
    } else {
      showErrorMessage(context, "Errore", "Si è verificato un errore");
      return [];
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
