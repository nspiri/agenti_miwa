import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mexalorder/model/request.dart' as r;
import 'package:http/http.dart' as http;
import 'package:mexalorder/helpers/utils/env.dart' as env;
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

      var a = request.toJson();
      if (kIsWeb) {
        final response = await dio.post(env.base_url,
            data: jsonEncode(a),
            options: Options(
                headers: env.headers,
                sendTimeout: Duration(seconds: 120),
                receiveTimeout: Duration(seconds: 120)));
        /*final response = await http
            //.post(Uri.https("mxl1.hostcsi.com:9008", "/webapi/servizi"),
            .post(Uri.https(env.base_url, "/api/mexal/proxy"),
                headers: env.passHeaders, body: jsonEncode(request))
            .timeout(Duration(seconds: 120));*/
        Map<String, dynamic> res = response.data;
        /*var jsonDecoded = jsonDecode(response.body);
        Map<String, dynamic> res = jsonDecoded;*/
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
      } else {
        final response = await dio.post(env.base_url,
            data: jsonEncode(a),
            options: Options(
              headers: env.headers,
            ));
        /*final response = await http
            //.post(Uri.https("mxl1.hostcsi.com:9008", "/webapi/servizi"),
            .post(Uri.https(env.base_url, "/api/mexal/proxy"),
                headers: env.passHeaders, body: jsonEncode(request))
            .timeout(Duration(seconds: 120));*/
        Map<String, dynamic> res = response.data;
        /*var jsonDecoded = jsonDecode(response.body);
        Map<String, dynamic> res = jsonDecoded;*/
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
        /* var a = request.getMxalBody();
        final response = await http
            .post(Uri.https("mxl2.hostcsi.com:9005", "/webapi/servizi"),
                headers: env.passHeaders, body: jsonEncode(a))
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
        r.Response resp = r.Response(
            code: response.statusCode, result: res["result"], error: errore);
        return resp;*/
      }
    } on TimeoutException {
      r.Response resp = r.Response(code: 404, result: "", error: "404");
      return resp;
    } catch (e) {
      r.Response resp = r.Response(code: 404, result: "", error: e.toString());
      return resp;
    }
  }
}
