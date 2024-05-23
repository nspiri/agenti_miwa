import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:foody/helpers/storage/local_storage.dart';
import 'package:foody/helpers/utils/do_http_request.dart';
import 'package:foody/helpers/utils/global.dart';
import 'package:foody/helpers/utils/show_message_dialogs.dart';
import 'package:foody/helpers/utils/utils.dart';
import 'package:foody/helpers/widgets/my_text.dart';
import 'package:foody/model/articolo.dart';
import 'package:foody/model/calcolo_totale.dart';
import 'package:foody/model/cart_model.dart';
import 'package:foody/model/customer_detail.dart';
import 'package:foody/model/listino.dart';
import 'package:foody/model/nota.dart';
import 'package:foody/model/user.dart';
import 'package:foody/views/my_controller.dart';
import 'package:get/get.dart';
import 'package:foody/model/request.dart' as r;
import 'package:syncfusion_flutter_pdf/pdf.dart';

class ListaController extends MyController {
  BuildContext context;
  late double order = 0, tax = 30, offer = 50, total = 0;
  List<Articolo> carrello = [];
  List<Articolo> articoliCancellati = [];
  List<Listino> listini = [];
  CustomerDetail? destinazione;
  CustomerDetail? fattA;
  double scAb = 0, abbuono = 0, totaleDaPagare = 0;
  bool loading = false;
  TextEditingController notaIncasso = TextEditingController();
  TextEditingController notaConsegna = TextEditingController();
  CalcoloTotale allTot = CalcoloTotale([], 0, 0, 0, 0, 0, 0, 0);
  bool inviaLoading = false, loadingCliente = true;
  bool isModificaPrezzo = true, isModificaSconto = true;
  ListaController({required this.context});
  bool isOffline = false;

  @override
  void onInit() {
    super.onInit();
  }

  getData(CustomerDetail cliente) async {
    User? u = LocalStorage.getLoggedUser();
    isOffline = LocalStorage.getOffline();
    if (u != null) {
      isModificaPrezzo = u.modificaPrezzo ?? true;
      isModificaSconto = u.modificaSconto ?? true;
    }
    destinazione = cliente;
    listini = LocalStorage.getListini() ?? [];
    fattA = null;
    if (destinazione?.codCliFattA != "") {
      fattA = LocalStorage.getFattA();
    }
    loadingCliente = false;
    aggiungiArticoli(LocalStorage.getCarrello() ?? []);
    notaIncasso.text = LocalStorage.getNotaIncasso() ?? "";
    notaConsegna.text = LocalStorage.getNotaConsegna() ?? "";

    update();
  }

  List<ScalaSconti> getSconti(Articolo art) {
    for (var element in carrello) {
      if (element.codArt == art.codArt) {
        List<ScalaSconti> matches = [];
        matches.addAll(element.prezzoArticolo?.scalaSconti ?? []);
        return matches;
      }
    }
    return [];
  }

  List<Arprz> getListini(Articolo art) {
    for (var element in carrello) {
      if (element.codArt == art.codArt) {
        List<Arprz> matches = [];
        matches.addAll(element.prezzoListini ?? []);
        return matches;
      }
    }
    return [];
  }

  Future<String> getNoteCliente(String codCliente) async {
    r.Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrcli",
        etichettaCollage: "GET_CLI_NOTE",
        dati: {
          "agente": LocalStorage.getLoggedUser()?.codiceAgente,
          "cliente": codCliente
        });

