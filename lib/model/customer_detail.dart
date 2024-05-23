import 'dart:convert';

import 'package:foody/helpers/services/json_decoder.dart';
import 'package:foody/helpers/storage/local_storage.dart';
import 'package:foody/helpers/utils/do_http_request.dart';
import 'package:foody/model/articolo.dart';
import 'package:foody/model/identifier_model.dart';
import 'package:foody/model/request.dart';

class CustomerDetail extends IdentifierModel {
  String? codiceCliente;
  String? ragioneSociale;
  String? nazionalita;
  String? siglaNazione;
  String? indirizzo;
  String? cap;
  String? localita;
  String? provincia;
  String? telefono;
  String? fax;
  String? email;
  String? sitoInternet;
  String? codiceFiscale;
  String? partitaIva;
  String? nota1;
  String? nota2;
  String? valoreOrdini;
  String? fattAnnPrec;
  String? fattAnnCorr;
  String? dataUltimaConsegna;
  String? docUltimaConsegna;
  String? codicePagamento;
  String? descPagamento;
  String? valFido;
  String? rischio;
  String? codMessFuoriFido;
  String? descMessFuoriFido;
  int? codCatStat;
  String descCatStat;
  String? codZona;
  String? descZona;
  String? codCliFattA;
  String? ragSocFattA;
  String? codListino;
  String? descListino;
  String? assoggIva;
  String? codCatProv;
  String? descCatProv;
  String? codCatSconti;
  String? descCatSconti;
  String? scontoIncondizionato;
  List<TipoAttivita>? tipoAttivita;
  String? tipoSconto;
  double? sconto;
  List<Attrezzatura>? attrezzature;
  List<GiorniConsegne>? giorniConsegne;
  bool? attivo = true;

  CustomerDetail(
      super.id,
      this.codiceCliente,
      this.ragioneSociale,
      this.nazionalita,
      this.siglaNazione,
      this.indirizzo,
      this.cap,
      this.localita,
      this.provincia,
      this.telefono,
      this.fax,
      this.email,
      this.sitoInternet,
      this.codiceFiscale,
      this.partitaIva,
      this.nota1,
      this.nota2,
      this.valoreOrdini,
      this.fattAnnPrec,
      this.fattAnnCorr,
      this.dataUltimaConsegna,
      this.docUltimaConsegna,
      this.codicePagamento,
      this.descPagamento,
      this.valFido,
      this.rischio,
      this.codMessFuoriFido,
      this.descMessFuoriFido,
      this.codCatStat,
      this.descCatStat,
      this.codZona,
      this.descZona,
      this.codCliFattA,
      this.ragSocFattA,
      this.codListino,
      this.descListino,
      this.assoggIva,
      this.codCatProv,
      this.descCatProv,
      this.codCatSconti,
      this.descCatSconti,
      this.scontoIncondizionato,
      this.tipoAttivita,
      this.tipoSconto,
      this.sconto,
      this.attrezzature,
      this.giorniConsegne,
      this.attivo);

