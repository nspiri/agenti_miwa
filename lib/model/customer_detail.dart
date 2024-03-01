import 'package:foody/helpers/services/json_decoder.dart';
import 'package:foody/model/identifier_model.dart';

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
  String? codCatStat;
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
      this.sconto);

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
    String? codCatStat = decoder.getString('pccst');
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
        sconto);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
