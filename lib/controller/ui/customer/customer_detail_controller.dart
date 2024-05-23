import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foody/helpers/storage/local_storage.dart';
import 'package:foody/helpers/utils/do_http_request.dart';
import 'package:foody/helpers/utils/global.dart';
import 'package:foody/helpers/utils/show_message_dialogs.dart';
import 'package:foody/model/customer_detail.dart';
import 'package:foody/model/nazionalita.dart';
import 'package:foody/model/nota.dart';
import 'package:foody/model/order_detail.dart';
import 'package:foody/model/request.dart' as r;
import 'package:foody/model/scadenziario_cliente.dart';
import 'package:foody/views/my_controller.dart';
import 'package:foody/views/ui/customer/customer_detail_screen.dart';
import 'package:get/get.dart';

class CustomerDetailController extends MyController {
  List<OrderDetail> ordersDetail = [];
  CustomerDetail? dettaglio;
  List<ScadenziarioCliente> scadenzoario = [];
  DataTableSource? data;
  TextEditingController note = TextEditingController();
  bool? ok;
  BuildContext context;
  List<Nazionalita> nazionalita = [];
  List<Paesi> paesi = [];
  bool isOffline = false;

  CustomerDetailController({required this.context});

  @override
  void onInit() {
    super.onInit();
    isOffline = LocalStorage.getOffline();
    Nazionalita.dummyList.then((value) {
      nazionalita = value;
      nazionalita.sort((a, b) =>
          a.descrizione!.toLowerCase().compareTo(b.descrizione!.toLowerCase()));
      update();
    });
    Paesi.dummyList.then((value) {
      paesi = value;
      paesi.sort((a, b) =>
          a.descrizione!.toLowerCase().compareTo(b.descrizione!.toLowerCase()));
      update();
    });
  }

  String? getNazionalita(String? cod) {
    for (var element in nazionalita) {
      if (cod == element.codice) {
        return element.descrizione;
      }
    }
    return null;
  }

  String? getPaese(String? cod) {
    for (var element in paesi) {
      if (cod == element.sigla) {
        return element.descrizione;
      }
    }
    return null;
  }

  @override
  void onThemeChanged() {
    data = MyDataDetailScadenziario(scadenzoario);
    update();
  }

  getData(CustomerDetail? cliente) async {
    bool isOffline = LocalStorage.getOffline();
    dettaglio = cliente;
    if (dettaglio != null) {
      if (isOffline) {
        note.text = LocalStorage.getNote();
      } else {
        getNoteCliente(dettaglio!.codiceCliente!);
      }
    }
  }

  getDettaglioCliente(String codCliente) async {
    r.Response res = await DoRequest.doHttpRequest(
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

  goToOrder(String codCliente) async {
    if (clienteSelezionato != null &&
        (LocalStorage.getCarrelloGlobale() ?? []).length > 0) {
      if (clienteSelezionato?.codiceCliente == codCliente) {
        CustomerDetail destinazione = await getCliente(codCliente);
        clienteSelezionato = destinazione;
        Get.toNamed('/cart',
            arguments: PassaggioDatiOrdine(cliente: destinazione));
      } else {
        showErrorMessage(context, "Attenzione",
            "Hai gia un ordine in corso su un'altro cliente.");
      }
    } else {
      CustomerDetail destinazione = await getCliente(codCliente);
      clienteSelezionato = destinazione;
      Get.toNamed('/cart',
          arguments: PassaggioDatiOrdine(cliente: destinazione));
    }
  }

  goToList() {
    Get.toNamed('/list');
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

  getScadenziarioCliente(String codCliente) async {
    r.Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrcli",
        etichettaCollage: "GET_SCAD",
        dati: {
          "agente": LocalStorage.getLoggedUser()?.codiceAgente,
          "cliente": codCliente
        });

    if (res.code == 200) {
      var a = res.result as dynamic;
      List<dynamic> dati = json.decode(jsonEncode(a));
      if (dati != []) {
        scadenzoario =
            dati.map((e) => ScadenziarioCliente.fromJson(e)).toList();
        data = MyDataDetailScadenziario(scadenzoario);
      }
      update();
    } else {
      //ERRORE
      return null;
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
      List<dynamic> dati = json.decode(jsonEncode(a));
      if (dati != []) {
        List<Nota> nota = dati.map((e) => Nota.fromJson(e)).toList();
        note.text = "";
        for (var element in nota) {
          note.text += "${element.nota}";
        }
      }
      update();
    } else {
      //ERRORE
      return null;
    }
  }

  salvaNote(String codCliente) async {
    List<Nota> listaNote = [];
    if (note.text.length <= 199) {
      listaNote.add(Nota(rigo: 1, nota: note.text));
    } else {
      int i = 1;
      for (var c = 0; c < note.text.length; c += 199) {
        if (c + 199 > note.text.length) {
          listaNote.add(
              Nota(rigo: i, nota: note.text.substring(c, note.text.length)));
        } else {
          listaNote.add(Nota(rigo: i, nota: note.text.substring(c, c + 199)));
        }
        i++;
      }
    }
    r.Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrcli",
        etichettaCollage: "SET_CLI_NOTE",
        dati: {
          "agente": LocalStorage.getLoggedUser()?.codiceAgente,
          "cliente": codCliente,
          "note": listaNote
        });

    if (res.code == 200) {
      var a = res.result as dynamic;
      List<dynamic> dati = json.decode(jsonEncode(a));
      if (dati != []) {
        List<Nota> nota = dati.map((e) => Nota.fromJson(e)).toList();
        note.text = "";
        for (var element in nota) {
          note.text += "${element.nota}";
        }
        ok = true;
        update();
        Future.delayed(const Duration(seconds: 2)).then((val) {
          ok = null;
          update();
        });
      }
      update();
    } else {
      ok = false;
      update();
      Future.delayed(const Duration(seconds: 2)).then((val) {
        ok = null;
        update();
      });
    }
  }
}
