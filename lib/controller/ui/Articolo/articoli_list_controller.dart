import 'package:flutter/material.dart';
import 'package:foody/helpers/utils/utils.dart';
import 'package:foody/model/articolo.dart';
import 'package:foody/model/listino.dart';
import 'package:foody/views/my_controller.dart';
import 'package:foody/views/ui/Articolo/articoli_list_screen.dart';
import 'package:get/get.dart';

class FoodController extends MyController {
  BuildContext context;
  List<Articolo> articoli = [], articoliFiltrati = [];
  DataTableSource? data;
  List<Listino>? listini;
  bool loading = true;
  bool isPromo = false;
  bool? sortCodArt,
      sortDesc = false,
      sortCodAlt,
      sortPrezzo1,
      sortPrezzo2,
      sortPrezzo3,
      sortDisp,
      sortCat;

  FoodController({required this.context});

  @override
  void onInit() {
    Articolo.dummyList.then((value) {
      articoli = value;
      articoliFiltrati = articoli;
      articoliFiltrati.sort((a, b) =>
          a.descrizione!.toLowerCase().compareTo(b.descrizione!.toLowerCase()));
      data = MyData(articoliFiltrati, context, this);
      loading = false;
      update();
    });
    getData();
    super.onInit();
  }

  getData() async {
    listini = await Utils.getNomeListini();
  }

  @override
  void onThemeChanged() {
    data = MyData(articoliFiltrati, context, this);
    update();
  }

  void filterByName(String value) {
    if (value == "") {
      data = MyData(articoliFiltrati, context, this);
    } else {
      var filterCustomers = articoliFiltrati
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
      data = MyData(filterCustomers, context, this);
    }
    update();
  }

  tuttiGliArticoli() {
    isPromo = false;
    loading = true;
    update();
    Articolo.dummyList.then((value) {
      articoliFiltrati = value;
      sortArt();
      data = MyData(articoliFiltrati, context, this);
      loading = false;
      update();
    });
  }

  promo() async {
    isPromo = true;
    loading = true;
    update();
    articoliFiltrati = articoli
        .where((element) =>
            element.prezzoListini
                ?.where((element) => element.listino == 2)
                .first
                .valore !=
            0)
        .toList();
    sortArt();
    data = MyData(articoliFiltrati, context, this);
    loading = false;
    update();
  }

  sortArt() {
    if (sortCodArt != null) {
      sortCodArt = !sortCodArt!;
      orderByCodArt();
    }
    if (sortDesc != null) {
      sortDesc = !sortDesc!;
      orderByDesc();
    }
    if (sortCodAlt != null) {
      sortCodAlt = !sortCodAlt!;
      orderByCodAlt();
    }
    if (sortPrezzo1 != null) {
      sortPrezzo1 = !sortPrezzo1!;
      orderByPrezzo1();
    }
    if (isPromo) {
      if (sortPrezzo2 != null) {
        sortPrezzo2 = !sortPrezzo2!;
        orderByPrezzo2();
      }
    }
    if (isPromo == false) {
      if (sortPrezzo3 != null) {
        sortPrezzo3 = !sortPrezzo3!;
        orderByPrezzo3();
      }
    }
    if (sortDisp != null) {
      sortDisp = !sortDisp!;
      orderByDispo();
    }
    if (sortCat != null) {
      sortCat = !sortCat!;
      orderByCatArt();
    }
  }

  void orderByCodArt() {
    sortDesc = null;
    sortCodAlt = null;
    sortPrezzo1 = null;
    sortPrezzo2 = null;
    sortPrezzo3 = null;
    sortDisp = null;
    sortCat = null;
    sortDesc = null;
    sortCodArt ??= true;
    if (sortCodArt!) {
      articoliFiltrati.sort(
          (a, b) => a.codArt!.toLowerCase().compareTo(b.codArt!.toLowerCase()));
      data = MyData(articoliFiltrati, context, this);
    } else {
      articoliFiltrati.sort(
          (a, b) => b.codArt!.toLowerCase().compareTo(a.codArt!.toLowerCase()));
      data = MyData(articoliFiltrati, context, this);
    }
    sortCodArt = !sortCodArt!;
    update();
  }

  void orderByDesc() {
    sortCodArt = null;
    sortCodAlt = null;
    sortPrezzo1 = null;
    sortPrezzo2 = null;
    sortPrezzo3 = null;
    sortDisp = null;
    sortCat = null;
    sortDesc ??= true;
    if (sortDesc!) {
      articoliFiltrati.sort((a, b) =>
          a.descrizione!.toLowerCase().compareTo(b.descrizione!.toLowerCase()));
      data = MyData(articoliFiltrati, context, this);
    } else {
      articoliFiltrati.sort((a, b) =>
          b.descrizione!.toLowerCase().compareTo(a.descrizione!.toLowerCase()));
      data = MyData(articoliFiltrati, context, this);
    }
    sortDesc = !sortDesc!;
    update();
  }

