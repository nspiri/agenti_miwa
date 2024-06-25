import 'dart:convert';
import 'package:package_info_plus/package_info_plus.dart';

import 'pdf_mobile.dart' if (dart.library.html) 'pdf_web.dart' as web;
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:mexalorder/helpers/extention/date_time_extention.dart';
import 'package:mexalorder/helpers/storage/local_storage.dart';
import 'package:mexalorder/helpers/utils/do_http_request.dart';
import 'package:mexalorder/model/customer_detail.dart';
import 'package:mexalorder/model/customer_list.dart';
import 'package:mexalorder/model/listino.dart';
import 'package:mexalorder/model/request.dart' as r;
import 'package:mexalorder/model/user.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'package:open_file/open_file.dart' as open_file;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as hp;

class Utils {
  static getDateStringFromDateTime(DateTime dateTime,
      {bool showMonthShort = false}) {
    String date =
        dateTime.day < 10 ? "0${dateTime.day}" : dateTime.day.toString();
    late String month;
    if (showMonthShort) {
      month = dateTime.getMonthName();
    } else {
      month = dateTime.month < 10
          ? "0${dateTime.month}"
          : dateTime.month.toString();
    }

    String year = dateTime.year.toString();
    String separator = showMonthShort ? " " : "-";
    return "$date$separator$month$separator$year";
  }

  static getTimeStringFromDateTime(
    DateTime dateTime, {
    bool showSecond = true,
  }) {
    String hour = dateTime.hour.toString();
    if (dateTime.hour > 12) {
      hour = (dateTime.hour - 12).toString();
    }

    String minute = dateTime.minute < 10
        ? "0${dateTime.minute}"
        : dateTime.minute.toString();
    String second = "";

    if (showSecond) {
      second = dateTime.second < 10
          ? "0${dateTime.second}"
          : dateTime.second.toString();
    }
    String meridian = "";
    meridian = dateTime.hour < 12 ? " AM" : " PM";

    return "$hour:$minute${showSecond ? ":" : ""}$second$meridian";
  }

  static String getDateTimeStringFromDateTime(DateTime dateTime,
      {bool showSecond = true,
      bool showDate = true,
      bool showTime = true,
      bool showMonthShort = false}) {
    if (showDate && !showTime) {
      return getDateStringFromDateTime(dateTime);
    } else if (!showDate && showTime) {
      return getTimeStringFromDateTime(dateTime, showSecond: showSecond);
    }
    return "${getDateStringFromDateTime(dateTime, showMonthShort: showMonthShort)} ${getTimeStringFromDateTime(dateTime, showSecond: showSecond)}";
  }

  static String getStorageStringFromByte(int bytes) {
    double b = bytes.toDouble(); //1024
    double k = bytes / 1024; //1
    double m = k / 1024; //0.001
    double g = m / 1024; //...
    double t = g / 1024; //...

    if (t >= 1) {
      return "${t.toStringAsFixed(2)} TB";
    } else if (g >= 1) {
      return "${g.toStringAsFixed(2)} GB";
    } else if (m >= 1) {
      return "${m.toStringAsFixed(2)} MB";
    } else if (k >= 1) {
      return "${k.toStringAsFixed(2)} KB";
    } else {
      return "${b.toStringAsFixed(2)} Bytes";
    }
  }

  static String getDateRequest(String date) {
    DateTime d = stringToDate(date);
    return dateToString(d);
  }

  static String getFormattedDate(String date) {
    if (date == "") {
      return "";
    }
    DateTime d = stringToDate(date);
    return dateToString(d);
  }

  static DateTime stringToDate(String date) {
    if (date == "") {
      return DateTime(0);
    }
    int year = int.parse(date.substring(0, 4));
    int month = int.parse(date.substring(4, 6));
    int day = int.parse(date.substring(6, 8));
    return DateTime(year, month, day);
  }

