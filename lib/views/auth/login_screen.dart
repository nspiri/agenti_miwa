import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mexalorder/controller/auth/login_controller.dart';
import 'package:mexalorder/helpers/theme/app_themes.dart';
import 'package:mexalorder/helpers/utils/ui_mixins.dart';
import 'package:mexalorder/helpers/widgets/my_button.dart';
import 'package:mexalorder/helpers/widgets/my_flex.dart';
import 'package:mexalorder/helpers/widgets/my_flex_item.dart';
import 'package:mexalorder/helpers/widgets/my_responsiv.dart';
import 'package:mexalorder/helpers/widgets/my_screen_media_type.dart';
import 'package:mexalorder/helpers/widgets/my_spacing.dart';
import 'package:mexalorder/helpers/widgets/my_text.dart';
import 'package:mexalorder/helpers/widgets/my_text_style.dart';
import 'package:mexalorder/images.dart';
import 'package:mexalorder/views/layout/auth_layout.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:auto_updater/auto_updater.dart';
import 'package:http/http.dart' as hp;
import 'package:ota_update/ota_update.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin, UIMixin, UpdaterListener {
  late LoginController controller;
  var focusNode = FocusNode();
  OtaEvent? currentEvent;
  String test = "Inizio";

  @override
  void initState() {
    controller = Get.put(LoginController());
    if (!kIsWeb) {
      if (Platform.isWindows) {
        autoUpdater.addListener(this);
        update();
      }
      if (Platform.isAndroid) {
        tryOtaUpdate();
      }
    }
    super.initState();
  }

  void update() async {
    //Chiamata check
    checkVersion();
  }

  Future<void> tryOtaUpdate() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var currentVersion = "${packageInfo.version}${packageInfo.buildNumber}";
    var url = Uri.parse(
        "https://download.datasistemi.cloud/apk/miwa/apk/version.txt");
    hp.Response response = await hp.get(url);
    if (response.body != "") {
      try {
        int version =
            int.parse(response.body.replaceAll(".", "").replaceAll("+", ""));
        int curVer = int.parse(currentVersion.replaceAll(".", ""));
        test = "VERSIONI $curVer $version";
        setState(() {});
        if (version > curVer) {
          print('ABI Platform: ${await OtaUpdate().getAbi()}');
          OtaUpdate()
              .execute(
            'https://download.datasistemi.cloud/apk/miwa/apk/app-release.apk',
            destinationFilename: 'app-release-temp.apk',
          )
              .listen(
            (OtaEvent event) {
              setState(() {
                currentEvent = event;
              });
            },
          );
        }
      } catch (e) {
        print('Failed to make OTA update. Details: $e');
      }
    }
  }

  checkVersion() async {
    var url =
        Uri.parse("https://download.datasistemi.cloud/apk/miwa/version.txt");
    hp.Response response = await hp.get(url);

    if (response.body != "") {
      try {
        int version =
            int.parse(response.body.replaceAll(".", "").replaceAll("+", ""));
        int curVer = int.parse(
            "${controller.version.replaceAll(".", "")}${controller.code}");
        if (version > curVer) {
          String feedURL =
              'https://download.datasistemi.cloud/apk/miwa/appcast.xml';
          await autoUpdater.setFeedURL(feedURL);
          await autoUpdater.checkForUpdates(inBackground: false);
          await autoUpdater.setScheduledCheckInterval(3600);
        }
      } catch (e) {
        print('Failed to make OTA update. Details: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      child: GetBuilder(
        init: controller,
        builder: (controller) {
          return Stack(
            children: [
              MyFlex(
                contentPadding: false,
                runAlignment: WrapAlignment.center,
                wrapCrossAlignment: WrapCrossAlignment.center,
                wrapAlignment: WrapAlignment.center,
                children: [
                  MyFlexItem(
                    sizes: "lg-6",
                    child: MyResponsive(
                      builder: (_, __, type) {
                        return type == MyScreenMediaType.xxl
                            ? buildAuthSideBar()
                            : type == MyScreenMediaType.xl
                                ? buildAuthSideBar()
                                : type == MyScreenMediaType.lg
                                    ? buildAuthSideBar()
                                    : const SizedBox();
                      },
                    ),
                  ),
                  MyFlexItem(
                    sizes: "lg-6",
                    child: Padding(
                      padding: MySpacing.only(left: 30, right: 30),
                      child: Form(
                        key: controller.basicValidator.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                              child: Image.asset(
                                height: 200,
                                Images.logoMiwa,
                                fit: BoxFit.cover,
                              ),
                            ),
                            MyText.displaySmall(
                              "LogIn",
                              fontWeight: 600,
                            ),
                            MySpacing.height(32),
                            TextFormField(
                              onFieldSubmitted: (value) {
                                controller.onLogin(context);
                              },
                              validator: controller.basicValidator
                                  .getValidation('email'),
                              controller: controller.basicValidator
                                  .getController('email'),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  labelText: "Indirizzo Email",
                                  labelStyle:
                                      MyTextStyle.bodySmall(xMuted: true),
                                  border: outlineInputBorder,
                                  enabledBorder: outlineInputBorder,
                                  focusedBorder: focusedInputBorder,
                                  prefixIcon: const Icon(
                                    LucideIcons.mail,
                                    size: 20,
                                  ),
                                  contentPadding: MySpacing.all(16),
                                  isCollapsed: true,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never),
                            ),
                            MySpacing.height(20),
                            TextFormField(
                              onFieldSubmitted: (value) {
                                controller.onLogin(context);
                              },
                              validator: controller.basicValidator
                                  .getValidation('password'),
                              controller: controller.basicValidator
                                  .getController('password'),
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: !controller.showPassword,
                              decoration: InputDecoration(
                                  labelText: "Password",
                                  labelStyle:
                                      MyTextStyle.bodySmall(xMuted: true),
                                  border: outlineInputBorder,
                                  enabledBorder: outlineInputBorder,
                                  focusedBorder: focusedInputBorder,
                                  prefixIcon: const Icon(
                                    LucideIcons.lock,
                                    size: 20,
                                  ),
                                  suffixIcon: InkWell(
                                    onTap: controller.onChangeShowPassword,
                                    child: Icon(
                                      controller.showPassword
                                          ? LucideIcons.eye
                                          : LucideIcons.eyeOff,
                                      size: 20,
                                    ),
                                  ),
                                  contentPadding: MySpacing.all(16),
                                  isCollapsed: true,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /*Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        onChanged: controller.onChangeCheckBox,
                                        value: controller.isChecked,
                                        fillC olor:
                                            MaterialStatePropertyAll(Colors.white),
                                        activeColor: theme.colorScheme.primary,
                                        checkColor: contentTheme.primary,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        visualDensity: getCompactDensity,
                                      ),
                                      MySpacing.width(8),
                                      MyText.bodyMedium(
                                        "Ricordami",
                                      ),
                                    ],
                                  ),
                                ),*/
                                /*  MyButton.text(
                                  onPressed: controller.goToForgotPassword,
                                  elevation: 0,
                                  padding: MySpacing.xy(8, 0),
                                  splashColor:
                                      contentTheme.secondary.withOpacity(0.1),
                                  child: MyText.labelSmall(
                                    'Password dimenticata?',
                                    color: contentTheme.secondary,
                                  ),
                                ),*/
                              ],
                            ),
                            MySpacing.height(28),
                            Center(
                              child: MyButton.rounded(
                                onPressed: () {
                                  controller.onLogin(context);
                                },
                                elevation: 0,
                                padding: MySpacing.xy(20, 16),
                                backgroundColor: contentTheme.primary,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    controller.loading
                                        ? SizedBox(
                                            height: 14,
                                            width: 14,
                                            child: CircularProgressIndicator(
                                              color:
                                                  theme.colorScheme.onPrimary,
                                              strokeWidth: 1.2,
                                            ),
                                          )
                                        : Container(),
                                    if (controller.loading) MySpacing.width(16),
                                    MyText.bodySmall(
                                      'Login',
                                      color: contentTheme.onPrimary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            controller.errore != ""
                                ? MyText.bodySmall(
                                    controller.errore,
                                    color: contentTheme.red,
                                  )
                                : Text(""),
                            /*Center(
                              child: MyButton.text(
                                onPressed: controller.gotoRegister,
                                elevation: 0,
                                padding: MySpacing.x(16),
                                splashColor:
                                    contentTheme.secondary.withOpacity(0.1),
                                child: MyText.labelMedium(
                                  'I haven\'t account',
                                  color: contentTheme.secondary,
                                ),
                              ),
                            ),*/
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Center(
                  child: Text(
                    "Version: ${controller.version} (${controller.code})",
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ),
              Positioned.fill(child: loadingDownload())
            ],
          );
        },
      ),
    );
  }

  Widget loadingDownload() {
    return Visibility(
      visible: currentEvent?.status.name == "DOWNLOADING",
      child: Container(
        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.5)),
        child: Center(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                      '${currentEvent?.status.name} : ${currentEvent?.value}%'),
                  // test),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAuthSideBar() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 700,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage(Images.authSideImage),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            blendMode: BlendMode.darken,
            child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
            ),
          ),
        ),
        SizedBox(
          height: 700,
          width: 400,
          child: Center(
            child: MyText.displayMedium(
              "${controller.greeting} Benvenuto",
              textAlign: TextAlign.center,
              color: contentTheme.light,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void onUpdaterBeforeQuitForUpdate(AppcastItem? appcastItem) {
    print("onUpdaterBeforeQuitForUpdate");
    // TODO: implement onUpdaterBeforeQuitForUpdate
  }

  @override
  void onUpdaterCheckingForUpdate(Appcast? appcast) {
    print("onUpdaterCheckingForUpdate");
    // TODO: implement onUpdaterCheckingForUpdate
  }

  @override
  void onUpdaterError(UpdaterError? error) {
    print("onUpdaterError");
    exit(0);
    // TODO: implement onUpdaterError
  }

  @override
  void onUpdaterUpdateAvailable(AppcastItem? appcastItem) async {
    print("onUpdaterUpdateAvailable");
    // TODO: implement onUpdaterUpdateAvailable
  }

  @override
  void onUpdaterUpdateDownloaded(AppcastItem? appcastItem) {
    print("onUpdaterUpdateDownloaded");
    // TODO: implement onUpdaterUpdateDownloaded
  }

  @override
  void onUpdaterUpdateNotAvailable(UpdaterError? error) {
    print("onUpdaterUpdateNotAvailable");
    // TODO: implement onUpdaterUpdateNotAvailable
  }

  @override
  void onUpdaterCancelled(AppcastItem? appcastItem) {
    exit(0);
  }
}
