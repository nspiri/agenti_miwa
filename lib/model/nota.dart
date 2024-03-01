class Nota {
  int? rigo;
  String? nota;

  Nota({this.rigo, this.nota});

  Nota.fromJson(Map<String, dynamic> json) {
    rigo = json['rigo'];
    nota = json['nota'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rigo'] = rigo;
    data['nota'] = nota;
    return data;
  }
}
