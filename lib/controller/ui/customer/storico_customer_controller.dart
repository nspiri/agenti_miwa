import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foody/helpers/storage/local_storage.dart';
import 'package:foody/helpers/utils/do_http_request.dart';
import 'package:foody/helpers/utils/utils.dart';
import 'package:foody/helpers/widgets/my_form_validator.dart';
import 'package:foody/model/request.dart';
import 'package:foody/model/storico.dart';
import 'package:foody/views/my_controller.dart';
import 'package:foody/views/ui/customer/storico_customer_screen.dart';

class EditCustomerController extends MyController {
  List<Storico> storico = [];
  DataTableSource? data;
  String codCliente;

  bool dataAsc = false;

  EditCustomerController({required this.codCliente});

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onThemeChanged() {
    data = MyDataDetailStorico(storico);
    update();
  }

  getData(String codCliente) async {
    getScadenziarioCliente(codCliente);
  }

  getScadenziarioCliente(String codCliente) async {
    Response res = await DoRequest.doHttpRequest(
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
        storico
            .sort((a, b) => int.parse(b.data!).compareTo(int.parse(a.data!)));
        data = MyDataDetailStorico(storico);
      }
      update();
    } else {
      //ERRORE
      return null;
    }
  }

  void filterByName(String value) {
    if (value == "") {
      data = MyDataDetailStorico(storico);
    } else {
      var filterCustomers = storico
          .where((element) =>
              Utils.getFormattedDate(element.data!)
                  .toLowerCase()
                  .contains(value.toLowerCase()) ||
              element.documento!.toLowerCase().contains(value.toLowerCase()) ||
              element.codArt!.toLowerCase().contains(value.toLowerCase()) ||
              element.desc!.toLowerCase().contains(value.toLowerCase()) ||
              element.um!.toLowerCase().contains(value.toLowerCase()))
          .toList();
      filterCustomers.sort(
          (a, b) => a.desc!.toLowerCase().compareTo(b.desc!.toLowerCase()));
      data = MyDataDetailStorico(filterCustomers);
    }
    update();
  }

  void orderByData() {
    if (dataAsc) {
      storico.sort((a, b) => int.parse(a.data!).compareTo(int.parse(b.data!)));
      data = MyDataDetailStorico(storico);
    } else {
      storico.sort((a, b) => int.parse(b.data!).compareTo(int.parse(a.data!)));
      data = MyDataDetailStorico(storico);
    }
    dataAsc = !dataAsc;
    update();
  }

  void orderByDoc() {
    storico.sort((a, b) => a.documento!.compareTo(b.documento!));
    data = MyDataDetailStorico(storico);
    update();
  }

  void orderByCodArt() {
    storico.sort((a, b) => a.codArt!.compareTo(b.codArt!));
    data = MyDataDetailStorico(storico);
    update();
  }

  void orderByDesc() {
    storico.sort((a, b) => a.desc!.compareTo(b.desc!));
    data = MyDataDetailStorico(storico);
    update();
  }

  void orderByUm() {
    storico.sort((a, b) => a.um!.compareTo(b.um!));
    data = MyDataDetailStorico(storico);
    update();
  }

  void orderByPrezzo() {
    storico.sort((a, b) => a.prezzo!.compareTo(b.prezzo!));
    data = MyDataDetailStorico(storico);
    update();
  }

  void orderByImporto() {
    storico.sort((a, b) => a.importo!.compareTo(b.importo!));
    data = MyDataDetailStorico(storico);
    update();
  }

  void orderByIva() {
    storico.sort((a, b) => a.iva!.compareTo(b.iva!));
    data = MyDataDetailStorico(storico);
    update();
  }
}