  void orderByCodAlt() {
    sortDesc = null;
    sortPrezzo1 = null;
    sortPrezzo2 = null;
    sortPrezzo3 = null;
    sortDisp = null;
    sortCat = null;
    sortDesc = null;
    sortCodAlt ??= true;
    if (sortCodAlt!) {
      articoliFiltrati.sort(
          (a, b) => a.codAlt!.toLowerCase().compareTo(b.codAlt!.toLowerCase()));
      data = MyData(articoliFiltrati, context, this);
    } else {
      articoliFiltrati.sort(
          (a, b) => b.codAlt!.toLowerCase().compareTo(a.codAlt!.toLowerCase()));
      data = MyData(articoliFiltrati, context, this);
    }
    sortCodAlt = !sortCodAlt!;
    update();
  }

  void orderByPrezzo1() {
    sortDesc = null;
    sortCodArt = null;
    sortPrezzo2 = null;
    sortPrezzo3 = null;
    sortDisp = null;
    sortCat = null;
    sortDesc = null;
    sortCodAlt = null;
    sortPrezzo1 ??= true;
    if (sortPrezzo1!) {
      articoliFiltrati.sort((a, b) =>
          a.prezzoListini![0].valore!.compareTo(b.prezzoListini![0].valore!));
      data = MyData(articoliFiltrati, context, this);
    } else {
      articoliFiltrati.sort((a, b) =>
          b.prezzoListini![0].valore!.compareTo(a.prezzoListini![0].valore!));
      data = MyData(articoliFiltrati, context, this);
    }
    sortPrezzo1 = !sortPrezzo1!;
    update();
  }

  void orderByPrezzo2() {
    sortDesc = null;
    sortCodArt = null;
    sortPrezzo1 = null;
    sortPrezzo3 = null;
    sortDisp = null;
    sortCat = null;
    sortDesc = null;
    sortCodAlt = null;
    sortPrezzo2 ??= true;
    if (sortPrezzo2!) {
      articoliFiltrati.sort((a, b) =>
          a.prezzoListini![1].valore!.compareTo(b.prezzoListini![1].valore!));
      data = MyData(articoliFiltrati, context, this);
    } else {
      articoliFiltrati.sort((a, b) =>
          b.prezzoListini![1].valore!.compareTo(a.prezzoListini![1].valore!));
      data = MyData(articoliFiltrati, context, this);
    }
    sortPrezzo2 = !sortPrezzo2!;
    update();
  }

  void orderByPrezzo3() {
    sortDesc = null;
    sortCodArt = null;
    sortPrezzo2 = null;
    sortPrezzo1 = null;
    sortDisp = null;
    sortCat = null;
    sortDesc = null;
    sortCodAlt = null;
    sortPrezzo3 ??= true;
    if (sortPrezzo3!) {
      articoliFiltrati.sort((a, b) =>
          a.prezzoListini![2].valore!.compareTo(b.prezzoListini![2].valore!));
      data = MyData(articoliFiltrati, context, this);
    } else {
      articoliFiltrati.sort((a, b) =>
          b.prezzoListini![2].valore!.compareTo(a.prezzoListini![2].valore!));
      data = MyData(articoliFiltrati, context, this);
    }
    sortPrezzo3 = !sortPrezzo3!;
    update();
  }

  void orderByDispo() {
    sortDesc = null;
    sortCodArt = null;
    sortPrezzo2 = null;
    sortPrezzo1 = null;
    sortPrezzo3 = null;
    sortCat = null;
    sortDesc = null;
    sortCodAlt = null;
    sortDisp ??= true;
    if (sortDisp!) {
      articoliFiltrati.sort((a, b) => a.disponibile!.compareTo(b.disponibile!));
      data = MyData(articoliFiltrati, context, this);
    } else {
      articoliFiltrati.sort((a, b) => b.disponibile!.compareTo(a.disponibile!));
      data = MyData(articoliFiltrati, context, this);
    }
    sortDisp = !sortDisp!;
    update();
  }

  void orderByCatArt() {
    sortDesc = null;
    sortCodArt = null;
    sortPrezzo2 = null;
    sortPrezzo1 = null;
    sortPrezzo3 = null;
    sortDesc = null;
    sortCodAlt = null;
    sortDisp = null;
    sortCat ??= true;
    if (sortCat!) {
      articoliFiltrati.sort((a, b) => a.catStatistica!
          .toLowerCase()
          .compareTo(b.catStatistica!.toLowerCase()));
      data = MyData(articoliFiltrati, context, this);
    } else {
      articoliFiltrati.sort((a, b) => b.catStatistica!
          .toLowerCase()
          .compareTo(a.catStatistica!.toLowerCase()));
      data = MyData(articoliFiltrati, context, this);
    }
    sortCat = !sortCat!;
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
