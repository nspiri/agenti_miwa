import 'package:flutter/material.dart';
import 'package:foody/model/customer_detail.dart';
import 'package:foody/views/my_controller.dart';
import 'package:foody/views/ui/Attrezzature/attrezzature_screen.dart';

class AttrezzatureCondController extends MyController {
  DataTableSource? data;
  bool dataAsc = true;
  List<Attrezzatura> attrezzature = [];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onThemeChanged() {
    data = MyDataDetailAttrezzatureCond(attrezzature);
    update();
  }

  setAttrezzature(List<Attrezzatura> attr) async {
    attrezzature = attr;
    data = MyDataDetailAttrezzatureCond(attrezzature);
  }

  void filterByName(String value) {
    if (value == "") {
      data = MyDataDetailAttrezzatureCond(attrezzature);
    } else {
      var filterCustomers = attrezzature
          .where((element) =>
              element.attrezzatura!
                  .toLowerCase()
                  .contains(value.toLowerCase()) ||
              element.natura!.toLowerCase().contains(value.toLowerCase()))
          .toList();
      data = MyDataDetailAttrezzatureCond(filterCustomers);
    }
    update();
  }

  void orderByData() {
    if (dataAsc) {
      attrezzature.sort((a, b) =>
          int.parse(a.dataInizio!).compareTo(int.parse(b.dataInizio!)));
      data = MyDataDetailAttrezzatureCond(attrezzature);
    } else {
      attrezzature.sort((a, b) =>
          int.parse(b.dataInizio!).compareTo(int.parse(a.dataInizio!)));
      data = MyDataDetailAttrezzatureCond(attrezzature);
    }
    dataAsc = !dataAsc;
    update();
  }
}
