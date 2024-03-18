import 'package:flutter/material.dart';
import 'package:foody/helpers/utils/global.dart';
import 'package:foody/model/customer_detail.dart';
import 'package:foody/views/my_controller.dart';
import 'package:foody/views/ui/customer/attrezzature_customer.dart';

class AttrezzatureController extends MyController {
  DataTableSource? data;
  bool dataAsc = true;
  String? codiceCliente;
  List<Attrezzatura> attrezzature = [];

  @override
  void onInit() {
    super.onInit();
    getScadenziarioCliente();
  }

  @override
  void onThemeChanged() {
    data = MyDataDetailAttrezzature(attrezzature);
    update();
  }

  getScadenziarioCliente() async {
    codiceCliente = clienteSelezionato?.codiceCliente;
    attrezzature = clienteSelezionato?.attrezzature ?? [];
    data = MyDataDetailAttrezzature(attrezzature);
  }

  void filterByName(String value) {
    if (value == "") {
      data = MyDataDetailAttrezzature(attrezzature);
    } else {
      var filterCustomers = attrezzature
          .where((element) =>
              element.attrezzatura!
                  .toLowerCase()
                  .contains(value.toLowerCase()) ||
              element.natura!.toLowerCase().contains(value.toLowerCase()))
          .toList();
      data = MyDataDetailAttrezzature(filterCustomers);
    }
    update();
  }

  void orderByData() {
    if (dataAsc) {
      attrezzature.sort((a, b) =>
          int.parse(a.dataInizio!).compareTo(int.parse(b.dataInizio!)));
      data = MyDataDetailAttrezzature(attrezzature);
    } else {
      attrezzature.sort((a, b) =>
          int.parse(b.dataInizio!).compareTo(int.parse(a.dataInizio!)));
      data = MyDataDetailAttrezzature(attrezzature);
    }
    dataAsc = !dataAsc;
    update();
  }
}
