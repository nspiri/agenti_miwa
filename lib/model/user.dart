class User {
  String? codiceAgente;
  String? utente;
  int? idListino;
  int? idMagazzino;
  bool? modificaPrezzo;
  bool? modificaSconto;

  User(
      {this.codiceAgente,
      this.utente,
      this.idListino,
      this.idMagazzino,
      this.modificaPrezzo,
      this.modificaSconto});

  User.fromJson(Map<String, dynamic> json) {
    codiceAgente = json['CodiceAgente'];
    utente = json['Utente'];
    idListino = json['IdListino'];
    idMagazzino = json['IdMagazzino'];
    modificaPrezzo = json['ModificaPrezzo'];
    modificaSconto = json['ModificaSconto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CodiceAgente'] = codiceAgente;
    data['Utente'] = utente;
    data['IdListino'] = idListino;
    data['IdMagazzino'] = idMagazzino;
    data['ModificaPrezzo'] = modificaPrezzo;
    data['ModificaSconto'] = modificaSconto;
    return data;
  }
}
