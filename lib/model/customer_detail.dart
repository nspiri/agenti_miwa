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
      this.scontoIncondizionato);

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
        scontoIncondizionato);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    //data['pccod'] = codice;

    return data;
  }

  static CustomerDetail listFromJSON(dynamic object) {
    return CustomerDetail.fromJSON(object);
  }
}





/*class CustomersList extends IdentifierModel {
  final String customerName, email, phone, status;
  final int order;
  final double totalOrders;
  final DateTime customerSince;

  CustomersList(super.id, this.customerName, this.email, this.phone,
      this.status, this.order, this.totalOrders, this.customerSince);

  static CustomersList fromJSON(Map<String, dynamic> json) {
    JSONDecoder decoder = JSONDecoder(json);

    String customerName = decoder.getString('customer_name');
    String email = decoder.getString('email');
    String phone = decoder.getString('phone');
    String status = decoder.getString('status');
    int order = decoder.getInt('order');
    double totalOrders = decoder.getDouble('total_orders');
    DateTime customerSince = decoder.getDateTime('customer_since');

    return CustomersList(decoder.getId, customerName, email, phone, status,
        order, totalOrders, customerSince);
  }

  static List<CustomersList> listFromJSON(List<dynamic> list) {
    return list.map((e) => CustomersList.fromJSON(e)).toList();
  }

  static List<CustomersList>? _dummyList;

  static Future<List<CustomersList>> get dummyList async {
    if (_dummyList == null) {
      dynamic data = json.decode(await getData());
      _dummyList = listFromJSON(data);
    }

    return _dummyList!.sublist(0, 50);
  }

  static Future<String> getData() async {
    return await rootBundle.loadString('assets/data/customers_list.json');
  }
}
*/