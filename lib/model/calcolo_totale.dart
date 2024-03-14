class CalcoloTotale {
  List<RigaDettaglio>? rigaDettaglio;
  double totaleMerceLordo = 0;
  double totaleDaPagare = 0;
  double scontoAbbuono = 0;
  double scontoPagamento = 0;
  double totaleMerceNetto = 0;
  double totaleIva = 0;
  double totaleDocumento = 0;

  CalcoloTotale(
      this.rigaDettaglio,
      this.totaleMerceLordo,
      this.totaleDaPagare,
      this.scontoAbbuono,
      this.scontoPagamento,
      this.totaleMerceNetto,
      this.totaleIva,
      this.totaleDocumento);

  azzeraRighe() {
    rigaDettaglio = [];
    totaleMerceLordo = 0;
    totaleDaPagare = 0;
    scontoAbbuono = 0;
    scontoPagamento = 0;
    totaleMerceNetto = 0;
    totaleIva = 0;
    totaleDocumento = 0;
  }

  CalcoloTotale.fromJson(Map<String, dynamic> json) {
    if (json['riga_dettaglio'] != null) {
      rigaDettaglio = <RigaDettaglio>[];
      json['riga_dettaglio'].forEach((v) {
        rigaDettaglio!.add(new RigaDettaglio.fromJson(v));
      });
    }
    totaleMerceLordo = json['TotaleMerceLordo'];
    totaleDaPagare = json['TotaleDaPagare'];
    scontoAbbuono = json['ScontoAbbuono'];
    scontoPagamento = json['ScontoPagamento'];
    totaleMerceNetto = json['TotaleMerceNetto'];
    totaleIva = json['TotaleIva'];
    totaleDocumento = json['TotaleDocumento'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (rigaDettaglio != null) {
      data['riga_dettaglio'] = rigaDettaglio!.map((v) => v.toJson()).toList();
    }
    data['TotaleMerceLordo'] = totaleMerceLordo;
    data['TotaleDaPagare'] = totaleDaPagare;
    data['ScontoAbbuono'] = scontoAbbuono;
    data['ScontoPagamento'] = scontoPagamento;
    data['TotaleMerceNetto'] = totaleMerceNetto;
    data['TotaleIva'] = totaleIva;
    data['TotaleDocumento'] = totaleDocumento;
    return data;
  }
}

class RigaDettaglio {
  int? rigo;
  String? articolo;
  double? importo;

  RigaDettaglio({this.rigo, this.articolo, this.importo});

  RigaDettaglio.fromJson(Map<String, dynamic> json) {
    rigo = json['Rigo'];
    articolo = json['Articolo'];
    importo = json['Importo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Rigo'] = rigo;
    data['Articolo'] = articolo;
    data['Importo'] = importo;
    return data;
  }
}

class DocumentoCreato {
  String? documento;
  int? serie;
  int? numero;
  String? data;

  DocumentoCreato({this.documento, this.serie, this.numero, this.data});

  DocumentoCreato.fromJson(Map<String, dynamic> json) {
    documento = json['Documento'];
    serie = json['Serie'];
    numero = json['Numero'];
    data = json['Data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Documento'] = documento;
    data['Serie'] = serie;
    data['Numero'] = numero;
    data['Data'] = data;
    return data;
  }
}
