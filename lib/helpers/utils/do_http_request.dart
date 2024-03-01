import 'dart:async';
import 'dart:convert';
import 'package:foody/model/request.dart' as r;
import 'package:http/http.dart' as http;
import 'package:foody/helpers/utils/env.dart' as env;
import 'package:dio/dio.dart';

class DoRequest {
  /*static Future<dynamic> doHttpRequest(
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
  }*/
  static Future<dynamic> doHttpRequest(
      {required String nomeCollage,
      required String etichettaCollage,
      required dynamic dati}) async {
    try {
      final dio = Dio();
      final r.Request request = r.Request(
          cmd: 'esec_collage_server_remoto',
          codiceApp: '415944MXLORDER',
          nomeCollage: nomeCollage,
          etichettaCollage: etichettaCollage,
          dati: dati);

      /*final response = await http
          .post(Uri.https("mxl1.hostcsi.com:9008", "/webapi/servizi"),
              headers: env.passHeaders, body: jsonEncode(request))
          .timeout(Duration(seconds: 120));*/

      final response = await dio.post(env.base_url,
          data: jsonEncode(request),
          options: Options(
            headers: env.passHeaders,
          ));

      //var jsonDecoded = jsonDecode(response.data);
      Map<String, dynamic> res = response.data;
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
      r.Response resp = r.Response(
          code: response.statusCode ?? 400,
          result: res["result"],
          error: errore);
      return resp;
    } on TimeoutException {
      return "404";
    } catch (e) {
      return e.toString();
    }
  }
}
