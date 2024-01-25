import 'dart:convert';

import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';
import 'package:foody/helpers/storage/local_storage.dart';
import 'package:foody/helpers/utils/do_http_request.dart';
import 'package:foody/helpers/widgets/my_form_validator.dart';
import 'package:foody/helpers/widgets/my_validators.dart';
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

class AddCustomerController extends MyController {
  bool loading = false, isChecked = false;
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
  CustomersFA? clienteFASelezionato;
  List<Pagamenti> pagamenti = [];
  Pagamenti? pagamentoSelezionato;
  List<TipoSocieta> tipoSocieta = [];
  TipoSocieta? tiposocietaSelezionata;

  List<ValueItem<TipoAttivita>> tipoAttivita = [];

  final TextEditingController nazionalitaTextController =
      TextEditingController();
  final TextEditingController paeseTextController = TextEditingController();
  final TextEditingController catCliTextController = TextEditingController();
  final TextEditingController comunetaTextController = TextEditingController();
  final TextEditingController zoneCliTextController = TextEditingController();
  final TextEditingController cliFATextController = TextEditingController();
  final TextEditingController pagamentiTextController = TextEditingController();

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
    CustomersFA.dummyList.then((value) {
      clientiFA = value;
      clientiFA.sort((a, b) =>
          a.descrizione!.toLowerCase().compareTo(b.descrizione!.toLowerCase()));
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
        validators: [MyEmailValidator()],
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
        required: true,
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
        required: true,
        label: "",
        validators: [],
        controller: TextEditingController());
    basicValidator.addField('internet',
        required: true,
        label: "",
        validators: [],
        controller: TextEditingController());
    basicValidator.addField('nota2',
        required: true,
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
    basicValidator.addField('cliFA',
        required: true,
        label: "",
        validators: [],
        controller: SuggestionsBoxController());
    basicValidator.addField('pagamenti',
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
    loading = false;
    update();
  }

  bool controlloCampiInserimento() {
    var valido = true;
    if (basicValidator.getController("ragioneSociale")?.text == "") {
      basicValidator.addError("ragioneSociale", "Inserisci la ragione sociale");
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
    if (basicValidator.getController("telefono")?.text == "") {
      basicValidator.addError("telefono", "Inserisci il telefono");
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
    if (basicValidator.getController("internet")?.text == "") {
      basicValidator.addError("internet", "Inserisci il sito internet");
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
    if (clienteFASelezionato == null) {
      basicValidator.addError("cliFA", "Seleziona il cliente da fatturare");
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

    basicValidator.validateForm();
    basicValidator.clearErrors();
    return valido;
  }

  Future<String> sendRequest() async {
    String giorniChiusura = "";
    List tipoAttivita = [];
    for (var element in controllerGiorni.options) {
      giorniChiusura += (element.value as List)[0]["id"] + " ; ";
    }
    for (var element in controllerTipoAttivita.options) {
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
      //"pctpp": tipoPartitaIvaSelezionata == TipoPartitaIva.N ? "N" : "P",
      "pcnpi": basicValidator.getController("partIva").text ?? "",
      "pcpec": basicValidator.getController("pec").text ?? "",
      "pcsdi": basicValidator.getController("codSDI").text ?? "",
      /*  "pctps": tipoSocietaSelezionata == TipoSocieta.N
          ? "N"
          : tipoSocietaSelezionata == TipoSocieta.C
              ? "C"
              : "P",*/
      "pcpag": pagamentoSelezionato?.numero == 0,
      "pcnds1": giorniChiusura,
      "pcnds2": basicValidator.getController("nota2").text ?? "",
      "pccst": categoriaClienteSelezionata?.idC ?? 0,
      "pcona": zonaClienteSelezionata?.idC ?? 0,
      "pcfta": clienteFASelezionato?.codice ?? "",
      "tipo_attivita": tipoAttivita
    };
    Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrcli", etichettaCollage: "CLIENTE_NUOVO", dati: dati);

    if (res.code == 200) {
      var a = res.result as List<dynamic>;
      if (a.isEmpty) {
        return "";
      }
      return jsonEncode(a);
    } else {
      return "";
    }
  }
}
