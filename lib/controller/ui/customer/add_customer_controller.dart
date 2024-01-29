import 'dart:convert';
import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';
import 'package:foody/helpers/storage/local_storage.dart';
import 'package:foody/helpers/utils/do_http_request.dart';
import 'package:foody/helpers/utils/show_message_dialogs.dart';
import 'package:foody/helpers/widgets/my_form_validator.dart';
import 'package:foody/model/customer_category.dart';
import 'package:foody/model/customers_fa.dart';
import 'package:foody/model/nazionalita.dart';
import 'package:foody/model/pagamenti.dart';
import 'package:foody/model/request.dart';
import 'package:foody/model/tipo_attivita.dart';
import 'package:foody/model/tipo_soc.dart';
import 'package:foody/model/zone_clienti.dart';
import 'package:foody/views/my_controller.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:time_range/time_range.dart';

class AddCustomerController extends MyController {
  BuildContext context;
  bool loading = false,
      isChecked = false,
      destDiversa = false,
      isCheckedDest = false;
  List<Nazionalita> nazionalita = [];
  Nazionalita? nazionalitaSelezionata;
  List<Paesi> paesi = [];
  Paesi? paeseSelezionato;
  List<Comuni> comuni = [];
  Comuni? comuneSelezionato;
  List<CustomerCategory> categorieClienti = [];
  CustomerCategory? categoriaClienteSelezionata;
  List<ZoneClienti> zoneClienti = [];
  ZoneClienti? zonaClienteSelezionata;
  List<CustomersFA> clientiFA = [];
  List<Pagamenti> pagamenti = [];
  Pagamenti? pagamentoSelezionato;
  List<TipoSocieta> tipoSocieta = [];
  TipoSocieta? tiposocietaSelezionata;

  //Campi destinazione
  TipoSocieta? tiposocietaSelezionataDest;
  Nazionalita? nazionalitaSelezionataDest;
  Paesi? paeseSelezionatoDest;
  Comuni? comuneSelezionatoDest;

  String orarioChiusura = "";

  List<ValueItem<TipoAttivita>> tipoAttivita = [];

  final TextEditingController nazionalitaTextController =
      TextEditingController();
  final TextEditingController paeseTextController = TextEditingController();
  final TextEditingController catCliTextController = TextEditingController();
  final TextEditingController comuneTextController = TextEditingController();
  final TextEditingController zoneCliTextController = TextEditingController();
  final TextEditingController pagamentiTextController = TextEditingController();
  final TextEditingController tipoSocTextController = TextEditingController();

  //Campi destinazione
  final TextEditingController tipoSocDestTextController =
      TextEditingController();
  final TextEditingController nazionalitaDestTextController =
      TextEditingController();
  final TextEditingController paeseDestTextController = TextEditingController();
  final TextEditingController comuneDestTextController =
      TextEditingController();

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

  AddCustomerController({required this.context});

