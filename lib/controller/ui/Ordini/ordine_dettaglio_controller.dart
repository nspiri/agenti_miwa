import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mexalorder/helpers/utils/do_http_request.dart';
import 'package:mexalorder/model/ordine.dart';
import 'package:mexalorder/views/my_controller.dart';
import 'package:mexalorder/model/request.dart' as r;

class OrderDetailController extends MyController {
  BuildContext context;
  late double order = 0, tax = 30, offer = 50, total = 0;
  Ordine? ordine;
  bool loading = true;
  List<RigaDettaglio> righeDett = [];
  OrderDetailController({required this.context});

  getData(Ordine ordine) async {
    loading = true;
    //update();
    this.ordine = ordine;
    if (ordine.rigaDettaglio.isEmpty) {
      righeDett = await getDettalioOrdine(ordine);
    }
    loading = false;
    update();
  }

  getDettalioOrdine(Ordine ordine) async {
    r.Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrdoc",
        etichettaCollage: "OC_DETTAGLIO",
        dati: {
          "sigla": ordine.ocsig,
          "serie": ordine.ocser,
          "numero": ordine.ocnum
        });

    if (res.code == 200) {
      var a = res.result as dynamic;
      List<dynamic> dati = json.decode(jsonEncode(a));
      if (dati != []) {
        List<RigaDettaglio> dett =
            dati.map((e) => RigaDettaglio.fromJson(e)).toList();
        return dett;
      }
    } else {
      //ERRORE
      return null;
    }
  }
}
