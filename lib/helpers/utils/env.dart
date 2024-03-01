// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

String base_url = "https://mxl1.hostcsi.com:9008/webapi/servizi";

String user = "SPXAPI";
String pass = "CSICSICSI";
String sigla = "MIW";

String passAuth = "Passepartout ${base64Encode(utf8.encode('$user:$pass'))}";
String currentYear = DateTime.now().year.toString();

Map<String, String>? passHeaders = <String, String>{
  "Accept": "*/*",
  //"Accept-Encoding": "gzip, deflate, br, zstd",
  "Accept-Language": "it-IT,it;q=0.9,en-US;q=0.8,en;q=0.7",
  "Access-Control-Allow-Credentials": "true",
  "Access-Control-Allow-Methods": "*",
  'Access-Control-Allow-Origin': "https://miwa.datasistemi.cloud",
  "Authorization": passAuth,
  //"Connection": "keep-alive",
  "Content-Security-Policy": "default-src 'none';",
  'Content-Type': 'application/json; charset=UTF-8',
  "Coordinate-Gestionale": "Azienda=$sigla Anno=$currentYear",
  // "Host": "mxl1.hostcsi.com:9008",
  //"Origin": "https://miwa.datasistemi.cloud",
  //"Referer": "https://miwa.datasistemi.cloud/",
  // "Sec-Fetch-Dest": "empty",
  //"Sec-Fetch-Mode": "cors",
  //"Sec-Fetch-Site": "cross-site",
  //"User-Agent":
  //    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Safari/605.1.15"
};

setIp() async {}
