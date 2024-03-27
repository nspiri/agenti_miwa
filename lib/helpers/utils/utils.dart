import 'dart:convert';
import 'dart:html' as html;
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:foody/helpers/extention/date_time_extention.dart';
import 'package:foody/helpers/storage/local_storage.dart';
import 'package:foody/helpers/utils/do_http_request.dart';
import 'package:foody/model/listino.dart';
import 'package:foody/model/request.dart' as r;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'package:open_file/open_file.dart' as open_file;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

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
    r.Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrute",
        etichettaCollage: "UTENTE",
        dati: {"Token": LocalStorage.getToken() ?? ""});

    if (res.code == 200) {
      if (res.error != "") {
        Get.toNamed("/auth/login");
      }
    }
  }
}
