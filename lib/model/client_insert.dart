class InsertClient {
  String? agente;
  String? descrizione;
  String? nazionalita;
  String? siglaNazione;
  String? indirizzo;
  String? cap;
  String? localita;
  String? provincia;
  String? telefono;
  String? fax;
  String? email;
  String? sitoInternet;
  String? codFisc;
  String? partIva;
  String? nota1;
  String? nota2;
  int? codCatStat;
  int? codZona;
  String? codClifattA;

  InsertClient(
      {this.agente,
      this.descrizione,
      this.nazionalita,
      this.siglaNazione,
      this.indirizzo,
      this.cap,
      this.localita,
      this.provincia,
      this.telefono,
      this.fax,
      this.email,
      this.sitoInternet,
      this.codFisc,
      this.partIva,
      this.nota1,
      this.nota2,
      this.codCatStat,
      this.codZona,
      this.codClifattA});

  InsertClient.fromJson(Map<String, dynamic> json) {
    agente = json['agente'];
    descrizione = json['pcdes'];
    nazionalita = json['pcnaz'];
    siglaNazione = json['pcpae'];
    indirizzo = json['pcind'];
    cap = json['pccap'];
    localita = json['pcloc'];
    provincia = json['pcpro'];
    telefono = json['pctel'];
    fax = json['pcfax'];
    email = json['pcint'];
    sitoInternet = json['pcurl'];
    codFisc = json['pccfi'];
    partIva = json['pcnpi'];
    nota1 = json['pcnds1'];
    nota2 = json['pcnds2'];
    codCatStat = json['pccst'];
    codZona = json['pcona'];
    codClifattA = json['pcfta'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['agente'] = agente;
    data['pcdes'] = descrizione;
    data['pcnaz'] = nazionalita;
    data['pcpae'] = siglaNazione;
    data['pcind'] = indirizzo;
    data['pccap'] = cap;
    data['pcloc'] = localita;
    data['pcpro'] = provincia;
    data['pctel'] = telefono;
    data['pcfax'] = fax;
    data['pcint'] = email;
    data['pcurl'] = sitoInternet;
    data['pccfi'] = codFisc;
    data['pcnpi'] = partIva;
    data['pcnds1'] = nota1;
    data['pcnds2'] = nota1;
    data['pccst'] = codCatStat;
    data['pcona'] = codZona;
    data['pcfta'] = codClifattA;
    return data;
  }
}
