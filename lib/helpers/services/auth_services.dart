import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mexalorder/helpers/utils/do_http_request.dart';
import 'package:mexalorder/model/request.dart';
import 'package:mexalorder/model/user.dart';
import '../storage/local_storage.dart';

class AuthService {
  static bool isLoggedIn = false;

  /* static User get dummyUser =>
      User(-1, "mexalorder@getappui.com", "Denish", "Navadiya");*/
  static Future<String?> loginUser(
      Map<String, dynamic> data, BuildContext? context) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String? token = "";

    if (kIsWeb) {
      token = LocalStorage.getToken() ?? "";
    } else {
      if (Platform.isWindows) {
        WindowsDeviceInfo info = await deviceInfo.windowsInfo;
        token = info.deviceId.replaceAll("{", "").replaceAll("}", "");
      }
    }

    Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrute",
        etichettaCollage: "LOGIN",
        dati: {
          "Utente": data["email"],
          "Password": data["password"],
          "Token": token ?? ""
        });

    if (res.code == 200) {
      var a = res.result as List<dynamic>;
      if (a.isEmpty) {
        var message = res.error;
        return message;
      }
      isLoggedIn = true;
      User user = User.fromJson(a[0]);
      await LocalStorage.setLoggedInUser(true);
      await LocalStorage.setToken(user.token ?? "");
      await LocalStorage.setLoggedUser(user);
      if (res.error != "" && res.error != null && res.error != []) {
        return res.error;
      }
      return null;
    } else {
      var message = res.error;
      return message;
    }
  }
}
