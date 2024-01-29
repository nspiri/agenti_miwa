import 'dart:async';
import 'dart:convert';
import 'package:foody/model/request.dart';
import 'package:http/http.dart' as http;
import 'package:foody/helpers/utils/env.dart' as env;

class DoRequest {
  static Future<dynamic> doHttpRequest(
      {required String nomeCollage,
      required String etichettaCollage,
      required dynamic dati}) async {
    try {
      final Request request = Request(
          cmd: 'esec_collage_server_remoto',
          codiceApp: '415944MXLORDER',
          nomeCollage: nomeCollage,
          etichettaCollage: etichettaCollage,
          dati: dati);

      final response = await http
          .post(Uri.https("mxl1.hostcsi.com:9008", "/webapi/servizi"),
              headers: env.passHeaders, body: jsonEncode(request))
          .timeout(Duration(seconds: 120));

      var jsonDecoded = jsonDecode(response.body);
      Map<String, dynamic> res = jsonDecoded;
      String errore = "";
      if (response.statusCode == 200) {
        if ((res["error"] as List).isNotEmpty) {
          errore = res["error"][0]["response-message"];
        }
      } else {
        if (res["error"].isNotEmpty) {
          errore = res["error"]["response-message"];
        }
      }
      Response resp = Response(
          code: response.statusCode, result: res["result"], error: errore);
      return resp;
    } on TimeoutException {
      return "404";
    } catch (e) {
      return e.toString();
    }
  }
}