  @override
  void onInit() {
    inizializzaCampi();
    Nazionalita.dummyList.then((value) {
      nazionalita = value;
      nazionalita.sort((a, b) =>
          a.descrizione!.toLowerCase().compareTo(b.descrizione!.toLowerCase()));
      update();
    });
    Paesi.dummyList.then((value) {
      paesi = value;
      paesi.sort((a, b) =>
          a.descrizione!.toLowerCase().compareTo(b.descrizione!.toLowerCase()));
      update();
    });
    Comuni.dummyList.then((value) {
      comuni = value;
      comuni.sort((a, b) =>
          a.localita!.toLowerCase().compareTo(b.localita!.toLowerCase()));
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
    Pagamenti.dummyList.then((value) {
      pagamenti = value;
      pagamenti.sort((a, b) =>
          a.descrizione!.toLowerCase().compareTo(b.descrizione!.toLowerCase()));
      update();
    });
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
        controller: SuggestionsBoxController());
    basicValidator.addField('catCli',
        required: true,
        label: "",
        validators: [],
        controller: SuggestionsBoxController());
    basicValidator.addField('localita',
        required: true,
        label: "",
        validators: [],
        controller: SuggestionsBoxController());
    basicValidator.addField('zoneCli',
        required: true,
        label: "",
        validators: [],
        controller: SuggestionsBoxController());
    basicValidator.addField('pagamenti',
        required: true,
        label: "",
        validators: [],
        controller: SuggestionsBoxController());
    basicValidator.addField('tipoSoc',
        required: true,
        label: "",
        validators: [],
        controller: SuggestionsBoxController());
    basicValidator.addField('pec',
        required: true,
        label: "",
        validators: [],
        controller: TextEditingController());
    basicValidator.addField('codSDI',
        required: true,
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
        controller: SuggestionsBoxController());
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
        controller: SuggestionsBoxController());
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

  List<Pagamenti> getPagamenti(String query) {
    List<Pagamenti> matches = [];
    matches.addAll(pagamenti);

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
        sendRequest();
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
    if (basicValidator.getController("fax")?.text == "") {
      basicValidator.addError("fax", "Inserisci il fax");
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
    if (basicValidator.getController("nota2")?.text == "") {
      basicValidator.addError("nota2", "Inserisci le note");
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
    if (pagamentoSelezionato == null) {
      basicValidator.addError("pagamenti", "Seleziona il pagamento");
      valido = false;
    }
    if (basicValidator.getController("pec")?.text == "") {
      basicValidator.addError("pec", "Inserisci la PEC");
      valido = false;
    }
    if (basicValidator.getController("codSDI")?.text == "") {
      basicValidator.addError("codSDI", "Inserisci il codice SDI");
      valido = false;
    }

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
      "pcdes": basicValidator.getController("ragioneSociale").text ?? "",
      "pcnaz": nazionalitaSelezionata?.codice ?? "",
      "pcpae": paeseSelezionato?.codice ?? "",
      "pcind": basicValidator.getController("indirizzo").text ?? "",
      "pccap": comuneSelezionato?.cap ?? "",
      "pcloc": comuneSelezionato?.localita ?? "",
      "pcpro": comuneSelezionato?.provincia ?? "",
      "pctel": basicValidator.getController("telefono").text ?? "",
      "pcfax": basicValidator.getController("fax").text ?? "",
      "pcint": basicValidator.getController("email").text ?? "",
      "pcurl": basicValidator.getController("internet").text ?? "",
      "pccfi": basicValidator.getController("codFisc").text ?? "",
      "pctpp": isChecked ? "P" : "N",
      "pcnpi":
          isChecked ? "" : basicValidator.getController("partIva").text ?? "",
      "pcpec": basicValidator.getController("pec").text ?? "",
      "pcsdi": basicValidator.getController("codSDI").text ?? "",
      "pctps": tiposocietaSelezionata?.numero,
      "pcpag": pagamentoSelezionato?.numero ?? 0,
      "pcnds1": giorniChiusura,
      "pcnds2": orarioChiusura,
      "pccst": categoriaClienteSelezionata?.idC ?? 0,
      "pcona": zonaClienteSelezionata?.idC ?? 0,
      "tipo_attivita": tipoAttivita,
      "note": basicValidator.getController("nota2").text ?? "",
      "destinazione": {
        "pcdes": basicValidator.getController("ragSocDest").text ?? "",
        "pcnaz": nazionalitaSelezionataDest?.codice ?? "",
        "pcpae": paeseSelezionatoDest?.codice ?? "",
        "pcind": basicValidator.getController("indirizzoDest").text ?? "",
        "pccap": comuneSelezionatoDest?.cap ?? "",
        "pcloc": comuneSelezionatoDest?.localita ?? "",
        "pcpro": comuneSelezionatoDest?.provincia ?? "",
        "pccfi": basicValidator.getController("codFiscDest").text ?? "",
        "pctpp": isCheckedDest ? "P" : "N",
        "pcnpi": isCheckedDest
            ? ""
            : basicValidator.getController("partIvaDest").text ?? "",
        "pctps": tiposocietaSelezionataDest?.numero,
      }
    };
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
    basicValidator.getController("ragioneSociale").text = "";
    basicValidator.getController("indirizzo").text = "";
    basicValidator.getController("email").text = "";
    basicValidator.getController("cap").text = "";
    basicValidator.getController("provincia").text = "";
    basicValidator.getController("telefono").text = "";
    basicValidator.getController("fax").text = "";
    basicValidator.getController("codFisc").text = "";
    basicValidator.getController("partIva").text = "";
    basicValidator.getController("internet").text = "";
    basicValidator.getController("nota2").text = "";
    nazionalitaSelezionata = null;
    nazionalitaTextController.text = "";
    paeseSelezionato = null;
    paeseTextController.text = "";
    categoriaClienteSelezionata = null;
    catCliTextController.text = "";
    comuneSelezionato = null;
    comuneTextController.text = "";
    zonaClienteSelezionata = null;
    zoneCliTextController.text = "";
    pagamentoSelezionato = null;
    pagamentiTextController.text = "";
    tiposocietaSelezionata = null;
    tipoSocTextController.text = "";
    basicValidator.getController("pec").text = "";
    basicValidator.getController("codSDI").text = "";
    //CAMPI DESTINAZIONE
    basicValidator.getController("ragSocDest").text = "";
    tiposocietaSelezionataDest = null;
    tipoSocDestTextController.text = "";
    basicValidator.getController("codFiscDest").text = "";
    basicValidator.getController("partIvaDest").text = "";
    nazionalitaSelezionataDest = null;
    nazionalitaDestTextController.text = "";
    paeseSelezionatoDest = null;
    paeseDestTextController.text = "";
    basicValidator.getController("indirizzoDest").text = "";
    basicValidator.getController("capDest").text = "";
    comuneSelezionatoDest = null;
    comuneDestTextController.text = "";
    basicValidator.getController("provinciaDest").text = "";
  }
}
