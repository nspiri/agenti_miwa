class Storico {
  int? colli;
  String? data;
  double? prezzo;
  String? documento;
  String? codArt;
  int? serie;
  String? iva;
  int? numero;
  String? um;
  String? desc;
  double? qta;
  String? sconto;
  double? importo;

  Storico(
      {this.colli,
      this.data,
      this.prezzo,
      this.documento,
      this.codArt,
      this.serie,
      this.iva,
      this.numero,
      this.um,
      this.desc,
      this.qta,
      this.sconto,
      this.importo});

  Storico.fromJson(Map<String, dynamic> json) {
    colli = json['mmcol'];
    data = json['mmdat'];
    prezzo = json['mmprz'];
    documento = json['mmsig'];
    codArt = json['mmart'];
    serie = json['mmser'];
    iva = json['mmali'];
    numero = json['mmnum'];
    um = json['mmumi'];
    desc = json['mmdsc'];
    qta = json['mmqta'];
    sconto = json['mmsco'];
    importo = json['mmruv'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mmcol'] = colli;
    data['mmdat'] = data;
    data['mmprz'] = prezzo;
    data['mmsig'] = documento;
    data['mmart'] = codArt;
    data['mmser'] = serie;
    data['mmali'] = iva;
    data['mmnum'] = numero;
    data['mmumi'] = um;
    data['mmdsc'] = desc;
    data['mmqta'] = qta;
    data['mmsco'] = sconto;
    data['mmruv'] = importo;
    return data;
  }
}
