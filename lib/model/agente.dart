class Agente {
  String? pcdes;
  String? pccod;

  Agente({this.pcdes, this.pccod});

  Agente.fromJson(Map<String, dynamic> json) {
    pcdes = json['pcdes'];
    pccod = json['pccod'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pcdes'] = pcdes;
    data['pccod'] = pccod;
    return data;
  }
}
