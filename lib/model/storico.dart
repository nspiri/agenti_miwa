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

  static List<Storico> listFromJSON(List<dynamic> list) {
    return list.map((e) => Storico.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> d = <String, dynamic>{};
    d['mmcol'] = colli;
    d['mmdat'] = data;
    d['mmprz'] = prezzo;
    d['mmsig'] = documento;
    d['mmart'] = codArt;
    d['mmser'] = serie;
    d['mmali'] = iva;
    d['mmnum'] = numero;
    d['mmumi'] = um;
    d['mmdsc'] = desc;
    d['mmqta'] = qta;
    d['mmsco'] = sconto;
    d['mmruv'] = importo;
    return d;
  }
}
