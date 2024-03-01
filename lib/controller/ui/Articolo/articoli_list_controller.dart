import 'package:flutter/material.dart';
import 'package:foody/model/articolo.dart';
import 'package:foody/views/my_controller.dart';
import 'package:foody/views/ui/Articolo/articoli_list_screen.dart';
import 'package:get/get.dart';

class FoodController extends MyController {
  BuildContext context;
  List<Articolo> articoli = [];
  DataTableSource? data;
  bool sortPrezzo = false;
  bool sortDisp = false;
  bool loading = true;

  FoodController({required this.context});

  @override
  void onInit() {
    Articolo.dummyList.then((value) {
      articoli = value;
      articoli.sort((a, b) =>
          a.descrizione!.toLowerCase().compareTo(b.descrizione!.toLowerCase()));
      data = MyData(articoli, context);
      loading = false;
      update();
    });
    super.onInit();
  }

  @override
  void onThemeChanged() {
    data = MyData(articoli, context);
    update();
  }

  void filterByName(String value) {
    if (value == "") {
      data = MyData(articoli, context);
    } else {
      var filterCustomers = articoli
          .where((element) =>
              element.descrizione!
                  .toLowerCase()
                  .contains(value.toLowerCase()) ||
              element.codArt!.toLowerCase().contains(value.toLowerCase()) ||
              element.codAlt!.toLowerCase().contains(value.toLowerCase()) ||
              element.catStatistica!
                  .toLowerCase()
                  .contains(value.toLowerCase()))
          .toList();
      filterCustomers.sort((a, b) =>
          a.descrizione!.toLowerCase().compareTo(b.descrizione!.toLowerCase()));
      data = MyData(filterCustomers, context);
    }
    update();
  }

  void orderByDesc() {
    articoli.sort((a, b) =>
        a.descrizione!.toLowerCase().compareTo(b.descrizione!.toLowerCase()));
    data = MyData(articoli, context);
    update();
  }

  void orderByCodAlt() {
    articoli.sort(
        (a, b) => a.codAlt!.toLowerCase().compareTo(b.codAlt!.toLowerCase()));
    data = MyData(articoli, context);
    update();
  }

  void orderByPrezzo() {
    if (sortPrezzo) {
      articoli.sort((a, b) =>
          a.prezzoListini![0].valore!.compareTo(b.prezzoListini![0].valore!));
      data = MyData(articoli, context);
    } else {
      articoli.sort((a, b) =>
          b.prezzoListini![0].valore!.compareTo(a.prezzoListini![0].valore!));
      data = MyData(articoli, context);
    }
    sortPrezzo = !sortPrezzo;
    update();
  }

  void orderByDispo() {
    if (sortDisp) {
      articoli.sort((a, b) => a.disponibile!.compareTo(b.disponibile!));
      data = MyData(articoli, context);
    } else {
      articoli.sort((a, b) => b.disponibile!.compareTo(a.disponibile!));
      data = MyData(articoli, context);
    }
    sortDisp = !sortDisp;
    update();
  }

  void orderByCatArt() {
    articoli.sort((a, b) => a.catStatistica!
        .toLowerCase()
        .compareTo(b.catStatistica!.toLowerCase()));
    data = MyData(articoli, context);
    update();
  }

  void gotoEditScreen() {
    Get.toNamed("/admin/food/edit");
  }

  void gotoAddScreen() {
    Get.toNamed('/admin/food/create');
  }

  void gotoDetailScreen() {
    Get.toNamed("/admin/food/detail");
  }
}
