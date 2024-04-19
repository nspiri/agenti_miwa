import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:foody/helpers/storage/local_storage.dart';
import 'package:foody/helpers/utils/do_http_request.dart';
import 'package:foody/helpers/utils/global.dart';
import 'package:foody/helpers/utils/utils.dart';
import 'package:foody/model/scadenziario_cliente.dart';
import 'package:foody/views/my_controller.dart';
import 'package:foody/views/ui/customer/scadenziario_customer_screen.dart';
import 'package:foody/model/request.dart' as r;
import 'package:syncfusion_flutter_pdf/pdf.dart';

class ScadenziarioController extends MyController {
  List<ScadenziarioCliente> scadenziario = [], filterScadenziario = [];
  DataTableSource? data;
  bool? dataAsc, dataScad = false, importo, ragSoc, doc;
  String? codiceCliente;
  bool all = false, tutti = true, scaduti = false;
  bool isLoading = true;

  @override
  void onInit() {
    super.onInit();
    getScadenziarioCliente();
  }

  @override
  void onThemeChanged() {
    data = MyDataDetailScadenziarioCliente(filterScadenziario, this);
    update();
  }

  getScadenziarioCliente() async {
    scaduti = false;
    tutti = true;
    isLoading = true;
    update();
    codiceCliente = clienteSelezionato?.codCliFattA != ""
        ? clienteSelezionato?.codCliFattA
        : clienteSelezionato?.codiceCliente;
    r.Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrcli",
        etichettaCollage: "GET_SCAD",
        dati: {
          "agente": LocalStorage.getLoggedUser()?.codiceAgente,
          "cliente": codiceCliente
        });
    isLoading = false;
    update();
    if (res.code == 200) {
      var a = res.result as dynamic;
      List<dynamic> dati = json.decode(jsonEncode(a));
      if (dati != []) {
        scadenziario =
            dati.map((e) => ScadenziarioCliente.fromJson(e)).toList();
        scadenziario.sort((a, b) =>
            int.parse(a.dataScadenza!).compareTo(int.parse(b.dataScadenza!)));
        filterScadenziario = scadenziario;
        data = MyDataDetailScadenziarioCliente(filterScadenziario, this);
      }
      update();
    } else {
      //ERRORE
      return null;
    }
  }

  scadute() {
    scaduti = true;
    tutti = false;
    filterScadenziario = scadenziario
        .where((element) =>
            int.parse(element.dataScadenza ?? "0") <
            int.parse(Utils.stringToDateR(Utils.dateToString(DateTime.now()))))
        .toList();
    data = MyDataDetailScadenziarioCliente(filterScadenziario, this);
    update();
  }

  changeValue() {
    data = MyDataDetailScadenziarioCliente(filterScadenziario, this);
    update();
  }

  String get totale {
    double totale = 0;
    for (var element in filterScadenziario) {
      if (element.selected) {
        totale = totale + (element.importo ?? 0).toDouble();
      }
    }
    return Utils.formatStringDecimal(totale, 2);
  }

  generaPdf() async {
    List<dynamic> clienti = [];
    for (var element in filterScadenziario) {
      if (element.selected) {
        clienti.add({
          "documento":
              "${element.documento} ${element.serie}/${element.numero}",
          "data": element.data,
          "tipo": element.tipoPagamento,
          "scadenza": element.dataScadenza,
          "importo": element.importo
        });
      }
    }
    r.Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrcli",
        etichettaCollage: "SCAD_STAMPA",
        dati: {
          "cliente": codiceCliente,
          "agente": LocalStorage.getLoggedUser()?.codiceAgente,
          "scadenze": clienti
        });
    String pdf = "";
    if (res.code == 200) {
      var result = res.result as List<dynamic>;
      if (result[0]["pdf"] != null) {
        if (result.isNotEmpty) {
          for (var element in result[0]["pdf"]) {
            pdf += element;
          }
          Uint8List pdfExp = base64
              .decode(pdf.replaceAll(RegExp(r'\s+'), '').replaceAll("[", ""));
          PdfDocument document = PdfDocument(inputBytes: pdfExp);
          final List<int> bytes = document.saveSync();
          document.dispose();
          await Utils.saveAndLaunchFile(bytes, 'scadenziario.pdf');
        }
      }
    } else {
      //showErrorMessage(context, "Nessuna immagine", "");
    }
  }

  void filterByName(String value) {
    if (value == "") {
      data = MyDataDetailScadenziarioCliente(filterScadenziario, this);
    } else {
      var filterCustomers = filterScadenziario
          .where((element) =>
              element.ragioneSociale!
                  .toLowerCase()
                  .contains(value.toLowerCase()) ||
              element.documento!.toLowerCase().contains(value.toLowerCase()))
          .toList();
      data = MyDataDetailScadenziarioCliente(filterCustomers, this);
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
      filterScadenziario
          .sort((a, b) => int.parse(a.data!).compareTo(int.parse(b.data!)));
      data = MyDataDetailScadenziarioCliente(filterScadenziario, this);
    } else {
      filterScadenziario
          .sort((a, b) => int.parse(b.data!).compareTo(int.parse(a.data!)));
      data = MyDataDetailScadenziarioCliente(filterScadenziario, this);
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
      filterScadenziario.sort((a, b) =>
          int.parse(a.dataScadenza!).compareTo(int.parse(b.dataScadenza!)));
      data = MyDataDetailScadenziarioCliente(filterScadenziario, this);
    } else {
      filterScadenziario.sort((a, b) =>
          int.parse(b.dataScadenza!).compareTo(int.parse(a.dataScadenza!)));
      data = MyDataDetailScadenziarioCliente(filterScadenziario, this);
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
      filterScadenziario.sort((a, b) => a.importo!.compareTo(b.importo!));
      data = MyDataDetailScadenziarioCliente(filterScadenziario, this);
    } else {
      filterScadenziario.sort((a, b) => b.importo!.compareTo(a.importo!));
      data = MyDataDetailScadenziarioCliente(filterScadenziario, this);
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
      filterScadenziario
          .sort((a, b) => b.ragioneSociale!.compareTo(a.ragioneSociale!));
      data = MyDataDetailScadenziarioCliente(filterScadenziario, this);
    } else {
      filterScadenziario
          .sort((a, b) => a.ragioneSociale!.compareTo(b.ragioneSociale!));
      data = MyDataDetailScadenziarioCliente(filterScadenziario, this);
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
      filterScadenziario.sort((a, b) => ("${b.documento}${b.serie}${b.numero}")
          .compareTo(("${a.documento}${a.serie}${a.numero}")));
      data = MyDataDetailScadenziarioCliente(filterScadenziario, this);
    } else {
      filterScadenziario.sort((a, b) => ("${a.documento}${a.serie}${a.numero}")
          .compareTo(("${b.documento}${b.serie}${b.numero}")));
      data = MyDataDetailScadenziarioCliente(filterScadenziario, this);
    }
    doc = !doc!;
    update();
  }
}
