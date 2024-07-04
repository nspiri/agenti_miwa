// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

String base_url = "https://mexalproxy.datasistemi.cloud/api/mexal/proxy";
String user = "Mexal";
String pass = "GkU2CIoAZwDEWDE";

//TEST
/*String mexal_url = "https://mxl1.hostcsi.com:9008/webapi/servizi";
String mxl_user = "SPXAPI";
String mxl_pass = "CSICSICSI  ";
String sigla = "MIW";*/

//PROD
String mexal_url = "https://mxl2.hostcsi.com:9005/webapi/servizi";
String mxl_user = "MXLORD";
String mxl_pass = "CSICSICSI";
String sigla = "MIW";

String passAuth =
    "Passepartout ${base64Encode(utf8.encode('$mxl_user:$mxl_pass'))}";
String currentYear = DateTime.now().year.toString();

Map<String, String>? passHeaders = <String, String>{
  "Authorization": passAuth,
  "Content-Security-Policy": "default-src 'none';",
  'Content-Type': 'application/json; charset=UTF-8',
  "Coordinate-Gestionale": "Azienda=$sigla Anno=$currentYear",
};

String basicAuth = 'Basic ${base64.encode(utf8.encode('$user:$pass'))}';

Map<String, String>? headers = <String, String>{
  "Access-Control-Allow-Credentials": "true",
  "Access-Control-Allow-Methods": "*",
  'Access-Control-Allow-Origin': "https://miwa.datasistemi.cloud",
  "Authorization": basicAuth,
  'Content-Type': 'application/json; charset=UTF-8',
};

setIp() async {}