    if (res.code == 200) {
      var a = res.result as dynamic;
      List<dynamic> dati = json.decode(jsonEncode(a));
      if (dati != []) {
        List<Nota> nota = dati.map((e) => Nota.fromJson(e)).toList();
        String note = "";
        for (var element in nota) {
          note += "${element.nota}";
        }
        return note;
      }
      return "";
    } else {
      return "";
    }
  }

  getCliente(String codCliente) async {
    r.Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrcli",
        etichettaCollage: "CLIENTE",
        dati: {"cliente": codCliente});

    if (res.code == 200) {
      var a = res.result as dynamic;
      dynamic data = json.decode(jsonEncode(a));
      return CustomerDetail.listFromJSON(data[0]);
    } else {
      //ERRORE
      return null;
    }
  }

  aggiungiArticoli(List<Articolo> articoli) async {
    loading = true;
    update();
    for (var element in articoli) {
      //element.icona ??= await getImmagineArticolo(element.codArt!);
      //element.prezzoArticolo ??= await getPrezzoArticolo(element);
      if (element.listinoSelezionato == null) {
        element.prezzoListini = elaboraListini(element.prezzoListini!);
        element.listinoSelezionato = element.prezzoListini?[0];
        element.textControllerListino.text =
            "€${Utils.formatStringDecimal(element.prezzoListini?[0].valore, 3)}";
      } else {
        element.prezzoListini = elaboraListini(element.prezzoListini!);
        for (var list in element.prezzoListini!) {
          if (list.listino == element.listinoSelezionato?.listino) {
            element.listinoSelezionato = list;
          }
        }
      }
      aggiornaPrezzoArticolo(element);

      element.loading = false;
      update();
    }
    carrello = articoli;
    if (carrello.isEmpty) {
      allTot.azzeraRighe();
    }
    carrelloGlobale = carrello;
    LocalStorage.setCarrelloGlobale(carrello);
    loading = false;
    update();
  }

  List<Arprz> elaboraListini(List<Arprz> list) {
    /* for (var i = 0; i < list.length; i++) {
      if (list[i].valore == 0) {
        list.removeAt(i);
      }
    }*/
    for (var i = 0; i < list.length; i++) {
      for (var c = 0; c < listini.length; c++) {
        if (list[i].listino == listini[c].numero) {
          list[i].descrizione = listini[c].descrizione ?? "";
        }
      }
    }
    return list;
  }

  aggiornaPrezzoArticolo(Articolo art) async {
    art.importo = art.listinoSelezionato?.valore ?? 0;
    art.importoTotale = (art.importo * (art.qtaArt ?? 1)) * (art.conf ?? 1);
    update();
  }

  applicaOmaggio(Articolo art) {
    int qtaOmaggio = 0;
    for (var c = art.prezzoArticolo!.omaggio!.qtaPresa!;
        c <= art.conf!;
        c = c + art.prezzoArticolo!.omaggio!.qtaPresa!) {
      qtaOmaggio++;
    }
    return qtaOmaggio;
  }

  Future<Uint8List?> getImmagineArticolo(String cod) async {
    String img = "";
    r.Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrart",
        etichettaCollage: "ARTICOLO",
        dati: {"magazzino": 1, "articolo": cod});

    if (res.code == 200) {
      var result = res.result as List<dynamic>;
      if (result[0]["arcae"] != null) {
        if (result.isNotEmpty) {
          for (var element in result[0]["arcae"]) {
            img += element;
          }
          return base64
              .decode(img.replaceAll(RegExp(r'\s+'), '').replaceAll("[", ""));
        }
      }
    } else {
      //showErrorMessage(context, "Nessuna immagine", "");
    }
    return null;
  }

  convertiOrdine() async {
    Get.toNamed('/cart',
        arguments:
            PassaggioDatiOrdine(cliente: destinazione, carrello: carrello));
  }

  Future<PrezzoArticolo?> getPrezzoArticolo(Articolo art) async {
    r.Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrart",
        etichettaCollage: "GET_CONDDOC",
        dati: {
          "cliente": fattA?.codiceCliente ?? destinazione?.codiceCliente ?? "",
          "agente": LocalStorage.getLoggedUser()?.codiceAgente,
          "articolo": art.codArt,
          "data": "",
          "documento": "OC",
          "quantita": art.conf,
          "listino": art.listinoSelezionato?.listino ?? 1,
          "prezzo": 0,
          "sconto": "",
          "omaggio": art.applicaOmaggio ? 1 : 0
        });

    if (res.code == 200) {
      dynamic data = json.decode(jsonEncode(res.result));
      PrezzoArticolo prezzoArticolo = PrezzoArticolo.fromJson(data[0]);
      return prezzoArticolo;
    } else {
      //showErrorMessage(context, "Nessuna immagine", "");
    }
    return null;
  }

  void decrement(Articolo art) {
    if (art.conf! > 1) {
      art.conf = art.conf! - 1;
      aggiornaPrezzoArticolo(art);
    }
    update();
  }

  void increment(Articolo art) {
    if (((art.conf! + 1) * (art.qtaArt ?? 1)) <= art.disponibile!) {
      // if (art.conf! + 1 <= art.disponibile!) {
      art.conf = art.conf! + 1;
      aggiornaPrezzoArticolo(art);
    }
    update();
  }

  void onChangeApplicaOmaggio(Articolo art, bool? value) {
    art.applicaOmaggio = value ?? art.applicaOmaggio;
    if (art.applicaOmaggio) {
      art.scontoSelezionato = art.prezzoArticolo?.scalaSconti?[0];
      art.prezzoArticolo?.provvigione = art.scontoSelezionato?.provvigione;
      art.importo = art.scontoSelezionato?.prezzo ?? 0;
      //applicaOmaggio(art);
    } else {
      art.importo = art.scontoSelezionato?.prezzo ?? 0;
      art.textControllerSconto.text = art.scontoSelezionato?.sconto == ""
          ? "Nessuno sconto"
          : "${art.scontoSelezionato?.sconto}%";
      art.prezzoArticolo?.provvigione = art.scontoSelezionato?.provvigione;
      //art.importoTotale = art.importo * art.conf!;
    }
    aggiornaPrezzoArticolo(art);
    update();
  }

  void delete(Articolo art) {
    for (var i = 0; i < carrello.length; i++) {
      if (art.codArt == carrello[i].codArt) {
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(
                    size: 50,
                    Icons.error,
                    color: Colors.orange,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: MyText.titleMedium(
                      "Attenzione",
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              content: Container(
                  constraints: BoxConstraints(minWidth: 100, maxWidth: 500),
                  child: MyText.bodySmall(
                      "Cancellare l'articolo ${art.descrizione}?",
                      maxLines: 10)),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: MyText.bodySmall("No"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: MyText.bodySmall("Si"),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        ).then((value) {
          if (value as bool == true) {
            carrello[i].scontoSelezionato = null;
            carrello[i].listinoSelezionato = null;
            carrello[i].applicaOmaggio = false;
            carrello[i].prezzoArticolo = null;
            carrello[i].importo = 0;
            carrello[i].importoTotale = 0;
            articoliCancellati.add(carrello[i]);
            carrello.removeAt(i);
            if (carrello.isEmpty) {
              allTot.azzeraRighe();
            }
            update();
          }
        });
      }
    }
  }

  double get totale {
    double totale = 0;

    for (var element in carrello) {
      totale = totale + element.importoTotale;
    }

    return totale;
  }

  cancellaOrdine() {
    for (var i = 0; i < carrello.length; i++) {
      carrello[i].scontoSelezionato = null;
      carrello[i].listinoSelezionato = null;
      carrello[i].applicaOmaggio = false;
      carrello[i].prezzoArticolo = null;
      carrello[i].importo = 0;
      carrello[i].importoTotale = 0;
    }
    articoliCancellati = [];
    carrello = [];
    carrelloGlobale = [];
    LocalStorage.setCarrelloGlobale([]);
    fattA = null;
    destinazione = null;
    notaConsegna.text = "";
    notaIncasso.text = "";
    LocalStorage.setCarrello([]);
    LocalStorage.setNotaIncasso("");
    LocalStorage.setNotaConsegna("");
    update();
    Get.toNamed("/admin/customers/detail");
  }

  bool controlloOrdine() {
    bool ok = true;
    if (carrello.isEmpty) {
      showErrorMessage(context, "Attenzione",
          "Inserisci almeno un articolo nel tuo ordine per poterlo inviare.");
      return false;
    }
    for (var element in carrello) {
      if (element.importoTotale == 0) {
        showErrorMessage(context, "Attenzione",
            "L'articolo ${element.descrizione} non può essere inviato perchè il prezzo è 0 €.");
        return false;
      }
    }
    if (totale == 0) {
      showErrorMessage(context, "Attenzione",
          "L'ordine non può essere inviato perchè il totale del documento è 0 €.");
      return false;
    }
    return true;
  }

  salvaLista() async {
    LocalStorage.setCarrello(carrello);
    LocalStorage.setNotaIncasso(notaIncasso.text);
    LocalStorage.setNotaConsegna(notaConsegna.text);
    dialogOrdineInviato();
  }

  dialogOrdineInviato() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 0),
                child: MyText.titleLarge("Lista salvata"),
              ),
            ],
          ),
          content: Container(
              constraints: BoxConstraints(minWidth: 100, maxWidth: 500),
              child: MyText.labelMedium(
                  "Una volta tornato online potrai convertirla in ordine cliente.",
                  maxLines: 10)),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: MyText.labelMedium("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).then((value) {
      //cancellaOrdine();
    });
  }

  applicaPrezzi(CalcoloTotale tot) {
    for (var element in carrello) {
      for (var prezzo in tot.rigaDettaglio!) {
        if (element.codArt == prezzo.articolo) {
          element.importoTotale = prezzo.importo ?? 0;
        }
      }
    }
  }

  bool increaseAble(CartData cart) {
    return cart.quantity < cart.quantity;
  }

  bool decreaseAble(CartData cart) {
    return cart.quantity > 1;
  }

  void gotoExplore() {
    Get.toNamed('/foods');
  }
}