  static String dateToString(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  static String dateToStringPdf(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static DateTime stringToData(String date) {
    return DateFormat('dd-MM-yyyy').parse(date);
  }

  static String stringToDateR(String date) {
    DateTime dat = DateFormat('dd-MM-yyyy').parse(date);
    return DateFormat('yyyyMMdd').format(dat);
  }

  static String formatStringDecimal(double? value, int decimali) {
    var pattern = "#,##0";
    for (var c = 0; c < decimali; c++) {
      if (c == 0) {
        pattern = "$pattern.";
      }
      pattern = "${pattern}0";
    }
    var f = NumberFormat(pattern, "it_IT");
    return f.format(value);
    //return value?.toStringAsFixed(decimali).replaceAll(".", ",") ?? "";
  }

  static Future<List<Listino>> getNomeListini() async {
    List<Listino> lista = await Listino.dummyList;
    return lista;
    /*Listino.dummyList.then((value) {
      lista = value;
      return lista;
    });*/
  }

  static controllaLogin() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String token = "";

    if (!kIsWeb) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String v = packageInfo.version;
      String c = packageInfo.buildNumber;

      var url = Uri.parse("");

      if (Platform.isWindows) {
        url = Uri.parse(
            "https://download.datasistemi.cloud/apk/miwa/version.txt");
      }
      if (Platform.isAndroid) {
        url = Uri.parse(
            "https://download.datasistemi.cloud/apk/miwa/apk/version.txt");
      }
      hp.Response response = await hp.get(url);

      if (response.body != "") {
        try {
          int version =
              int.parse(response.body.replaceAll(".", "").replaceAll("+", ""));
          int curVer = int.parse("${v.replaceAll(".", "")}${c}");
          if (version > curVer) {
            await LocalStorage.setLoggedInUser(false);
            Get.toNamed("/auth/login");
          }
        } catch (e) {
          print('Failed to make OTA update. Details: $e');
        }
      }
    }

    if (kIsWeb) {
      token = LocalStorage.getToken() ?? "";
    } else {
      if (Platform.isWindows) {
        WindowsDeviceInfo info = await deviceInfo.windowsInfo;
        token = info.deviceId.replaceAll("{", "").replaceAll("}", "");
      }
      if (Platform.isAndroid) {
        token = LocalStorage.getToken() ?? "";
      }
    }

    r.Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrute",
        etichettaCollage: "UTENTE",
        dati: {
          "Token": token,
          "IdUtente": LocalStorage.getLoggedUser()?.idUtente ?? 0
        });

    if (res.code == 200) {
      if (res.error != "") {
        await LocalStorage.setLoggedInUser(false);
        Get.toNamed("/auth/login");
      }
      var a = res.result as List<dynamic>;
      if (a.isNotEmpty) {
        ControlloUtente user = ControlloUtente.fromJson(a[0]);
        if (user.confermaStatoClienti == true) {
          var a = 0;
          await StatoCliente.dummyList.then((value) {
            for (var element in value) {
              if (element.stato == "") {
                Get.toNamed("/admin/customers/state", arguments: value);
              }
            }
          });
        }
      }
    }
  }

  static Future<void> saveAndLaunchFile(
      List<int> bytes, String fileName) async {
    web.launchFile(bytes, fileName);
    /* if (kIsWeb) {
      web.launchFile(bytes, fileName);
    } else {
      String? path;
      if (Platform.isAndroid ||
          Platform.isIOS ||
          Platform.isLinux ||
          Platform.isWindows) {
        final Directory directory =
            await path_provider.getApplicationSupportDirectory();
        path = directory.path;
      } else {
        path = await PathProviderPlatform.instance.getApplicationSupportPath();
      }
      final File file =
          File(Platform.isWindows ? '$path\\$fileName' : '$path/$fileName');
      await file.writeAsBytes(bytes, flush: true);
      if (Platform.isAndroid || Platform.isIOS) {
        //Launch the file (used open_file package)
        await open_file.OpenFile.open('$path/$fileName');
      } else if (Platform.isWindows) {
        await Process.run('start', <String>['$path\\$fileName'],
            runInShell: true);
      } else if (Platform.isMacOS) {
        await Process.run('open', <String>['$path/$fileName'],
            runInShell: true);
      } else if (Platform.isLinux) {
        await Process.run('xdg-open', <String>['$path/$fileName'],
            runInShell: true);
      }
    }*/
  }
}
