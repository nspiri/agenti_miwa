class ScadenziarioCliente {
  String? documento;
  String? ragioneSociale;
  int? serie;
  int? numero;
  String? dataScadenza;
  String? data;
  String? tipoPagamento;
  String? codCliente;
  double? importo;
  bool selected = false;

  ScadenziarioCliente(
      {this.documento,
      this.ragioneSociale,
      this.serie,
      this.numero,
      this.dataScadenza,
      this.data,
      this.tipoPagamento,
      this.codCliente,
      this.importo});

  ScadenziarioCliente.fromJson(Map<String, dynamic> json) {
    documento = json['pscau'];
    ragioneSociale = json['pcdes'];
    serie = json['psser'];
    numero = json['psnum'];
    dataScadenza = json['pspdt'];
    data = json['psdat'];
    tipoPagamento = json['ctdes'];
    codCliente = json['pscto'];
    importo = json['pspim'];
  }

  static List<ScadenziarioCliente> listFromJSON(List<dynamic> list) {
    return list.map((e) => ScadenziarioCliente.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> d = <String, dynamic>{};
    d['pscau'] = documento;
    d['pcdes'] = ragioneSociale;
    d['psser'] = serie;
    d['psnum'] = numero;
    d['pspdt'] = dataScadenza;
    d['psdat'] = data;
    d['ctdes'] = tipoPagamento;
    d['pscto'] = codCliente;
    d['pspim'] = importo;
    return d;
  }
}
