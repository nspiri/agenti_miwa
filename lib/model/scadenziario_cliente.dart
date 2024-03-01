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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pscau'] = documento;
    data['pcdes'] = ragioneSociale;
    data['psser'] = serie;
    data['psnum'] = numero;
    data['pspdt'] = dataScadenza;
    data['psdat'] = data;
    data['ctdes'] = tipoPagamento;
    data['pscto'] = codCliente;
    data['pspim'] = importo;
    return data;
  }
}
