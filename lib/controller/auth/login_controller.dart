import 'package:flutter/material.dart';
import 'package:foody/helpers/services/auth_services.dart';
import 'package:foody/helpers/widgets/my_form_validator.dart';
import 'package:foody/views/my_controller.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LoginController extends MyController {
  MyFormValidator basicValidator = MyFormValidator();
  String errore = "";
  bool showPassword = false, loading = false, isChecked = false;

  var greeting = "Buon giorno";
  late int currentTime = DateTime.now().hour;

  String version = "", code = "";

  @override
  void onInit() {
    basicValidator.addField('email',
        required: true,
        label: "Utente",
        validators: [
          /*MyLengthValidator(min: 6, max: 10)*/ /*MyEmailValidator()*/
        ],
        controller: TextEditingController());

    basicValidator.addField('password',
        required: true,
        label: "Password",
        validators: [/*MyLengthValidator(min: 2, max: 10)*/],
        controller: TextEditingController());

    if ((currentTime < 6) || (currentTime > 21)) {
      greeting = 'Buona notte';
    } else if (currentTime < 12) {
      greeting = 'Buon giorno';
    } else if (currentTime < 18) {
      greeting = 'Buon pomeriggio';
    } else if (currentTime < 22) {
      greeting = 'Buona sera';
    }
    getVersion();
    super.onInit();
  }

  getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    code = packageInfo.buildNumber;
    update();
  }

  void onChangeCheckBox(bool? value) {
    isChecked = value ?? isChecked;
    update();
  }

  void onChangeShowPassword() {
    showPassword = !showPassword;
    update();
  }

  Future<void> onLogin(BuildContext c) async {
    errore = "";
    update();
    if (basicValidator.validateForm()) {
      loading = true;
      update();
      var errors = await AuthService.loginUser(basicValidator.getData(), c);
      if (errors != null) {
        errore = errors;
        update();
      } else {
        String nextUrl =
            Uri.parse(ModalRoute.of(Get.context!)?.settings.name ?? "")
                    .queryParameters['next'] ??
                "/home";
        Get.toNamed(
          nextUrl,
        );
      }
      loading = false;
      update();
    } else {
      if (basicValidator.getController("email").text == "") {
        basicValidator.addError("email", "Inserisci un username");
      }
      if (basicValidator.getController("password").text == "") {
        basicValidator.addError("password", "Inserisci una password");
      }
      basicValidator.validateForm();
      basicValidator.clearErrors();
      update();
    }
  }

  void goToForgotPassword() {
    Get.toNamed('/auth/forgot_password');
  }

  void gotoRegister() {
    Get.offAndToNamed('/auth/register_account');
  }
}