  static CustomerDetail fromJSON(Map<String, dynamic> json) {
    JSONDecoder decoder = JSONDecoder(json);

    String codiceCliente = decoder.getString('pccod');
    String? ragioneSociale = decoder.getString('pcdes');
    String? nazionalita = decoder.getString('pcnaz');
    String? siglaNazione = decoder.getString('pcpae');
    String? indirizzo = decoder.getString('pcind');
    String? cap = decoder.getString('pccap');
    String? localita = decoder.getString('pcloc');
    String? provincia = decoder.getString('pcpro');
    String? telefono = decoder.getString('pctel');
    String? fax = decoder.getString('pcfax');
    String? email = decoder.getString('pcint');
    String? sitoInternet = decoder.getString('pcurl');
    String? codiceFiscale = decoder.getString('pccfi');
    String? partitaIva = decoder.getString('pcnpi');
    String? nota1 = decoder.getString('pcnds1');
    String? nota2 = decoder.getString('pcnds2');
    String? valoreOrdini = decoder.getString('pcvbl');
    String? fattAnnPrec = decoder.getString('pctft_prec');
    String? fattAnnCorr = decoder.getString('pctft1_corr');
    String? dataUltimaConsegna = decoder.getString('pcduc');
    String? docUltimaConsegna = decoder.getString('pcnud');
    String? codicePagamento = decoder.getString('pcpag');
    String? descPagamento = decoder.getString('pcpag_desc');
    String? valFido = decoder.getString('pcfid');
    String? rischio = decoder.getString('rischio');
    String? codMessFuoriFido = decoder.getString('pcfms');
    String? descMessFuoriFido = decoder.getString('pcfms_desc');
    int? codCatStat = decoder.getInt('pccst');
    String? descCatStat = decoder.getString('pccst_desc');
    String? codZona = decoder.getString('pcona');
    String? descZona = decoder.getString('pcona_desc');
    String? codCliFattA = decoder.getString('pcfta');
    String? ragSocFattA = decoder.getString('pcfta_desc');
    String? codListino = decoder.getString('pclis');
    String? descListino = decoder.getString('pclis_desc');
    String? assoggIva = decoder.getString('pcasi');
    String? codCatProv = decoder.getString('pccpr');
    String? descCatProv = decoder.getString('pccpr_desc');
    String? codCatSconti = decoder.getString('pccsc');
    String? descCatSconti = decoder.getString('pccsc_desc');
    String? scontoIncondizionato = decoder.getString('pcsco');
    String? tipoSconto = decoder.getString('pcpag_cptis');
    double? sconto = decoder.getDouble('pcpag_cpsco');
    List<TipoAttivita>? tipoAttivita;
    if (json['tipo_attivita'] != null) {
      tipoAttivita = <TipoAttivita>[];
      json['tipo_attivita'].forEach((v) {
        tipoAttivita?.add(new TipoAttivita.fromJson(v));
      });
    }
    List<Attrezzatura>? attrezzature;
    if (json['attrezzature'] != null) {
      attrezzature = <Attrezzatura>[];
      json['attrezzature'].forEach((v) {
        attrezzature?.add(new Attrezzatura.fromJson(v));
      });
    }
    bool attivo = true;
    if (json['pccpr'] == 0) attivo = false;

    List<GiorniConsegne>? giorniConsegne;
    if (json['giorni_consegne'] != null) {
      giorniConsegne = <GiorniConsegne>[];
      json['giorni_consegne'].forEach((v) {
        giorniConsegne?.add(new GiorniConsegne.fromJson(v));
      });
    }

    return CustomerDetail(
        decoder.getId,
        codiceCliente,
        ragioneSociale,
        nazionalita,
        siglaNazione,
        indirizzo,
        cap,
        localita,
        provincia,
        telefono,
        fax,
        email,
        sitoInternet,
        codiceFiscale,
        partitaIva,
        nota1,
        nota2,
        valoreOrdini,
        fattAnnPrec,
        fattAnnCorr,
        dataUltimaConsegna,
        docUltimaConsegna,
        codicePagamento,
        descPagamento,
        valFido,
        rischio,
        codMessFuoriFido,
        descMessFuoriFido,
        codCatStat,
        descCatStat,
        codZona,
        descZona,
        codCliFattA,
        ragSocFattA,
        codListino,
        descListino,
        assoggIva,
        codCatProv,
        descCatProv,
        codCatSconti,
        descCatSconti,
        scontoIncondizionato,
        tipoAttivita,
        tipoSconto,
        sconto,
        attrezzature,
        giorniConsegne,
        attivo);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pcpro'] = this.provincia;
    data['pccfi'] = this.codiceFiscale;
    data['pcnaz'] = this.nazionalita;
    //data['pctps'] = this.tipo;
    data['pccod'] = this.codiceCliente;
    data['pcdes'] = this.ragioneSociale;
    data['pcnds1'] = this.nota1;
    data['pctft_prec'] = this.fattAnnPrec;
    data['pcpae'] = this.siglaNazione;
    //data['pcpec'] = this.pec;
    data['pcint'] = this.email;
    data['pcnud'] = this.docUltimaConsegna;
    data['pcloc'] = this.localita;
    data['pcind'] = this.indirizzo;
    data['pctpp'] = this.tipoAttivita;
    data['pctel'] = this.telefono;
    data['pccap'] = this.cap;
    data['pcfax'] = this.fax;
    data['pcurl'] = this.sitoInternet;
    if (this.giorniConsegne != null) {
      data['giorni_consegne'] =
          this.giorniConsegne!.map((v) => v.toJson()).toList();
    }
    data['pcnpi'] = this.partitaIva;
    data['pctft1_corr'] = this.fattAnnCorr;
    //data['pcsdi'] = this.codSdi;
    data['pccpr'] = this.codCatProv;
    data['pclis_desc'] = this.descListino;
    data['pcnds2'] = this.nota2;
    data['pcpag_cptis'] = this.tipoSconto;
    data['pcvbl'] = this.valoreOrdini;
    data['pcduc'] = this.dataUltimaConsegna;
    data['pcona'] = this.codZona;
    data['pcpag'] = this.codicePagamento;
    data['pcpag_desc'] = this.descPagamento;
    data['pccsc_desc'] = this.descCatSconti;
    data['pcpag_cpsco'] = this.sconto;
    data['pcfid'] = this.valFido;
    data['pcfms'] = this.codMessFuoriFido;
    data['rischio'] = this.rischio;
    data['pcfms_desc'] = this.descMessFuoriFido;
    if (this.attrezzature != null) {
      data['attrezzature'] = this.attrezzature!.map((v) => v.toJson()).toList();
    }
    data['pcona_desc'] = this.descZona;
    data['pccst'] = this.codCatStat;
    if (this.tipoAttivita != null) {
      data['tipo_attivita'] =
          this.tipoAttivita!.map((v) => v.toJson()).toList();
    }
    data['pccst_desc'] = this.descCatStat;
    data['pclis'] = this.codListino;
    data['pcfta'] = this.codCliFattA;
    data['pcfta_desc'] = this.ragSocFattA;
    data['pcasi'] = this.assoggIva;
    data['pccpr_desc'] = this.descCatProv;
    data['pccsc'] = this.codCatSconti;
    data['pcsco'] = this.scontoIncondizionato;
    return data;
  }

