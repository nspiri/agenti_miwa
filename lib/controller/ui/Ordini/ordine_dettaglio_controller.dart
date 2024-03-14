import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:foody/helpers/storage/local_storage.dart';
import 'package:foody/helpers/utils/do_http_request.dart';
import 'package:foody/model/articolo.dart';
import 'package:foody/model/cart_model.dart';
import 'package:foody/model/customer_detail.dart';
import 'package:foody/model/nota.dart';
import 'package:foody/model/ordine.dart';
import 'package:foody/views/my_controller.dart';
import 'package:get/get.dart';
import 'package:foody/model/request.dart' as r;

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
