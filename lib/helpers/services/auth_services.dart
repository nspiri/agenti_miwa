import 'package:foody/helpers/utils/do_http_request.dart';
import 'package:foody/model/request.dart';
import 'package:foody/model/user.dart';

import '../storage/local_storage.dart';

class AuthService {
  static bool isLoggedIn = false;

  /* static User get dummyUser =>
      User(-1, "foody@getappui.com", "Denish", "Navadiya");*/

  static Future<Map<String, String>?> loginUser(
      Map<String, dynamic> data) async {
    Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrute",
        etichettaCollage: "LOGIN",
        dati: {"Utente": data["email"], "Password": data["password"]});

    if (res.code == 200) {
      var a = res.result as List<dynamic>;
      if (a.isEmpty) {
        var message = res.error[0]["response-message"];
        return {"password": message};
      }
      isLoggedIn = true;
      await LocalStorage.setLoggedInUser(true);
      await LocalStorage.setLoggedUser(User.fromJson(a[0]));
      return null;
    } else {
      return {"password": res.error["response-detail"]};
    }
  }
}
