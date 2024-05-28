import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mexalorder/helpers/storage/local_storage.dart';
import 'package:mexalorder/helpers/utils/do_http_request.dart';
import 'package:mexalorder/helpers/utils/utils.dart';
import 'package:mexalorder/model/agente.dart';
import 'package:mexalorder/model/statistiche.dart';
import 'package:mexalorder/views/my_controller.dart';
import 'package:mexalorder/views/ui/Statistiche/statistiche_screen.dart';
import 'package:mexalorder/model/request.dart' as r;

class StatisticheController extends MyController {
  List<Statistiche> statistiche = [];
  List<Agente> agenti = [];
  bool isChecked = false;
  Agente? agenteSelezionato;
  DataTableSource? data;
  bool? categoria, articolo = false, cliente, qta, valore;
  bool isLoading = true;

  TextEditingController dateControllerDa = TextEditingController();
  TextEditingController dateControllerA = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    data = MyDataDetailStatistiche([], this);
    getData();
    var date = DateTime.now();
    dateControllerDa.text = Utils.getDateTimeStringFromDateTime(
        DateTime(date.year, date.month - 1),
        showTime: false);
    dateControllerA.text =
        Utils.getDateTimeStringFromDateTime(DateTime.now(), showTime: false);
  }

  @override
  void onThemeChanged() {
    data = MyDataDetailStatistiche(statistiche, this);
    update();
  }

  getData() async {
    await getListaAgenti();
    getStatisticheCliente();
  }

  getListaAgenti() async {
    r.Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrcli",
        etichettaCollage: "AGENTI",
        dati: {"agente": LocalStorage.getLoggedUser()?.codiceAgente});

    if (res.code == 200) {
      var a = res.result as dynamic;
      List<dynamic> dati = json.decode(jsonEncode(a));
      if (dati != []) {
        agenti = dati.map((e) => Agente.fromJson(e)).toList();
        var codAgenteLoggato = LocalStorage.getLoggedUser()?.codiceAgente ?? "";
        for (Agente element in agenti) {
          if (codAgenteLoggato == element.pccod) {
            agenteSelezionato = element;
          }
        }
        agenteSelezionato ??= agenti[0];
      }
      update();
    } else {
      return null;
    }
  }

  getStatisticheCliente() async {
    isLoading = true;
    update();
    r.Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrcli",
        etichettaCollage: "STAT_VEND",
        dati: {
          "inizio": Utils.stringToDateR(dateControllerDa.text),
          "fine": Utils.stringToDateR(dateControllerA.text),
          "agente": /*LocalStorage.getLoggedUser()?.codiceAgente,*/
              agenteSelezionato?.pccod ?? "",
          "clienti": isChecked
        });
    isLoading = false;
    update();
    if (res.code == 200) {
      var a = res.result as dynamic;
      List<dynamic> dati = json.decode(jsonEncode(a));
      if (dati != []) {
        statistiche = dati.map((e) => Statistiche.fromJson(e)).toList();
        statistiche.sort((a, b) => a.articolo!.compareTo(b.articolo!));
        data = MyDataDetailStatistiche(statistiche, this);
      }
      update();
    } else {
      //ERRORE
      return null;
    }
  }

  void onChangeCheckBox(bool? value) async {
    isChecked = value ?? isChecked;
    await getStatisticheCliente();
    if (isChecked) {
      orderByCliente();
    } else {
      orderByArticolo();
    }
  }

  void filterByName(String value) {
    if (value == "") {
      data = MyDataDetailStatistiche(statistiche, this);
    } else {
      var filter = statistiche
          .where((element) =>
              element.categoria!.toLowerCase().contains(value.toLowerCase()) ||
              element.articolo!.toLowerCase().contains(value.toLowerCase()) ||
              element.cliente!.toLowerCase().contains(value.toLowerCase()))
          .toList();
      data = MyDataDetailStatistiche(filter, this);
    }
    update();
  }

  void orderByCategoria() {
    articolo = null;
    cliente = null;
    qta = null;
    valore = null;
    categoria ??= true;
    if (categoria!) {
      statistiche.sort((a, b) => a.categoria!.compareTo(b.categoria!));
      data = MyDataDetailStatistiche(statistiche, this);
    } else {
      statistiche.sort((a, b) => b.categoria!.compareTo(a.categoria!));
      data = MyDataDetailStatistiche(statistiche, this);
    }
    categoria = !categoria!;
    update();
  }

  void orderByArticolo() {
    categoria = null;
    cliente = null;
    qta = null;
    valore = null;
    articolo ??= true;
    if (articolo!) {
      statistiche.sort((a, b) => a.articolo!.compareTo(b.articolo!));
      data = MyDataDetailStatistiche(statistiche, this);
    } else {
      statistiche.sort((a, b) => b.articolo!.compareTo(a.articolo!));
      data = MyDataDetailStatistiche(statistiche, this);
    }
    articolo = !articolo!;
    update();
  }

  void orderByCliente() {
    categoria = null;
    articolo = null;
    qta = null;
    valore = null;
    cliente ??= true;
    if (cliente!) {
      statistiche.sort((a, b) => a.cliente!.compareTo(b.cliente!));
      data = MyDataDetailStatistiche(statistiche, this);
    } else {
      statistiche.sort((a, b) => b.cliente!.compareTo(a.cliente!));
      data = MyDataDetailStatistiche(statistiche, this);
    }
    cliente = !cliente!;
    update();
  }

  void orderByQta() {
    categoria = null;
    articolo = null;
    cliente = null;
    valore = null;
    qta ??= false;
    if (qta!) {
      statistiche.sort((a, b) => a.quantita!.compareTo(b.quantita!));
      data = MyDataDetailStatistiche(statistiche, this);
    } else {
      statistiche.sort((a, b) => b.quantita!.compareTo(a.quantita!));
      data = MyDataDetailStatistiche(statistiche, this);
    }
    qta = !qta!;
    update();
  }

  void orderByValore() {
    categoria = null;
    articolo = null;
    cliente = null;
    qta = null;
    valore ??= false;
    if (valore!) {
      statistiche.sort((a, b) => a.valore!.compareTo(b.valore!));
      data = MyDataDetailStatistiche(statistiche, this);
    } else {
      statistiche.sort((a, b) => b.valore!.compareTo(a.valore!));
      data = MyDataDetailStatistiche(statistiche, this);
    }
    valore = !valore!;
    update();
  }
}
