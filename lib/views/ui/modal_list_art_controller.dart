import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foody/helpers/utils/do_http_request.dart';
import 'package:foody/helpers/utils/utils.dart';
import 'package:foody/model/articolo.dart';
import 'package:foody/model/listino.dart';
import 'package:foody/views/my_controller.dart';
import 'package:foody/views/ui/modal_list_art.dart';
import 'package:get/get.dart';
import 'package:foody/model/request.dart' as r;

class ModalListaArtController extends MyController {
  BuildContext context;
  List<Articolo> articoli = [],
      articoliFiltrati = [],
      articoliSelezionati = [],
      articoliCancellati = [];
  DataTableSource? data;
  List<Listino>? listini;
  bool? sortCodArt,
      sortDesc = false,
      sortCodAlt,
      sortConf,
      sortPrezzo1,
      sortPrezzo2,
      sortPrezzo3,
      sortDisp,
      sortCat;
  bool loading = true;

  bool isPromo = false, isTop10 = false, isAll = true;

  ModalListaArtController(
      {required this.context,
      required this.articoliSelezionati,
      required this.articoliCancellati});

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    listini = await Utils.getNomeListini();
  }

  @override
  void onThemeChanged() {
    data = MyDataListArtModal(articoliFiltrati, context, this);
    update();
  }

  modificaArticolo(Articolo articolo) {
    int index = controlloArticoloSelezionato(articolo);
    if (index == -1) {
      if (articolo.conf != 0) {
        articoliSelezionati.add(articolo);
      }
    } else {
      if (articolo.conf != 0) {
        articoliSelezionati[index].conf = articolo.conf;
      } else {
        articoliSelezionati.removeAt(index);
      }
    }
    update();
  }

  int controlloArticoloSelezionato(Articolo art) {
    if (articoliSelezionati.isNotEmpty) {
      for (dynamic c = 0; c < articoliSelezionati.length; c++) {
        if (art.codArt == articoliSelezionati[c].codArt) {
          return c;
        }
      }
      return -1;
    } else {
      return -1;
    }
  }

  modificaConfArt() {
    if (articoliSelezionati.isEmpty) {
      for (var c = 0; c < articoli.length; c++) {
        articoli[c].conf = 0;
        articoliFiltrati = articoli;
      }
    } else {
      for (var c = 0; c < articoliFiltrati.length; c++) {
        for (var i = 0; i < articoliSelezionati.length; i++) {
          if (articoliFiltrati[c].codArt == articoliSelezionati[i].codArt) {
            articoliFiltrati[c].conf = articoliSelezionati[i].conf;
            break;
          }
        }
        for (var i = 0; i < articoliCancellati.length; i++) {
          if (articoliFiltrati[c].codArt == articoliCancellati[i].codArt) {
            articoliFiltrati[c].conf = 0;
            break;
          }
        }
      }
    }

    update();
  }

  tuttiGliArticoli(List<Articolo> artSel, List<Articolo> artCanc) {
    isPromo = false;
    isAll = true;
    isTop10 = false;
    articoliSelezionati = artSel;
    articoliCancellati = artCanc;
    setLoading(true);
    Articolo.dummyList.then((value) {
      articoli = value;
      articoliFiltrati = articoli;
      sortArt();
      data = MyDataListArtModal(articoliFiltrati, context, this);
      modificaConfArt();
      setLoading(false);
      update();
    });
  }

  top10(String codCli) async {
    isPromo = false;
    isAll = false;
    isTop10 = true;
    setLoading(true);
    r.Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrart",
        etichettaCollage: "TOP_VENDITE",
        dati: {"magazzino": 1, "cliente": codCli, "top": 70});

    if (res.code == 200) {
      var a = res.result as List<dynamic>;
      if (a.isEmpty) {
        articoliFiltrati = [];
        setData();
      }
      dynamic dati = json.decode(jsonEncode(a));
      articoliFiltrati = Articolo.listFromJSON(dati);
      sortArt();
      setData();
      modificaConfArt();
      setLoading(false);
      update();
    } else {
      setLoading(false);
      return "";
    }
  }

  setData() {
    data = MyDataListArtModal(articoliFiltrati, context, this);
  }

  promo() async {
    isPromo = true;
    isAll = false;
    isTop10 = false;
    setLoading(true);
    articoliFiltrati = articoli
        .where((element) =>
            element.prezzoListini
                ?.where((element) => element.listino == 2)
                .first
                .valore !=
            0)
        .toList();
    sortArt();
    data = MyDataListArtModal(articoliFiltrati, context, this);
    modificaConfArt();
    setLoading(false);
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
    if (sortConf != null) {
      sortConf = !sortConf!;
      orderByConf();
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

  setLoading(bool value) {
    loading = value;
    update();
  }

  void filterByName(String value) {
    if (value == "") {
      data = MyDataListArtModal(articoliFiltrati, context, this);
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
      data = MyDataListArtModal(articoliFiltrati, context, this);
    }
    update();
  }

  void orderByCodArt() {
    sortDesc = null;
    sortCodAlt = null;
    sortConf = null;
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
      data = MyDataListArtModal(articoliFiltrati, context, this);
    } else {
      articoliFiltrati.sort(
          (a, b) => b.codArt!.toLowerCase().compareTo(a.codArt!.toLowerCase()));
      data = MyDataListArtModal(articoliFiltrati, context, this);
    }
    sortCodArt = !sortCodArt!;
    update();
  }

  void orderByDesc() {
    sortCodArt = null;
    sortCodAlt = null;
    sortConf = null;
    sortPrezzo1 = null;
    sortPrezzo2 = null;
    sortPrezzo3 = null;
    sortDisp = null;
    sortCat = null;
    sortDesc ??= true;
    if (sortDesc!) {
      articoliFiltrati.sort((a, b) =>
          a.descrizione!.toLowerCase().compareTo(b.descrizione!.toLowerCase()));
      data = MyDataListArtModal(articoliFiltrati, context, this);
    } else {
      articoliFiltrati.sort((a, b) =>
          b.descrizione!.toLowerCase().compareTo(a.descrizione!.toLowerCase()));
      data = MyDataListArtModal(articoliFiltrati, context, this);
    }
    sortDesc = !sortDesc!;
    update();
  }

  void orderByCodAlt() {
    sortDesc = null;
    sortConf = null;
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
      data = MyDataListArtModal(articoliFiltrati, context, this);
    } else {
      articoliFiltrati.sort(
          (a, b) => b.codAlt!.toLowerCase().compareTo(a.codAlt!.toLowerCase()));
      data = MyDataListArtModal(articoliFiltrati, context, this);
    }
    sortCodAlt = !sortCodAlt!;
    update();
  }

  void orderByConf() {
    sortDesc = null;
    sortCodArt = null;
    sortPrezzo1 = null;
    sortPrezzo2 = null;
    sortPrezzo3 = null;
    sortDisp = null;
    sortCat = null;
    sortDesc = null;
    sortCodAlt = null;
    sortConf ??= false;
    if (sortConf!) {
      articoliFiltrati.sort((a, b) => (a.conf ?? 0).compareTo(b.conf ?? 0));
      data = MyDataListArtModal(articoliFiltrati, context, this);
    } else {
      articoliFiltrati.sort((a, b) => (b.conf ?? 0).compareTo(a.conf ?? 0));
      data = MyDataListArtModal(articoliFiltrati, context, this);
    }
    sortConf = !sortConf!;
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
    sortConf = null;
    sortPrezzo1 ??= true;
    if (sortPrezzo1!) {
      articoliFiltrati.sort((a, b) =>
          a.prezzoListini![0].valore!.compareTo(b.prezzoListini![0].valore!));
      data = MyDataListArtModal(articoliFiltrati, context, this);
    } else {
      articoliFiltrati.sort((a, b) =>
          b.prezzoListini![0].valore!.compareTo(a.prezzoListini![0].valore!));
      data = MyDataListArtModal(articoliFiltrati, context, this);
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
    sortConf = null;
    sortPrezzo2 ??= true;
    if (sortPrezzo2!) {
      articoliFiltrati.sort((a, b) =>
          a.prezzoListini![1].valore!.compareTo(b.prezzoListini![1].valore!));
      data = MyDataListArtModal(articoliFiltrati, context, this);
    } else {
      articoliFiltrati.sort((a, b) =>
          b.prezzoListini![1].valore!.compareTo(a.prezzoListini![1].valore!));
      data = MyDataListArtModal(articoliFiltrati, context, this);
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
    sortConf = null;
    sortPrezzo3 ??= true;
    if (sortPrezzo3!) {
      articoliFiltrati.sort((a, b) =>
          a.prezzoListini![2].valore!.compareTo(b.prezzoListini![2].valore!));
      data = MyDataListArtModal(articoliFiltrati, context, this);
    } else {
      articoliFiltrati.sort((a, b) =>
          b.prezzoListini![2].valore!.compareTo(a.prezzoListini![2].valore!));
      data = MyDataListArtModal(articoliFiltrati, context, this);
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
    sortConf = null;
    sortDisp ??= true;
    if (sortDisp!) {
      articoliFiltrati.sort((a, b) => a.disponibile!.compareTo(b.disponibile!));
      data = MyDataListArtModal(articoliFiltrati, context, this);
    } else {
      articoliFiltrati.sort((a, b) => b.disponibile!.compareTo(a.disponibile!));
      data = MyDataListArtModal(articoliFiltrati, context, this);
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
    sortConf = null;
    sortDisp = null;
    sortCat ??= true;
    if (sortCat!) {
      articoliFiltrati.sort((a, b) => a.catStatistica!
          .toLowerCase()
          .compareTo(b.catStatistica!.toLowerCase()));
      data = MyDataListArtModal(articoliFiltrati, context, this);
    } else {
      articoliFiltrati.sort((a, b) => b.catStatistica!
          .toLowerCase()
          .compareTo(a.catStatistica!.toLowerCase()));
      data = MyDataListArtModal(articoliFiltrati, context, this);
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
