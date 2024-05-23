import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:foody/helpers/storage/local_storage.dart';
import 'package:foody/helpers/utils/do_http_request.dart';
import 'package:foody/helpers/utils/show_message_dialogs.dart';
import 'package:foody/helpers/utils/utils.dart';
import 'package:foody/model/articolo.dart';
import 'package:foody/model/listino.dart';
import 'package:foody/model/request.dart' as r;
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
  ScrollController scrollController = ScrollController();
  List<Articolo> articoliMobile = [];
  int currentPage = 1;
  int articlesPerPage = 20;

  bool loadingDownloadOffline = false;

  TextEditingController codice = TextEditingController();
  TextEditingController desc = TextEditingController();
  TextEditingController codAlt = TextEditingController();
  TextEditingController cat = TextEditingController();

  FoodController({required this.context});

  @override
  void onInit() {
    Articolo.dummyList.then((value) {
      articoli = value;
      articoliFiltrati = articoli;
      articoliFiltrati.sort((a, b) =>
          a.descrizione!.toLowerCase().compareTo(b.descrizione!.toLowerCase()));
      caricaArticoli();
      scrollController.addListener(_scrollListener);
      data = MyData(articoliFiltrati, context, this);
      loading = false;
      update();
    });
    getData();
    super.onInit();
  }

  void scaricaArticoli() {
    loadingDownloadOffline = true;
    update();
    Articolo.dummyList.then((value) {
      articoli = value;
      LocalStorage.setArticoli(articoli);
      showSuccessMessage(context, "Articoli scaricati!", "");
      loadingDownloadOffline = false;
      update();
      update();
    });
  }

  void caricaArticoli() {
    articoliMobile = [];
    for (int i = 0; i <= articlesPerPage; i++) {
      if (i < articoliFiltrati.length) {
        articoliMobile.add(articoliFiltrati[i]);
      } else {
        break;
      }
    }
  }

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      _loadMoreArticles();
    }
  }

  void _loadMoreArticles() {
    currentPage++;
    for (int i = 1; i <= articlesPerPage; i++) {
      var num = i + (currentPage - 1) * articlesPerPage;
      if (i + (currentPage - 1) * articlesPerPage < articoliFiltrati.length) {
        articoliMobile
            .add(articoliFiltrati[i + (currentPage - 1) * articlesPerPage]);
      } else {
        break;
      }
    }
    update();
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      _loadMoreArticles();
    }
  }

  getData() async {
    bool isOffline = LocalStorage.getOffline();
    if (isOffline) {
      listini = LocalStorage.getListini();
    } else {
      listini = await Utils.getNomeListini();
    }
  }

  @override
  void onThemeChanged() {
    data = MyData(articoliFiltrati, context, this);
    update();
  }

  void filterByName(String value) {
    if (value == "") {
      articoliFiltrati = articoli;
      data = MyData(articoliFiltrati, context, this);
    } else {
      articoliFiltrati = articoli
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
      articoliFiltrati.sort((a, b) =>
          a.descrizione!.toLowerCase().compareTo(b.descrizione!.toLowerCase()));
      caricaArticoli();
      data = MyData(articoliFiltrati, context, this);
    }
    update();
  }

  void filtro() {
    articoliFiltrati = articoli
        .where((element) =>
            element.codArt!.toLowerCase().contains(codice.text.toLowerCase()) &&
            element.descrizione!
                .toLowerCase()
                .contains(desc.text.toLowerCase()) &&
            element.codAlt!.toLowerCase().contains(codAlt.text.toLowerCase()) &&
            element.catStatistica!
                .toLowerCase()
                .contains(cat.text.toLowerCase()))
        .toList();

    sortDesc = null;
    sortCodAlt = null;
    sortPrezzo1 = null;
    sortPrezzo2 = null;
    sortPrezzo3 = null;
    sortDisp = null;
    sortCat = null;
    sortDesc = false;
    sortCodArt = null;
    caricaArticoli();
    data = MyData(articoliFiltrati, context, this);

    update();
  }

  void mostraImmagine(Articolo articolo) async {
    String img = "";
    r.Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrart",
        etichettaCollage: "ARTICOLO",
        dati: {"magazzino": 1, "articolo": articolo.codArt});

    if (res.code == 200) {
      var result = res.result as List<dynamic>;
      if (result.isNotEmpty) {
        if (result[0]["arime"] != null) {
          for (var element in result[0]["arime"]) {
            img += element;
          }
          await showDialog(
              context: context,
              builder: (_) => Dialog(
                    child: Stack(
                      children: [
                        Image.memory(
                          base64.decode(img
                              .replaceAll(RegExp(r'\s+'), '')
                              .replaceAll("[", "")),
                          //base64Decode(img),
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                            right: 0,
                            child: IconButton(
                              icon: Icon(Icons.cancel),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              alignment: Alignment.topRight,
                            ))
                      ],
                    ),
                  ));
        } else {
          showErrorMessage(context, "Nessuna immagine", "");
        }
      }
    } else {
      showErrorMessage(context, "Nessuna immagine", "");
    }
  }

  tuttiGliArticoli() {
    isPromo = false;
    loading = true;
    codice.text = "";
    desc.text = "";
    codAlt.text = "";
    cat.text = "";
    update();
    Articolo.dummyList.then((value) {
      articoli = value;
      articoliFiltrati = value;
      sortArt();
      caricaArticoli();
      data = MyData(articoliFiltrati, context, this);
      loading = false;
      update();
    });
  }

  promo() async {
    isPromo = true;
    loading = true;
    isPromo = false;
    loading = true;
    codice.text = "";
    desc.text = "";
    codAlt.text = "";
    cat.text = "";
    update();
    articoli = articoli
        .where((element) =>
            element.prezzoListini
                ?.where((element) => element.listino == 2)
                .first
                .valore !=
            0)
        .toList();
    articoliFiltrati = articoli;
    sortArt();
    caricaArticoli();
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
