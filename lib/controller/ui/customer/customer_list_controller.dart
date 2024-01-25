import 'package:flutter/material.dart';
import 'package:foody/helpers/utils/utils.dart';
import 'package:foody/model/customer_list.dart';
import 'package:foody/views/my_controller.dart';
import 'package:foody/views/ui/customer/customer_list_screen.dart';
import 'package:get/get.dart';

class CustomerListController extends MyController {
  List<CustomersList> customers = [];
  DataTableSource? data;

  @override
  void onInit() {
    CustomersList.dummyList.then((value) {
      customers = value.sublist(10, value.length);
      customers.sort((a, b) =>
          a.descrizione!.toLowerCase().compareTo(b.descrizione!.toLowerCase()));
      data = MyData(customers);
      update();
    });
    super.onInit();
  }

  @override
  void onThemeChanged() {
    data = MyData(customers);
    update();
  }

  void gotoCustomerAdd() {
    Get.toNamed('/admin/customers/create');
  }

  void filterByName(String value) {
    if (value == "") {
      data = MyData(customers);
    } else {
      var filterCustomers = customers
          .where((element) =>
              element.descrizione!.toLowerCase().contains(value.toLowerCase()))
          .toList();
      data = MyData(filterCustomers);
    }
    update();
  }

  void orderByName() {
    customers.sort((a, b) =>
        a.descrizione!.toLowerCase().compareTo(b.descrizione!.toLowerCase()));
    data = MyData(customers);
    update();
  }

  void orderByLocalita() {
    customers.sort((a, b) =>
        a.localita!.toLowerCase().compareTo(b.localita!.toLowerCase()));
    data = MyData(customers);
    update();
  }

  void orderByProvincia() {
    customers.sort((a, b) =>
        a.provincia!.toLowerCase().compareTo(b.provincia!.toLowerCase()));
    data = MyData(customers);
    update();
  }

  void orderByIndirizzo() {
    customers.sort((a, b) =>
        a.indirizzo!.toLowerCase().compareTo(b.indirizzo!.toLowerCase()));
    data = MyData(customers);
    update();
  }

  void orderByEmail() {
    customers.sort(
        (a, b) => a.email!.toLowerCase().compareTo(b.email!.toLowerCase()));
    data = MyData(customers);
    update();
  }

  void orderByUltimaConsegna() {
    customers.sort((a, b) =>
        Utils.stringToDate(a.dataUltimaConsegna!.toLowerCase()).compareTo(
            Utils.stringToDate(b.dataUltimaConsegna!.toLowerCase())));
    data = MyData(customers);
    update();
  }
}
