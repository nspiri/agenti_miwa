import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mexalorder/helpers/storage/local_storage.dart';
import 'package:mexalorder/helpers/utils/do_http_request.dart';
import 'package:mexalorder/helpers/utils/global.dart';
import 'package:mexalorder/helpers/utils/show_message_dialogs.dart';
import 'package:mexalorder/helpers/utils/utils.dart';
import 'package:mexalorder/helpers/widgets/my_text.dart';
import 'package:mexalorder/model/articolo.dart';
import 'package:mexalorder/model/calcolo_totale.dart';
import 'package:mexalorder/model/cart_model.dart';
import 'package:mexalorder/model/customer_detail.dart';
import 'package:mexalorder/model/listino.dart';
import 'package:mexalorder/model/nota.dart';
import 'package:mexalorder/model/user.dart';
import 'package:mexalorder/views/my_controller.dart';
import 'package:get/get.dart';
import 'package:mexalorder/model/request.dart' as r;
import 'package:syncfusion_flutter_pdf/pdf.dart';

class CartController extends MyController {
  BuildContext context;
  late double order = 0, tax = 30, offer = 50, total = 0;
  List<Articolo> carrello = [];
  List<Articolo> articoliCancellati = [];
  List<Listino> listini = [];
  CustomerDetail? destinazione;
  CustomerDetail? fattA;
  double scAb = 0, abbuono = 0, totaleDaPagare = 0;
  bool loading = true;
  TextEditingController notaIncasso = TextEditingController();
  TextEditingController notaConsegna = TextEditingController();
  CalcoloTotale allTot = CalcoloTotale([], 0, 0, 0, 0, 0, 0, 0);
  bool inviaLoading = false, loadingCliente = true;
  bool isModificaPrezzo = true, isModificaSconto = true;
  CartController({required this.context});

  @override
  void onInit() {
    super.onInit();
  }

