class Statistiche {
  double? valore;
  String? categoria;
  String? arcod;
  String? articolo;
  String? pccod;
  String? cliente;
  double? quantita;

  Statistiche(
      {this.valore,
      this.categoria,
      this.arcod,
      this.articolo,
      this.pccod,
      this.cliente,
      this.quantita});

  Statistiche.fromJson(Map<String, dynamic> json) {
    valore = json['valore'];
    categoria = json['categoria'];
    arcod = json['arcod'];
    articolo = json['articolo'];
    pccod = json['pccod'];
    cliente = json['cliente'];
    quantita = json['quantita'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['valore'] = valore;
    data['categoria'] = categoria;
    data['arcod'] = arcod;
    data['articolo'] = articolo;
    data['pccod'] = pccod;
    data['cliente'] = cliente;
    data['quantita'] = quantita;
    return data;
  }
}
