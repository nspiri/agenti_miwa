class User {
  String? codiceAgente;
  String? utente;
  int? idListino;
  int? idMagazzino;
  bool? modificaPrezzo;
  bool? modificaSconto;
  int? idUtente;
  String? token;

  User(
      {this.codiceAgente,
      this.utente,
      this.idListino,
      this.idMagazzino,
      this.modificaPrezzo,
      this.modificaSconto,
      this.idUtente,
      this.token});

  User.fromJson(Map<String, dynamic> json) {
    codiceAgente = json['CodiceAgente'];
    utente = json['Utente'];
    idListino = json['IdListino'];
    idMagazzino = json['IdMagazzino'];
    modificaPrezzo = json['ModificaPrezzo'];
    modificaSconto = json['ModificaSconto'];
    idUtente = json['IdUtente'];
    token = json['Token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CodiceAgente'] = codiceAgente;
    data['Utente'] = utente;
    data['IdListino'] = idListino;
    data['IdMagazzino'] = idMagazzino;
    data['ModificaPrezzo'] = modificaPrezzo;
    data['ModificaSconto'] = modificaSconto;
    data['IdUtente'] = idUtente;
    data['Token'] = token;
    return data;
  }
}

class ControlloUtente {
  String? utente;
  bool? confermaStatoClienti;
  bool? attivo;
  String? codiceAgente;
  String? token;

  ControlloUtente(
      {this.utente,
      this.confermaStatoClienti,
      this.attivo,
      this.codiceAgente,
      this.token});

  ControlloUtente.fromJson(Map<String, dynamic> json) {
    utente = json['Utente'];
    confermaStatoClienti = json['ConfermaStatoClienti'];
    attivo = json['Attivo'];
    codiceAgente = json['CodiceAgente'];
    token = json['Token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Utente'] = utente;
    data['ConfermaStatoClienti'] = confermaStatoClienti;
    data['Attivo'] = attivo;
    data['CodiceAgente'] = codiceAgente;
    data['Token'] = token;
    return data;
  }
}