  getData(CustomerDetail cliente) async {
    carrello = [];
    User? u = LocalStorage.getLoggedUser();
    if (u != null) {
      isModificaPrezzo = u.modificaPrezzo ?? true;
      isModificaSconto = u.modificaSconto ?? true;
    }
    destinazione = cliente;
    listini = await Utils.getNomeListini();
    fattA = null;
    if (destinazione?.codCliFattA != "") {
      fattA = await getCliente(destinazione!.codCliFattA!);
    }
    loadingCliente = false;
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

  aggiungiArticoli2(List<Articolo> articoli) async {
    loading = true;
    //update();
    if (articoli.length > 0) {
      List<Map<String, dynamic>> art = [];

      for (var element in articoli) {
        art.add({
          "articolo": element.codArt,
          "quantita": element.conf,
          "listino": element.listinoSelezionato?.listino ?? 1,
          "prezzo": 0,
          "sconto": "",
          "omaggio": element.applicaOmaggio ? 1 : 0
        });
      }

      Map<String, dynamic> payload = {
        "agente": LocalStorage.getLoggedUser()?.codiceAgente,
        "cliente": fattA?.codiceCliente ?? destinazione?.codiceCliente ?? "",
        "data": "",
        "documento": "OC",
        "magazzino": 1,
        "tipo_immagine": "C",
        "articoli": art
      };

      r.Response res = await DoRequest.doHttpRequest(
          nomeCollage: "colsrart",
          etichettaCollage: "GET_CONDDOC2",
          dati: payload);

      if (res.code == 200) {
        List<dynamic> data = json.decode(jsonEncode(res.result));
        List<CondDoc> condDoc = data.map((e) => CondDoc.fromJson(e)).toList();
        assegnaPrezzi(condDoc, articoli);
        //return condDoc;
      } else {
        loading = false;
        update();
        showErrorMessage(context, "Attenzione", res.error);
      }
      return null;
    }
    return null;
  }

  assegnaPrezzi(List<CondDoc> condDoc, List<Articolo> articoli) {
    for (var articolo in articoli) {
      for (var cond in condDoc) {
        if (articolo.codArt == cond.arcod) {
          articolo.icona ??= cond.arcae;
          PrezzoArticolo p = PrezzoArticolo(
              omaggio: cond.omaggio,
              prezzo: cond.prezzo,
              provvigione: cond.provvigione,
              scalaSconti: cond.scalaSconti,
              sconto: cond.sconto,
              tipoProvvigione: cond.tipoProvvigione);
          articolo.prezzoArticolo ??= p;
          if (articolo.listinoSelezionato == null) {
            articolo.prezzoListini = elaboraListini(articolo.prezzoListini!);
            articolo.listinoSelezionato = articolo.prezzoListini?[0];
            articolo.textControllerListino.text =
                "€${Utils.formatStringDecimal(articolo.prezzoListini?[0].valore, 3)}";
          } else {
            for (Arprz l in articolo.prezzoListini ?? []) {
              if (l.listino == articolo.listinoSelezionato?.listino) {
                articolo.listinoSelezionato = l;
              }
            }
          }
          if (articolo.scontoSelezionato == null) {
            articolo.scontoSelezionato =
                articolo.prezzoArticolo?.scalaSconti?[0];
            articolo.textControllerSconto.text =
                articolo.scontoSelezionato?.sconto == ""
                    ? "Nessuno sconto"
                    : "${articolo.scontoSelezionato?.sconto}%";
            /* if (element.prezzoArticolo?.sconto != "") {
          element.scontoSelezionato = ScalaSconti(
              sconto: element.prezzoArticolo?.sconto,
              prezzo: element.prezzoArticolo?.prezzo,
              provvigione: element.prezzoArticolo?.provvigione as double,
              tipoProvvigione: "%");
          element.textControllerSconto.text =
              "${element.prezzoArticolo?.sconto}%";
        } else {
          element.scontoSelezionato = element.prezzoArticolo?.scalaSconti?[0];
          element.textControllerSconto.text =
              element.scontoSelezionato?.sconto == ""
                  ? "Nessuno sconto"
                  : "${element.scontoSelezionato?.sconto}%";
        }*/
          }
          articolo.importo = articolo.prezzoArticolo?.prezzo ?? 0;
        }
      }
    }
    carrello = articoli;
    getTotali(null);
    if (carrello.isEmpty) {
      allTot.azzeraRighe();
    }
    carrelloGlobale = carrello;
    LocalStorage.setCarrelloGlobale(carrello);
    /* loading = false;
    update();*/
  }

  aggiungiArticoli(List<Articolo> articoli) async {
    loading = true;
    //update();
    for (var element in articoli) {
      element.icona ??= await getImmagineArticolo(element.codArt!);
      element.prezzoArticolo ??= await getPrezzoArticolo(element);
      if (element.listinoSelezionato == null) {
        element.prezzoListini = elaboraListini(element.prezzoListini!);
        element.listinoSelezionato = element.prezzoListini?[0];
        element.textControllerListino.text =
            "€${Utils.formatStringDecimal(element.prezzoListini?[0].valore, 3)}";
      } else {
        for (Arprz l in element.prezzoListini ?? []) {
          if (l.listino == element.listinoSelezionato?.listino) {
            element.listinoSelezionato = l;
          }
        }
      }
      if (element.scontoSelezionato == null) {
        element.scontoSelezionato = element.prezzoArticolo?.scalaSconti?[0];
        element.textControllerSconto.text =
            element.scontoSelezionato?.sconto == ""
                ? "Nessuno sconto"
                : "${element.scontoSelezionato?.sconto}%";
        /* if (element.prezzoArticolo?.sconto != "") {
          element.scontoSelezionato = ScalaSconti(
              sconto: element.prezzoArticolo?.sconto,
              prezzo: element.prezzoArticolo?.prezzo,
              provvigione: element.prezzoArticolo?.provvigione as double,
              tipoProvvigione: "%");
          element.textControllerSconto.text =
              "${element.prezzoArticolo?.sconto}%";
        } else {
          element.scontoSelezionato = element.prezzoArticolo?.scalaSconti?[0];
          element.textControllerSconto.text =
              element.scontoSelezionato?.sconto == ""
                  ? "Nessuno sconto"
                  : "${element.scontoSelezionato?.sconto}%";
        }*/
      }
      element.importo = element.prezzoArticolo?.prezzo ?? 0;
      //getTotali(null);
      //element.loading = false;
      update();
    }
    carrello = articoli;
    getTotali(null);
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
    art.loadingPrezzo = true;
    update();
    for (var element in carrello) {
      if (art.codArt == element.codArt) {
        var tempSconto = element.scontoSelezionato;
        //element.scontoSelezionato = null;
        update();
        element.prezzoArticolo = await getPrezzoArticolo(element);
        if (element.prezzoArticolo?.scalaSconti != null && tempSconto != null) {
          element.scontoSelezionato = element.prezzoArticolo?.scalaSconti
              ?.where((element) => element.sconto == tempSconto.sconto)
              .first;
        } else {
          element.scontoSelezionato = element.prezzoArticolo?.scalaSconti?[0];
        }
        if (element.prezzoArticolo?.scalaSconti != null) {
          element.importo = (element.scontoSelezionato?.sconto != ""
                  ? element.scontoSelezionato?.prezzo
                  : element.prezzoArticolo?.prezzo) ??
              0;
        } else {
          element.scontoSelezionato = null;
          element.importo = element.prezzoArticolo?.prezzo ?? 0;
        }
        await getTotali(null);
      }
    }
    art.loadingPrezzo = false;
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

  preventivo() async {
    List<dynamic> articoli = [];
    for (var element in carrello) {
      articoli.add({
        "articolo": element.codArt,
        "colli": int.parse(element.conf?.toStringAsFixed(0) ?? "0"),
        "quantita": element.qtaArt,
        "prezzo": element.prezzoArticolo?.prezzo,
        "sconto": element.scontoSelezionato?.sconto ?? "",
        "omaggio": element.applicaOmaggio ? applicaOmaggio(element) : 0,
        "iva": element.iva,
        "provvigione": element.prezzoArticolo?.provvigione
      });
    }
    r.Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrdoc",
        etichettaCollage: "PREVENTIVO",
        dati: {
          "cliente": fattA?.codiceCliente ?? destinazione?.codiceCliente ?? "",
          "agente": LocalStorage.getLoggedUser()?.codiceAgente,
          "destinazione":
              fattA == null ? "" : destinazione?.codiceCliente ?? "",
          "pagamento": int.parse(fattA != null
              ? fattA?.codicePagamento ?? "0"
              : destinazione?.codicePagamento ?? "0"),
          "articoli": articoli
        });
    String pdf = "";
    if (res.code == 200) {
      var result = res.result as List<dynamic>;
      if (result[0]["pdf"] != null) {
        if (result.isNotEmpty) {
          for (var element in result[0]["pdf"]) {
            pdf += element;
          }
          Uint8List pdfExp = base64
              .decode(pdf.replaceAll(RegExp(r'\s+'), '').replaceAll("[", ""));
          PdfDocument document = PdfDocument(inputBytes: pdfExp);
          final List<int> bytes = document.saveSync();
          document.dispose();
          await Utils.saveAndLaunchFile(bytes, 'Preventivo.pdf');
        }
      }
    } else {
      //showErrorMessage(context, "Nessuna immagine", "");
    }
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
            } else {
              getTotali(null);
            }
            update();
          }
        });
      }
    }
  }

  getTotali(Articolo? art) async {
    if (art != null) {
      art.loadingPrezzo = true;
      update();
    }
    List<dynamic> articoli = [];
    for (var element in carrello) {
      articoli.add({
        "articolo": element.codArt,
        "colli": int.parse(element.conf?.toStringAsFixed(0) ?? "0"),
        "quantita": element.qtaArt,
        "prezzo": element.prezzoArticolo?.prezzo,
        "sconto": element.scontoSelezionato?.sconto ?? "",
        "omaggio": element.applicaOmaggio ? applicaOmaggio(element) : 0,
        "iva": element.iva,
        "provvigione": element.prezzoArticolo?.provvigione
      });
    }
    dynamic dati = {
      "cliente": fattA?.codiceCliente ?? destinazione?.codiceCliente ?? "",
      "agente": LocalStorage.getLoggedUser()?.codiceAgente,
      "destinazione": fattA == null ? "" : destinazione?.codiceCliente ?? "",
      "pagamento": int.parse(fattA != null
          ? fattA?.codicePagamento ?? "0"
          : destinazione?.codicePagamento ?? "0"),
      "articoli": articoli,
    };
    r.Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrdoc", etichettaCollage: "OC_TOTALI", dati: dati);
    if (res.code == 200) {
      dynamic data = json.decode(jsonEncode(res.result));
      CalcoloTotale tot = CalcoloTotale.fromJson(data[0]);
      allTot = tot;
      carrelloGlobale = carrello;
      LocalStorage.setCarrelloGlobale(carrello);
      applicaPrezzi(tot);
      loading = false;
      update();
    } else {
      loading = false;
      update();
      showErrorMessage(
          context,
          "Errore",
          /*"Si è verificato un errore durante il calcolo dei prezzi."*/ res
              .error);
    }
    if (art != null) {
      art.loadingPrezzo = false;
    }
    update();
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
    clienteSelezionato = null;
    articoliCancellati = [];
    carrello = [];
    carrelloGlobale = [];
    LocalStorage.setCarrelloGlobale([]);
    fattA = null;
    destinazione = null;
    notaConsegna.text = "";
    notaIncasso.text = "";
    allTot.azzeraRighe();
    LocalStorage.setCarrello([]);
    LocalStorage.setDettCli(null);
    LocalStorage.setFattA(null);
    LocalStorage.setNotaConsegna("");
    LocalStorage.setNotaIncasso("");
    update();
    Get.toNamed("/admin/customers/list");
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
    if (allTot.totaleMerceLordo == 0) {
      showErrorMessage(context, "Attenzione",
          "L'ordine non può essere inviato perchè il totale del documento è 0 €.");
      return false;
    }
    if (destinazione == null || destinazione?.codiceCliente == "") {
      showErrorMessage(context, "Attenzione", "La destinazione non è presente");
      return false;
    }
    return true;
  }

  inviaOrdine() async {
    if (controlloOrdine()) {
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
                  child: MyText.titleLarge(
                    "Confermi l'invio dell'ordine?",
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            content: Container(
                constraints: BoxConstraints(minWidth: 100, maxWidth: 500),
                child: MyText.labelMedium("", maxLines: 10)),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: MyText.labelMedium("No"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: MyText.labelMedium("Si"),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      ).then((value) async {
        inviaLoading = true;
        update();
        if (value as bool == true) {
          List<dynamic> articoli = [];
          for (var element in carrello) {
            articoli.add({
              "articolo": element.codArt,
              "colli": element.conf,
              "quantita": element.qtaArt,
              "prezzo": element.prezzoArticolo?.prezzo,
              "sconto": element.scontoSelezionato?.sconto ?? "",
              "omaggio": element.applicaOmaggio ? applicaOmaggio(element) : 0,
              "iva": element.iva,
              "provvigione": element.prezzoArticolo?.provvigione,
              "nota": ""
            });
          }
          r.Response res = await DoRequest.doHttpRequest(
              nomeCollage: "colsrdoc",
              etichettaCollage: "OC_CREA",
              dati: {
                "cliente":
                    fattA?.codiceCliente ?? destinazione?.codiceCliente ?? "",
                "agente": LocalStorage.getLoggedUser()?.codiceAgente,
                "destinazione":
                    fattA == null ? "" : destinazione?.codiceCliente ?? "",
                "pagamento": int.parse(fattA != null
                    ? fattA?.codicePagamento ?? "0"
                    : destinazione?.codicePagamento ?? "0"),
                "nota_consegna": notaConsegna.text,
                "nota_incasso": notaIncasso.text,
                "articoli": articoli,
              });
          inviaLoading = false;
          update();
          if (res.code == 200) {
            var result = res.result as List<dynamic>;
            if (result.isEmpty) {
              var message = res.error;
              showErrorMessage(context, "Attenzione", message);
            } else {
              if (res.error != "") {
                var message = res.error;
                showAlertMessage(context, "Attenzione", message);
              } else {
                dynamic data = json.decode(jsonEncode(res.result));
                DocumentoCreato documento = DocumentoCreato.fromJson(data[0]);
                dialogOrdineInviato(documento);
              }
            }
            update();
          }
        }
      });
    }
  }

  dialogOrdineInviato(DocumentoCreato documento) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 0),
                child: MyText.titleLarge("Ordine inviato"),
              ),
            ],
          ),
          content: Container(
              constraints: BoxConstraints(minWidth: 100, maxWidth: 500),
              child: MyText.labelMedium(
                  "Documento creato: ${documento.documento} ${documento.serie}/${documento.numero}",
                  maxLines: 10)),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: MyText.labelMedium("Ok"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ).then((value) {
      if (value as bool == true) {
        cancellaOrdine();
      }
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