  static CustomerDetail listFromJSON(dynamic object) {
    return CustomerDetail.fromJSON(object);
  }
}

class TipoAttivita {
  int? num;
  String? des;

  TipoAttivita({this.num, this.des});

  TipoAttivita.fromJson(Map<String, dynamic> json) {
    num = json['num'];
    des = json['des'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['num'] = num;
    data['des'] = des;
    return data;
  }
}

class Attrezzatura {
  String? dataInizio;
  String? attrezzatura;
  String? natura;
  double? quantitaMin;
  double? valPeriodo;
  double? qtaPeriodo;
  int? tempoGg;
  String? codice;
  String? descrizione;

  Attrezzatura(
      this.dataInizio,
      this.attrezzatura,
      this.natura,
      this.quantitaMin,
      this.tempoGg,
      this.valPeriodo,
      this.qtaPeriodo,
      this.codice,
      this.descrizione);

  Attrezzatura.fromJson(Map<String, dynamic> json) {
    dataInizio = json['data_inizio'];
    attrezzatura = json['attrezzatura'];
    natura = json['natura'];
    quantitaMin = json['quantita_min'];
    tempoGg = json['tempo_gg'];
    valPeriodo = json['val_periodo'];
    qtaPeriodo = json['qta_periodo'];
    codice = json['pccod'];
    descrizione = json['pcdes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data_inizio'] = dataInizio;
    data['attrezzatura'] = attrezzatura;
    data['natura'] = natura;
    data['quantita_min'] = quantitaMin;
    data['tempo_gg'] = tempoGg;
    data['val_periodo'] = valPeriodo;
    data['qta_periodo'] = qtaPeriodo;
    data['pccod'] = codice;
    data['pcdes'] = descrizione;
    return data;
  }

  static Attrezzatura fromJSON(Map<String, dynamic> json) {
    JSONDecoder decoder = JSONDecoder(json);

    String dataInizio = decoder.getString('data_inizio');
    String attrezzatura = decoder.getString('attrezzatura');
    String natura = decoder.getString('natura');
    double quantitaMin = decoder.getDouble('quantita_min');
    int tempoGg = decoder.getInt('tempo_gg');
    double valPeriodo = decoder.getDouble('val_periodo');
    double qtaPeriodo = decoder.getDouble('qta_periodo');
    String codice = decoder.getString('pccod');
    String descrizione = decoder.getString('pcdes');

    return Attrezzatura(dataInizio, attrezzatura, natura, quantitaMin, tempoGg,
        valPeriodo, qtaPeriodo, codice, descrizione);
  }

  static List<Attrezzatura> listFromJSON(List<dynamic> list) {
    return list.map((e) => Attrezzatura.fromJSON(e)).toList();
  }

  static List<Attrezzatura>? _dummyList;

  static Future<List<Attrezzatura>> get dummyList async {
    dynamic data = jsonDecode(await getData());
    _dummyList = listFromJSON(data);

    return _dummyList!;
  }

  static Future<String> getData() async {
    Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrcli",
        etichettaCollage: "ATTREZZATURE",
        dati: {
          "agente": LocalStorage.getLoggedUser()?.codiceAgente,
          "no_condizione": false
        });

    if (res.code == 200) {
      var a = res.result as List<dynamic>;
      if (a.isEmpty) {
        return "";
      }
      return json.encode(a);
    } else {
      return "";
    }
    //return await rootBundle.loadString('assets/data/clienti.json');
  }
}

class GiorniConsegne {
  int? codiceGiorno;
  int? codiceGiro;
  String? giorno;
  String? giro;
  String? chiusuraOrdini;

  GiorniConsegne(
      {this.codiceGiorno,
      this.codiceGiro,
      this.giorno,
      this.giro,
      this.chiusuraOrdini});

  GiorniConsegne.fromJson(Map<String, dynamic> json) {
    codiceGiorno = json['CodiceGiorno'];
    codiceGiro = json['CodiceGiro'];
    giorno = json['Giorno'];
    giro = json['Giro'];
    chiusuraOrdini = json['ChiusuraOrdini'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CodiceGiorno'] = this.codiceGiorno;
    data['CodiceGiro'] = this.codiceGiro;
    data['Giorno'] = this.giorno;
    data['Giro'] = this.giro;
    data['ChiusuraOrdini'] = this.chiusuraOrdini;
    return data;
  }
}

class PassaggioDatiOrdine {
  CustomerDetail? cliente;
  List<Articolo>? carrello = [];

  PassaggioDatiOrdine({this.cliente, this.carrello});
}
