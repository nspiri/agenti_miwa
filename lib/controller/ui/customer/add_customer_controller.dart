import 'dart:convert';
import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mexalorder/helpers/storage/local_storage.dart';
import 'package:mexalorder/helpers/utils/do_http_request.dart';
import 'package:mexalorder/helpers/utils/show_message_dialogs.dart';
import 'package:mexalorder/helpers/utils/utils.dart';
import 'package:mexalorder/helpers/widgets/my_form_validator.dart';
import 'package:mexalorder/helpers/widgets/my_text.dart';
import 'package:mexalorder/model/customer_category.dart';
import 'package:mexalorder/model/customers_fa.dart';
import 'package:mexalorder/model/nazionalita.dart';
import 'package:mexalorder/model/request.dart';
import 'package:mexalorder/model/tipo_attivita.dart';
import 'package:mexalorder/model/tipo_soc.dart';
import 'package:mexalorder/model/zone_clienti.dart';
import 'package:mexalorder/views/my_controller.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:time_range/time_range.dart';
import 'package:signature/signature.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class AddCustomerController extends MyController {
  BuildContext context;
  bool loading = false,
      isChecked = false,
      destDiversa = false,
      isCheckedDest = false;
  List<Nazionalita> nazionalita = [];
  Nazionalita? nazionalitaSelezionata;
  List<Paesi> paesi = [], paesiFiltrati = [], paesiDestFiltrati = [];
  Paesi? paeseSelezionato;
  List<Comuni> comuni = [], comuniFiltrati = [], comuniDestFiltrati = [];
  Comuni? comuneSelezionato;
  List<CustomerCategory> categorieClienti = [];
  CustomerCategory? categoriaClienteSelezionata;
  List<ZoneClienti> zoneClienti = [];
  ZoneClienti? zonaClienteSelezionata;
  List<CustomersFA> clientiFA = [];
  List<TipoSocieta> tipoSocieta = [];
  TipoSocieta? tiposocietaSelezionata;
  List<int> documento = [];

  //Campi destinazione
  TipoSocieta? tiposocietaSelezionataDest;
  Nazionalita? nazionalitaSelezionataDest;
  Paesi? paeseSelezionatoDest;
  Comuni? comuneSelezionatoDest;
  String orarioChiusura = "";
  List<ValueItem<TipoAttivita>> tipoAttivita = [];
  MyFormValidator basicValidator = MyFormValidator();
  final MultiSelectController<TipoAttivita> controllerTipoAttivita =
      MultiSelectController();
  final MultiSelectController<List> controllerGiorni = MultiSelectController();

  List<ValueItem<List>> giorni = [
    ValueItem<List>(label: "Lunedì mattina", value: [
      {"title": "Lunedì mattina", "id": "Lun/M"},
    ]),
    ValueItem<List>(label: "Martedì mattina", value: [
      {"title": "Martedì mattina", "id": "Mar/M"}
    ]),
    ValueItem<List>(label: "Mercoledì mattina", value: [
      {"title": "Mercoledì mattina", "id": "Mer/M"}
    ]),
    ValueItem<List>(label: "Giovedì mattina", value: [
      {"title": "Giovedì mattina", "id": "Gio/M"}
    ]),
    ValueItem<List>(label: "Venerdì mattina", value: [
      {"title": "Venerdì mattina", "id": "Ven/M"}
    ]),
    ValueItem<List>(label: "Sabato mattina", value: [
      {"title": "Sabato mattina", "id": "Sab/M"}
    ]),
    ValueItem<List>(label: "Domenica mattina", value: [
      {"title": "Domenica mattina", "id": "Dom/M"}
    ]),
    ValueItem<List>(label: "Lunedì pomeriggio", value: [
      {"title": "Lunedì pomeriggio", "id": "Lun/P"}
    ]),
    ValueItem<List>(label: "Martedì pomeriggio", value: [
      {"title": "Martedì pomeriggio", "id": "Mar/P"}
    ]),
    ValueItem<List>(label: "Mercoledì pomeriggio", value: [
      {"title": "Mercoledì pomeriggio", "id": "Mer/P"}
    ]),
    ValueItem<List>(label: "Giovedì pomeriggio", value: [
      {"title": "Giovedì pomeriggio", "id": "Gio/P"}
    ]),
    ValueItem<List>(label: "Venerdì pomeriggio", value: [
      {"title": "Venerdì pomeriggio", "id": "Ven/P"}
    ]),
    ValueItem<List>(label: "Sabato pomeriggio", value: [
      {"title": "Sabato pomeriggio", "id": "Sab/P"}
    ]),
    ValueItem<List>(label: "Domenica pomeriggio", value: [
      {"title": "Domenica pomeriggio", "id": "Dom/P"}
    ]),
  ];
  List giorniSelezionati = [];

  final SignatureController controllerSignature = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.red,
    exportBackgroundColor: Colors.transparent,
    exportPenColor: Colors.black,
    onDrawStart: () => print('onDrawStart called!'),
    onDrawEnd: () => print('onDrawEnd called!'),
  );

  AddCustomerController({required this.context});

  @override
  void onInit() {
    inizializzaCampi();
    Nazionalita.dummyList.then((value) {
      nazionalita = value;
      nazionalita.sort((a, b) =>
          a.descrizione!.toLowerCase().compareTo(b.descrizione!.toLowerCase()));
      nazionalitaSelezionata =
          nazionalita.where((element) => element.codice == "I").first;
      nazionalitaSelezionataDest =
          nazionalita.where((element) => element.codice == "I").first;
      update();
    });
    Paesi.dummyList.then((value) {
      paesi = value;
      paesi.sort((a, b) =>
          a.descrizione!.toLowerCase().compareTo(b.descrizione!.toLowerCase()));
      paesiFiltrati = paesi;
      paesiDestFiltrati = paesi;
      paeseSelezionato = paesi.where((element) => element.sigla == "IT").first;
      basicValidator.getController("paese").text =
          paeseSelezionato?.descrizione;
      paeseSelezionatoDest =
          paesi.where((element) => element.sigla == "IT").toList().first;
      basicValidator.getController("paeseDest").text =
          paeseSelezionato?.descrizione;
      update();
    });
    Comuni.dummyList.then((value) {
      comuni = value;
      comuni.sort((a, b) =>
          a.localita!.toLowerCase().compareTo(b.localita!.toLowerCase()));
      comuniFiltrati = comuni;
      comuniDestFiltrati = comuni;
      update();
    });
    CustomerCategory.dummyList.then((value) {
      categorieClienti = value;
      categorieClienti.sort(
          (a, b) => a.cxdes!.toLowerCase().compareTo(b.cxdes!.toLowerCase()));
      update();
    });
    ZoneClienti.dummyList.then((value) {
      zoneClienti = value;
      zoneClienti.sort(
          (a, b) => a.cydes!.toLowerCase().compareTo(b.cydes!.toLowerCase()));
      update();
    });
    /* Pagamenti.dummyList.then((value) {
      pagamenti = value;
      pagamenti.sort((a, b) =>
          a.descrizione!.toLowerCase().compareTo(b.descrizione!.toLowerCase()));
      if (pagamenti.length == 1) {
        pagamentoSelezionato = pagamenti[0];
      }
      update();
    });*/
    TipoAttivita.dummyList.then((value) {
      for (var element in value) {
        tipoAttivita.add(ValueItem<TipoAttivita>(
            label: element.descrizione!, value: element));
      }
      tipoAttivita.sort(
          (a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()));
      update();
    });
    TipoSocieta.dummyList.then((value) {
      tipoSocieta = value;
      tipoSocieta.sort((a, b) =>
          a.descrizione!.toLowerCase().compareTo(b.descrizione!.toLowerCase()));
      update();
    });
    super.onInit();
  }

  Future<void> exportImage(BuildContext context) async {
    if (controllerSignature.isEmpty) {
      showErrorMessage(
          context, "Attenzione", "Non è stata inserita alcuna firma");
      /* ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          key: Key('snackbarPNG'),
          content: Text('No content'),
        ),
      );*/
      return;
    }

    final Uint8List? data =
        await controllerSignature.toPngBytes(height: 1000, width: 1000);
    if (data == null) {
      return;
    }
    generateInvoice(data);
  }

  Future<void> generateInvoice(Uint8List? image) async {
    try {
      PdfDocument document =
          PdfDocument(inputBytes: await _readDocumentData("privacy.pdf"));

      PdfPage page = document.pages[0];
      Size pageSize = page.getClientSize();

      //PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);
      String text = basicValidator.getController("ragioneSociale").text;

      page.graphics.drawString(
          text, PdfCjkStandardFont(PdfCjkFontFamily.heiseiMinchoW3, 12),
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(
              40, pageSize.height - 60, pageSize.width, pageSize.height));

      page.graphics.drawString(Utils.dateToStringPdf(DateTime.now()),
          PdfCjkStandardFont(PdfCjkFontFamily.heiseiMinchoW3, 12),
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(pageSize.width - 330, pageSize.height - 60,
              pageSize.width, pageSize.height));

      page.graphics.drawImage(PdfBitmap(image!),
          Rect.fromLTWH(pageSize.width - 200, pageSize.height - 140, 200, 200));

      final List<int> bytes = document.saveSync();
      documento = bytes;
      document.dispose();
      //  await Utils.saveAndLaunchFile(bytes, 'Invoice.pdf');
    } catch (e) {
      e.toString();
    }

    //final PdfDocument document = PdfDocument();
    //   final PdfPage page = document.pages.add();

    /*   PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);
    String text = 'PRIVACY: TRATTAMENTO DEI DATI - art.13 reg. UE 2016/679';
    Size size = font.measureString(text);

    page.graphics.drawString(
        text, PdfCjkStandardFont(PdfCjkFontFamily.heiseiMinchoW3, 10),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(0, 0, size.width, size.height));*/
  }

  Future<List<int>> _readDocumentData(String name) async {
    final ByteData data = await rootBundle.load('assets/pdf/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  filtraPaesi(String value) {
    if (value == "") {
      paesiFiltrati = paesi;
    } else {
      paesiFiltrati = paesi
          .where((element) =>
              element.descrizione!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
    update();
  }

  filtraPaesiDest(String value) {
    if (value == "") {
      paesiDestFiltrati = paesi;
    } else {
      paesiDestFiltrati = paesi
          .where((element) =>
              element.descrizione!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
    update();
  }

  filtraComuni(String value) {
    if (value == "") {
      comuniFiltrati = comuni;
    } else {
      comuniFiltrati = comuni
          .where((element) =>
              element.localita!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
    update();
  }

  filtraComuniDest(String value) {
    if (value == "") {
      comuniDestFiltrati = comuni;
    } else {
      comuniDestFiltrati = comuni
          .where((element) =>
              element.localita!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
    update();
  }

  void onChangeCheckBox(bool? value) {
    isChecked = value ?? isChecked;
    basicValidator.getController("partIva").text = " ";
    update();
  }

  void onChangeCheckBoxDest(bool? value) {
    isCheckedDest = value ?? isCheckedDest;
    basicValidator.getController("partIvaDest").text = " ";
    update();
  }

  void onChangeDestDiversa(bool? value) {
    destDiversa = value ?? destDiversa;
    update();
  }

  inizializzaCampi() {
    basicValidator.addField('ragioneSociale',
        required: true,
        label: "",
        validators: [],
        controller: TextEditingController());
    basicValidator.addField('indirizzo',
        required: true,
        label: "",
        validators: [],
        controller: TextEditingController());
    basicValidator.addField('email',
        required: true,
        label: "",
        validators: [],
        controller: TextEditingController());
    basicValidator.addField('cap',
        required: true,
        label: "",
        validators: [],
        controller: TextEditingController());
    basicValidator.addField('provincia',
        required: true,
        label: "",
        validators: [],
        controller: TextEditingController());
    basicValidator.addField('referente',
        required: true,
        label: "",
        validators: [],
        controller: TextEditingController());
    basicValidator.addField('telefono',
        required: false,
        label: "",
        validators: [],
        controller: TextEditingController());
    basicValidator.addField('fax',
        required: true,
        label: "",
        validators: [],
        controller: TextEditingController());
    basicValidator.addField('codFisc',
        required: true,
        label: "",
        validators: [],
        controller: TextEditingController());
    basicValidator.addField('partIva',
        required: !isChecked,
        label: "",
        validators: [],
        controller: TextEditingController());
    basicValidator.addField('internet',
        required: false,
        label: "",
        validators: [],
        controller: TextEditingController());
    basicValidator.addField('nota2',
        required: false,
        label: "",
        validators: [],
        controller: TextEditingController());
    basicValidator.addField('nazionalita',
        required: true,
        label: "",
        validators: [],
        controller: SuggestionsBoxController());
    basicValidator.addField('paese',
        required: true,
        label: "",
        validators: [],
        controller: TextEditingController());
    basicValidator.addField('catCli',
        required: true,
        label: "",
        validators: [],
        controller: SuggestionsBoxController());
    basicValidator.addField('localita',
        required: true,
        label: "",
        validators: [],
        controller: TextEditingController());
    basicValidator.addField('zoneCli',
        required: true,
        label: "",
        validators: [],
        controller: SuggestionsBoxController());
    /*basicValidator.addField('pagamenti',
        required: true,
        label: "",
        validators: [],
        controller: SuggestionsBoxController());*/
    basicValidator.addField('tipoSoc',
        required: true,
        label: "",
        validators: [],
        controller: SuggestionsBoxController());
    basicValidator.addField('pec',
        required: false,
        label: "",
        validators: [],
        controller: TextEditingController());
    basicValidator.addField('codSDI',
        required: false,
        label: "",
        validators: [],
        controller: TextEditingController());
    //CAMPI DESTINAZIONE
    basicValidator.addField('ragSocDest',
        required: destDiversa,
        label: "",
        validators: [],
        controller: TextEditingController());
    basicValidator.addField('tipoSocDest',
        required: destDiversa,
        label: "",
        validators: [],
        controller: SuggestionsBoxController());
    basicValidator.addField('codFiscDest',
        required: destDiversa,
        label: "",
        validators: [],
        controller: TextEditingController());
    basicValidator.addField('partIvaDest',
        required: destDiversa && !isCheckedDest,
        label: "",
        validators: [],
        controller: TextEditingController());
    basicValidator.addField('nazionalitaDest',
        required: destDiversa,
        label: "",
        validators: [],
        controller: SuggestionsBoxController());
    basicValidator.addField('paeseDest',
        required: destDiversa,
        label: "",
        validators: [],
        controller: TextEditingController());
    basicValidator.addField('indirizzoDest',
        required: destDiversa,
        label: "",
        validators: [],
        controller: TextEditingController());
    basicValidator.addField('capDest',
        required: destDiversa,
        label: "",
        validators: [],
        controller: TextEditingController());
    basicValidator.addField('localitaDest',
        required: destDiversa,
        label: "",
        validators: [],
        controller: TextEditingController());
    basicValidator.addField('provinciaDest',
        required: destDiversa,
        label: "",
        validators: [],
        controller: TextEditingController());
    update();
  }

  List<Nazionalita> getNazionalita(String query) {
    List<Nazionalita> matches = [];
    matches.addAll(nazionalita);

    matches.retainWhere(
        (s) => s.descrizione!.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  List<Paesi> getPaesi(String query) {
    List<Paesi> matches = [];
    matches.addAll(paesi);

    matches.retainWhere(
        (s) => s.descrizione!.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  List<Comuni> getComuni(String query) {
    List<Comuni> matches = [];
    matches.addAll(comuni);

    matches.retainWhere(
        (s) => s.localita!.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  List<CustomerCategory> getCustomerCategory(String query) {
    List<CustomerCategory> matches = [];
    matches.addAll(categorieClienti);

    matches.retainWhere(
        (s) => s.cxdes!.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  List<ZoneClienti> getZoneClienti(String query) {
    List<ZoneClienti> matches = [];
    matches.addAll(zoneClienti);

    matches.retainWhere(
        (s) => s.cydes!.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  List<CustomersFA> getClientiFA(String query) {
    List<CustomersFA> matches = [];
    matches.addAll(clientiFA);

    matches.retainWhere(
        (s) => s.descrizione!.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  List<TipoSocieta> getTipoSocieta(String query) {
    List<TipoSocieta> matches = [];
    matches.addAll(tipoSocieta);

    matches.retainWhere(
        (s) => s.descrizione!.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  setOrarioChiusura(TimeRangeResult? range) {
    String minutiStart = "00";
    String minutiEnd = "00";
    if (range != null) {
      if (range.start.minute > 0) {
        minutiStart = range.start.minute.toString();
      }
      if (range.end.minute > 0) {
        minutiEnd = range.end.minute.toString();
      }
    }
    orarioChiusura =
        "Chiuso dalle ${range?.start.hour}:$minutiStart alle ${range?.end.hour}:$minutiEnd";
  }

  Future<void> inserisciCliente() async {
    loading = true;
    update();
    if (basicValidator.validateForm()) {
      if (controlloCampiInserimento()) {
        if (documento.isEmpty) {
          showDialog<bool>(
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
                      child: Row(
                        children: [
                          MyText.titleSmall(
                            "Attenzione",
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                content: Container(
                    constraints: BoxConstraints(minWidth: 100, maxWidth: 500),
                    child: MyText.labelSmall(
                        "Il documento non è stato firmato, vuoi continuare senza firma?",
                        maxLines: 10)),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: MyText.labelSmall("No"),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: MyText.labelSmall("Si"),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            },
          ).then((value) {
            if (value == true) {
              sendRequest();
            } else {
              loading = false;
              update();
            }
          });
        } else {
          sendRequest();
        }
      }
    } else {
      controlloCampiInserimento();
    }
  }

  bool controlloCampiInserimento() {
    var valido = true;
    if (basicValidator.getController("ragioneSociale")?.text == "") {
      basicValidator.addError("ragioneSociale", "Inserisci la ragione sociale");
      valido = false;
    }

    if (tiposocietaSelezionata == null) {
      basicValidator.addError("tipoSoc", "Inserisci il tipo di società");
      valido = false;
    }
    if (basicValidator.getController("indirizzo")?.text == "") {
      basicValidator.addError("indirizzo", "Inserisci l'indirizzo");
      valido = false;
    }
    if (basicValidator.getController("email")?.text == "") {
      basicValidator.addError("email", "Inserisci l'e-mail");
      valido = false;
    }
    if (basicValidator.getController("cap")?.text == "") {
      basicValidator.addError("cap", "Inserisci il cap");
      valido = false;
    }
    if (basicValidator.getController("provincia")?.text == "") {
      basicValidator.addError("provincia", "Inserisci la provincia");
      valido = false;
    }
    if (basicValidator.getController("referente")?.text == "") {
      basicValidator.addError("referente", "Inserisci il referente");
      valido = false;
    }
    if (basicValidator.getController("fax")?.text == "") {
      basicValidator.addError("fax", "Inserisci il cellulare");
      valido = false;
    }
    if (basicValidator.getController("codFisc")?.text == "") {
      basicValidator.addError("codFisc", "Inserisci il codice fiscale");
      valido = false;
    }
    if (basicValidator.getController("partIva")?.text == "") {
      basicValidator.addError("partIva", "Inserisci la partita iva");
      valido = false;
    }
    if (basicValidator.getController("nota1")?.text == "") {
      basicValidator.addError("nota1", "Inserisci il giorno di chiusura");
      valido = false;
    }
    if (nazionalitaSelezionata == null) {
      basicValidator.addError("nazionalita", "Seleziona la nazionalità");
      valido = false;
    }
    if (paeseSelezionato == null) {
      basicValidator.addError("paese", "Seleziona il paese");
      valido = false;
    }
    if (categoriaClienteSelezionata == null) {
      basicValidator.addError("catCli", "Seleziona la categoria cliente");
      valido = false;
    }
    if (comuneSelezionato == null) {
      basicValidator.addError("localita", "Seleziona la località");
      valido = false;
    }
    if (zonaClienteSelezionata == null) {
      basicValidator.addError("zoneCli", "Seleziona la zona");
      valido = false;
    }
    /* if (pagamentoSelezionato == null) {
      basicValidator.addError("pagamenti", "Seleziona il pagamento");
      valido = false;
    }*/
    if (basicValidator.getController("pec")?.text == "") {
      if (basicValidator.getController("codSDI")?.text == "") {
        basicValidator.addError("codSDI", "Inserisci il codice SDI");
        basicValidator.addError("pec", "Inserisci la PEC");
        valido = false;
      }
    } else {
      //basicValidator.addError("codSDI", "");
    }
    if (basicValidator.getController("codSDI")?.text == "") {
      if (basicValidator.getController("pec")?.text == "") {
        basicValidator.addError("codSDI", "Inserisci il codice SDI");
        basicValidator.addError("pec", "Inserisci la PEC");
        valido = false;
      }
    } else {
      //basicValidator.addError("pec", "");
    }

    /*if (basicValidator.getController("codSDI")?.text == "") {
      basicValidator.addError("codSDI", "Inserisci il codice SDI");
      valido = false;
    }*/

    if (destDiversa) {
      if (basicValidator.getController("ragSocDest")?.text == "") {
        basicValidator.addError("ragSocDest", "Inserisci la ragione sociale");
        valido = false;
      }

      if (tiposocietaSelezionataDest == null) {
        basicValidator.addError("tipoSocDest", "Inserisci il tipo di società");
        valido = false;
      }
      if (basicValidator.getController("codFiscDest")?.text == "") {
        basicValidator.addError("codFiscDest", "Inserisci il codice fiscale");
        valido = false;
      }
      if (basicValidator.getController("partIvaDest")?.text == "") {
        basicValidator.addError("partIvaDest", "Inserisci la partita iva");
        valido = false;
      }
      if (nazionalitaSelezionataDest == null) {
        basicValidator.addError("nazionalitaDest", "Seleziona la nazionalità");
        valido = false;
      }
      if (paeseSelezionatoDest == null) {
        basicValidator.addError("paeseDest", "Seleziona il paese");
        valido = false;
      }
      if (basicValidator.getController("indirizzoDest")?.text == "") {
        basicValidator.addError("indirizzoDest", "Inserisci l'indirizzo");
        valido = false;
      }
      if (basicValidator.getController("capDest")?.text == "") {
        basicValidator.addError("capDest", "Inserisci il cap");
        valido = false;
      }
      if (comuneSelezionatoDest == null) {
        basicValidator.addError("localitaDest", "Seleziona la località");
        valido = false;
      }
      if (basicValidator.getController("provinciaDest")?.text == "") {
        basicValidator.addError("provinciaDest", "Inserisci la provincia");
        valido = false;
      }
    }

    basicValidator.validateForm();
    basicValidator.clearErrors();
    if (!valido) {
      loading = false;
      update();
    }
    return valido;
  }

  List<String> splitStringByLength(String str, int length) =>
      [str.substring(0, length), str.substring(length)];

  List<String> documentoEncode(String doc) {
    List<String> str = [];
    for (var c = 0; c < doc.length; c = c + 30000) {
      if (c + 30000 > doc.length) {
        str.add(doc.substring(c, doc.length));
      } else {
        str.add(doc.substring(c, c + 30000));
      }
    }
    return str;
  }

  Future<String> sendRequest() async {
    String giorniChiusura = "Chiuso: ";
    List tipoAttivita = [];
    for (var element in controllerGiorni.selectedOptions) {
      giorniChiusura += (element.value as List)[0]["id"] + " ";
    }
    for (var element in controllerTipoAttivita.selectedOptions) {
      tipoAttivita.add({"num": (element.value as TipoAttivita).numero});
    }
    var dati = {
      "agente": LocalStorage.getLoggedUser()?.codiceAgente,
      "pcdes": basicValidator
          .getController("ragioneSociale")
          .text
          .toString()
          .toUpperCase(),
      "pfnom": basicValidator
          .getController("referente")
          .text
          .toString()
          .toUpperCase(),
      "pcnaz": nazionalitaSelezionata?.codice ?? "",
      "pcpae": paeseSelezionato?.codice ?? "",
      "pcind": basicValidator
          .getController("indirizzo")
          .text
          .toString()
          .toUpperCase(),
      "pccap": comuneSelezionato?.cap ?? "",
      "pcloc": comuneSelezionato?.localita ?? "",
      "pcpro": comuneSelezionato?.provincia ?? "",
      "pctel": basicValidator
          .getController("telefono")
          .text
          .toString()
          .toUpperCase(),
      "pcfax":
          basicValidator.getController("fax").text.toString().toUpperCase(),
      "pcint":
          basicValidator.getController("email").text.toString().toLowerCase(),
      "pcurl": basicValidator
          .getController("internet")
          .text
          .toString()
          .toLowerCase(),
      "pccfi":
          basicValidator.getController("codFisc").text.toString().toUpperCase(),
      "pctpp": isChecked ? "P" : "N",
      "pcnpi": isChecked
          ? ""
          : basicValidator
              .getController("partIva")
              .text
              .toString()
              .toUpperCase(),
      "pcpec":
          basicValidator.getController("pec").text.toString().toLowerCase(),
      "pcsdi":
          basicValidator.getController("codSDI").text.toString().toUpperCase(),
      "pctps": tiposocietaSelezionata?.numero,
      //"pcpag": pagamentoSelezionato?.numero ?? 0,
      "pcnds1": giorniChiusura,
      "pcnds2": orarioChiusura,
      "pccst": categoriaClienteSelezionata?.idC ?? 0,
      "pcona": zonaClienteSelezionata?.idC ?? 0,
      "tipo_attivita": tipoAttivita,
      "note": basicValidator.getController("nota2").text ?? "",
      "privacy":
          documento.isEmpty ? null : documentoEncode(base64.encode(documento)),
      if (isCheckedDest)
        "destinazione": {
          "pcdes": basicValidator
              .getController("ragSocDest")
              .text
              .toString()
              .toUpperCase(),
          "pcnaz": nazionalitaSelezionataDest?.codice ?? "",
          "pcpae": paeseSelezionatoDest?.codice ?? "",
          "pcind": basicValidator
              .getController("indirizzoDest")
              .text
              .toString()
              .toUpperCase(),
          "pccap": comuneSelezionatoDest?.cap ?? "",
          "pcloc": comuneSelezionatoDest?.localita ?? "",
          "pcpro": comuneSelezionatoDest?.provincia ?? "",
          "pccfi": basicValidator
              .getController("codFiscDest")
              .text
              .toString()
              .toUpperCase(),
          "pctpp": isCheckedDest ? "P" : "N",
          "pcnpi": isCheckedDest
              ? ""
              : basicValidator
                  .getController("partIvaDest")
                  .text
                  .toString()
                  .toUpperCase(),
          "pctps": tiposocietaSelezionataDest?.numero,
        }
    };
    print(dati);
    Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrcli", etichettaCollage: "CLIENTE_NUOVO", dati: dati);

    if (res.code == 200) {
      var a = res.result as List<dynamic>;
      if (res.error != "") {
        if (a.isEmpty) {
          showErrorMessage(context, "Cliente non inserito", res.error);
        } else {
          showAlertMessage(context, "Cliente inserito", res.error);
        }
        loading = false;
        update();
        return res.error;
      } else {
        showSuccessMessage(context, "Cliente inserito", res.error);
        pulisciCampi();
        loading = false;
        update();
        return jsonEncode(a);
      }
    } else {
      loading = false;
      update();
      return "";
    }
  }

  void pulisciCampi() {
    basicValidator.resetForm();
    basicValidator.getController("ragioneSociale").text = "";
    basicValidator.getController("indirizzo").text = "";
    basicValidator.getController("email").text = "";
    basicValidator.getController("cap").text = "";
    basicValidator.getController("provincia").text = "";
    basicValidator.getController("telefono").text = "";
    basicValidator.getController("fax").text = "";
    basicValidator.getController("codFisc").text = "";
    basicValidator.getController("partIva").text = "";
    basicValidator.getController("referente").text = "";
    basicValidator.getController("internet").text = "";
    basicValidator.getController("nota2").text = "";
    nazionalitaSelezionata =
        nazionalita.where((element) => element.codice == "I").first;
    paeseSelezionato = paesi.where((element) => element.sigla == "IT").first;
    basicValidator.getController("paese").text = paeseSelezionato?.descrizione;
    basicValidator.getController("paese").text = paeseSelezionato?.descrizione;
    categoriaClienteSelezionata = null;
    comuneSelezionato = null;
    basicValidator.getController("localita").text = "";
    zonaClienteSelezionata = null;
    tiposocietaSelezionata = null;
    basicValidator.getController("pec").text = "";
    basicValidator.getController("codSDI").text = "";
    //tipoAttivita = [];
    controllerTipoAttivita.clearAllSelection();
    giorniSelezionati = [];
    controllerGiorni.clearAllSelection();
    //CAMPI DESTINAZIONE
    basicValidator.getController("ragSocDest").text = "";
    tiposocietaSelezionataDest = null;
    basicValidator.getController("codFiscDest").text = "";
    basicValidator.getController("partIvaDest").text = "";
    nazionalitaSelezionataDest =
        nazionalita.where((element) => element.codice == "I").first;
    paeseSelezionatoDest =
        paesi.where((element) => element.sigla == "IT").toList().first;
    basicValidator.getController("paeseDest").text =
        paeseSelezionatoDest?.descrizione;
    basicValidator.getController("indirizzoDest").text = "";
    basicValidator.getController("capDest").text = "";
    comuneSelezionatoDest = null;
    basicValidator.getController("localitaDest").text = "";
    basicValidator.getController("provinciaDest").text = "";
    update();
  }
}
