import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foody/helpers/storage/local_storage.dart';
import 'package:foody/helpers/utils/do_http_request.dart';
import 'package:foody/model/articolo.dart';
import 'package:foody/model/storico.dart';
import 'package:foody/views/my_controller.dart';
import 'package:foody/views/ui/lista_storico_articolo.dart';
import 'package:get/get.dart';
import 'package:foody/model/request.dart' as r;

class ModalListaStoricoArtController extends MyController {
  BuildContext context;
  Articolo articolo;
  List<Storico> storico = [];
  DataTableSource? data;
  bool dataAsc = true;
  String codCliente;
  bool loading = true;

  ModalListaStoricoArtController(
      {required this.context,
      required this.codCliente,
      required this.articolo});

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onThemeChanged() {
    data = MyDataListStoricoArtModal(storico);
    update();
  }

  storicoArticolo(String codCli, String codArt) async {
    setLoading(true);
    bool isOffline = LocalStorage.getOffline();

    if (isOffline) {
      storico = (LocalStorage.getStorico() ?? [])
          .where((element) => element.codArt == codArt)
          .toList();
      storico.sort((a, b) => int.parse(b.data!).compareTo(int.parse(a.data!)));
      data = MyDataListStoricoArtModal(storico);
      setLoading(false);
      update();
    } else {
      r.Response res = await DoRequest.doHttpRequest(
          nomeCollage: "colsrcli",
          etichettaCollage: "STORICO",
          dati: {
            "agente": LocalStorage.getLoggedUser()?.codiceAgente,
            "cliente": codCliente,
            "articolo": codArt
          });

      if (res.code == 200) {
        var a = res.result as List<dynamic>;
        if (a.isEmpty) {
          MyDataListStoricoArtModal([]);
        }
        List<dynamic> dati = json.decode(jsonEncode(a));
        if (dati != []) {
          storico = dati.map((e) => Storico.fromJson(e)).toList();
          storico
              .sort((a, b) => int.parse(b.data!).compareTo(int.parse(a.data!)));
        }
        data = MyDataListStoricoArtModal(storico);
        setLoading(false);
        update();
      } else {
        setLoading(false);
        return "";
      }
    }
  }

  void orderByData() {
    if (dataAsc) {
      storico.sort((a, b) => int.parse(a.data!).compareTo(int.parse(b.data!)));
      data = MyDataListStoricoArtModal(storico);
    } else {
      storico.sort((a, b) => int.parse(b.data!).compareTo(int.parse(a.data!)));
      data = MyDataListStoricoArtModal(storico);
    }
    dataAsc = !dataAsc;
    update();
  }

  setLoading(bool value) {
    loading = value;
    update();
  }

  /*void filterByName(String value) {
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
  }*/

  /* void orderByDesc() {
    articoliFiltrati.sort((a, b) =>
        a.descrizione!.toLowerCase().compareTo(b.descrizione!.toLowerCase()));
    data = MyDataListArtModal(articoliFiltrati, context, this);
    update();
  }*/

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
