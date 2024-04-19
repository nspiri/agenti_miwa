import 'package:flutter/material.dart';
import 'package:foody/helpers/storage/local_storage.dart';
import 'package:foody/helpers/utils/do_http_request.dart';
import 'package:foody/helpers/utils/show_message_dialogs.dart';
import 'package:foody/helpers/utils/utils.dart';
import 'package:foody/model/customer_list.dart';
import 'package:foody/model/request.dart' as r;
import 'package:foody/views/my_controller.dart';
import 'package:foody/views/ui/customer/state_customers_screen.dart';

class CustomerStateController extends MyController {
  List<StatoCliente> customers = [], filterCustomers = [];
  DataTableSource? data;
  BuildContext context;
  bool loading = false, loadingTable = true;

  bool? codice, ragSoc = false, ultCons;

  CustomerStateController({required this.context});

  @override
  void onInit() {
    getDati();
    super.onInit();
  }

  getDati() {
    StatoCliente.dummyList.then((value) {
      customers = setCheck(value); //.sublist(10, value.length);
      filterCustomers = customers;
      filterCustomers.sort(
          (a, b) => a.pcdes!.toLowerCase().compareTo(b.pcdes!.toLowerCase()));
      data = MyDataState(filterCustomers, this);
      loadingTable = false;
      update();
    });
  }

  List<StatoCliente> setCheck(List<StatoCliente> lista) {
    for (var element in lista) {
      switch (element.stato) {
        case "P":
          element.parcheggiare = true;
          element.editable = false;
          break;
        case "R":
          element.riprovare = true;
          element.editable = false;
          break;
        case "C":
          element.ferie = true;
          element.editable = false;
          break;
      }
    }
    return lista;
  }

  @override
  void onThemeChanged() {
    data = MyDataState(filterCustomers, this);
    update();
  }

  onChangeStateP(int index, bool value) {
    filterCustomers[index].parcheggiare = value;
    filterCustomers[index].riprovare = false;
    filterCustomers[index].ferie = false;
    data = MyDataState(filterCustomers, this);
    update();
  }

  onChangeStateR(int index, bool value) {
    filterCustomers[index].riprovare = value;
    filterCustomers[index].parcheggiare = false;
    filterCustomers[index].ferie = false;
    data = MyDataState(filterCustomers, this);
    update();
  }

  onChangeStateC(int index, bool value) {
    filterCustomers[index].ferie = value;
    filterCustomers[index].riprovare = false;
    filterCustomers[index].parcheggiare = false;
    data = MyDataState(filterCustomers, this);
    update();
  }

  salva() {
    controlloGest();
  }

  controlloGest() async {
    bool ok = true;
    for (var element in filterCustomers) {
      if (element.parcheggiare == false &&
          element.riprovare == false &&
          element.ferie == false) {
        ok = false;
        element.gestito = false;
      } else {
        if (element.data != "") {
          if (element.parcheggiare == false) {
            element.gestito = false;
            continue;
          }
        }
        element.gestito = true;
      }
    }
    if (ok) {
      loading = true;
      update();
      salvaClienti();
    } else {
      data = MyDataState(filterCustomers, this);
      update();
      showErrorMessage(
          context, "Attenzione", "Gestisci tutti i clienti prima di salvare.");
    }
  }

  salvaClienti() async {
    List<Map<String, dynamic>> dati = [];
    String data = Utils.stringToDateR(Utils.dateToString(DateTime.now()));
    filterCustomers.sort(
        (a, b) => a.pccod!.toLowerCase().compareTo(b.pccod!.toLowerCase()));
    for (var element in filterCustomers) {
      if (element.parcheggiare == true ||
          element.riprovare == true ||
          element.ferie == true) {
        //TODO rimuovere e reinserire il controllo
        dati.add({
          "cliente": element.pccod,
          "counter":
              (element.riprovare == true || element.ferie == true) ? 1 : 2,
          "data": data,
          "stato": element.riprovare == true
              ? "R"
              : element.ferie == true
                  ? "C"
                  : "P",
          "nota": element.controller.text
        });
      }
    }
    r.Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrcli",
        etichettaCollage: "SET_CLI_STATO",
        dati: {
          "agente": LocalStorage.getLoggedUser()?.codiceAgente,
          "clienti": dati
        });

    if (res.code == 200) {
      loading = false;
      if (res.error != "") {
        showErrorMessage(context, "Attenzione", res.error);
      } else {
        showSuccessMessage(context, "Dati salvati.", res.error);
      }
      loadingTable = true;
      update();
      getDati();
    }
  }

  void filterByName(String value) {
    if (value == "") {
      filterCustomers = customers;
      data = MyDataState(filterCustomers, this);
    } else {
      filterCustomers = customers
          .where((element) =>
              element.pcdes!.toLowerCase().contains(value.toLowerCase()))
          .toList();
      data = MyDataState(filterCustomers, this);
    }
    update();
  }

  void orderByCod() {
    ragSoc = null;
    ultCons = null;
    codice ??= true;
    if (codice!) {
      filterCustomers.sort(
          (a, b) => a.pccod!.toLowerCase().compareTo(b.pccod!.toLowerCase()));
      data = MyDataState(filterCustomers, this);
    } else {
      filterCustomers.sort(
          (a, b) => b.pccod!.toLowerCase().compareTo(a.pccod!.toLowerCase()));
      data = MyDataState(filterCustomers, this);
    }
    codice = !codice!;
    update();
  }

  void orderByRagSoc() {
    codice = null;
    ultCons = null;
    ragSoc ??= true;
    if (ragSoc!) {
      filterCustomers.sort(
          (a, b) => a.pcdes!.toLowerCase().compareTo(b.pcdes!.toLowerCase()));
      data = MyDataState(filterCustomers, this);
    } else {
      filterCustomers.sort(
          (a, b) => b.pcdes!.toLowerCase().compareTo(a.pcdes!.toLowerCase()));
      data = MyDataState(filterCustomers, this);
    }
    ragSoc = !ragSoc!;
    update();
  }

  void orderByUltimaConsegna() {
    ragSoc = null;
    codice = null;
    ultCons ??= true;

    if (ultCons!) {
      filterCustomers.sort((a, b) => Utils.stringToDate(a.data!.toLowerCase())
          .compareTo(Utils.stringToDate(b.data!.toLowerCase())));
      data = MyDataState(filterCustomers, this);
    } else {
      filterCustomers.sort((a, b) => Utils.stringToDate(b.data!.toLowerCase())
          .compareTo(Utils.stringToDate(a.data!.toLowerCase())));
      data = MyDataState(filterCustomers, this);
    }
    ultCons = !ultCons!;
    update();
  }
}
