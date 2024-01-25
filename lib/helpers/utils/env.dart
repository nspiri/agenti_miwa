// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

String base_url = "https://mxl1.hostcsi.com:9008/webapi/servizi";

String user = "SPXAPI";
String pass = "CSICSICSI";
String sigla = "MIW";

String passAuth = "Passepartout ${base64Encode(utf8.encode('$user:$pass'))}";
String currentYear = DateTime.now().year.toString();

Map<String, String>? passHeaders = <String, String>{
  'Content-Type': 'application/json; charset=UTF-8',
  "Coordinate-Gestionale": "Azienda=$sigla Anno=$currentYear",
  "Authorization": passAuth
};

setIp() async {}
