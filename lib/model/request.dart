import 'package:foody/helpers/utils/env.dart' as env;

class Request {
  late String cmd;
  late String codiceApp;
  late String nomeCollage;
  late String etichettaCollage;
  late dynamic dati;

  Request(
      {required this.cmd,
      required this.codiceApp,
      required this.nomeCollage,
      required this.etichettaCollage,
      required this.dati});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cmd'] = cmd;
    data['codice_app'] = codiceApp;
    data['nome_collage'] = nomeCollage;
    data['etichetta_collage'] = etichettaCollage;
    data['dati'] = dati;
    final Map<String, dynamic> head = <String, dynamic>{};
    head['Url'] = env.mexal_url;
    head['Authorization'] = env.passAuth;
    head['CoordinateGestionale'] =
        "Azienda=${env.sigla} Anno=${env.currentYear}";
    head['Body'] = data;

    return head;
  }

  Map<String, dynamic> getMxalBody() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cmd'] = cmd;
    data['codice_app'] = codiceApp;
    data['nome_collage'] = nomeCollage;
    data['etichetta_collage'] = etichettaCollage;
    data['dati'] = dati;
    final Map<String, dynamic> head = <String, dynamic>{};
    head['Url'] = env.mexal_url;
    head['Authorization'] = env.passAuth;
    head['CoordinateGestionale'] =
        "Azienda=${env.sigla} Anno=${env.currentYear}";
    head['Body'] = data;

    return data;
  }
}

class Response {
  int code;
  dynamic result;
  dynamic error;

  Response({required this.code, required this.result, required this.error});
}
