import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mexalorder/controller/home_controller.dart';
import 'package:mexalorder/helpers/utils/ui_mixins.dart';
import 'package:mexalorder/helpers/widgets/my_breadcrumb.dart';
import 'package:mexalorder/helpers/widgets/my_breadcrumb_item.dart';
import 'package:mexalorder/helpers/widgets/my_button.dart';
import 'package:mexalorder/helpers/widgets/my_container.dart';
import 'package:mexalorder/helpers/widgets/my_flex.dart';
import 'package:mexalorder/helpers/widgets/my_flex_item.dart';
import 'package:mexalorder/helpers/widgets/my_spacing.dart';
import 'package:mexalorder/helpers/widgets/my_text.dart';
import 'package:mexalorder/helpers/widgets/responsive.dart';
import 'package:mexalorder/views/layout/layout.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as hp;
import 'package:auto_updater/auto_updater.dart';
import 'package:ota_update/ota_update.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, UIMixin, UpdaterListener {
  late HomeController controller;
  OtaEvent? currentEvent;

  @override
  void initState() {
    controller = Get.put(HomeController());
    if (!kIsWeb) {
      if (Platform.isWindows) {
        autoUpdater.addListener(this);
        update();
      }
      if (Platform.isAndroid) {
        tryOtaUpdate();
      }
    }
    controller.getDati();
    super.initState();
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

  void update() async {
    //Chiamata check
    checkVersion();
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
    return Layout(
      child: GetBuilder(
        init: controller,
        builder: (controller) {
          return Column(
            children: [
              Padding(
                padding: MySpacing.x(flexSpacing / 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText.titleMedium(
                      "Home",
                      fontSize: 18,
                      fontWeight: 600,
                    ),
                    MyBreadcrumb(
                      children: [
                        MyBreadcrumbItem(name: 'Home', active: true),
                      ],
                    ),
                  ],
                ),
              ),
              MySpacing.height(flexSpacing / 2),
              Padding(
                padding: MySpacing.xy(flexSpacing / 2, flexSpacing / 2),
                child: MyFlex(
                  children: [
                    /*  MyFlexItem(sizes: 'lg-8', child: buildDashboardAD()),
                    MyFlexItem(
                      sizes: 'lg-4',
                      child: buildPremiumContainer(),
                    ),*/
                    MyFlexItem(child: pulsanti()),
                    MyFlexItem(
                      sizes: 'lg-4',
                      child: Padding(
                        padding: MySpacing.x(flexSpacing / 2),
                        child: MyText.titleMedium(
                          "Link",
                          fontSize: 18,
                          fontWeight: 600,
                        ),
                      ),
                    ),
                    MyFlexItem(child: link())
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget pulsanti() {
    return MyFlex(
      children: [
        for (var i = 0; i < controller.listaPulsanti.length; i++)
          MyFlexItem(
              sizes: "xs-6 sm-6 md-4 lg-2",
              child: SizedBox(
                height: 170,
                child: MyContainer(
                  width: 165,
                  onTap: () {
                    controller.onSelectPulsante(i);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        controller.listaPulsanti[i]['image'] ?? '',
                        height: 100,
                      ),
                      MySpacing.height(8),
                      MyText.bodyMedium(
                        textAlign: TextAlign.center,
                        controller.listaPulsanti[i]["url"] ==
                                "/admin/customers/state"
                            ? "${controller.listaPulsanti[i]['name']} (${controller.numStatoCli})"
                            : controller.listaPulsanti[i]["url"] ==
                                    "/admin/equipment"
                                ? "${controller.listaPulsanti[i]['name']} (${controller.numAttrezz})"
                                : "${controller.listaPulsanti[i]['name']}",
                        fontWeight: 600,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              )),
      ],
    );
  }

  Widget link() {
    return MyFlex(
      children: [
        for (var i = 0; i < controller.listaLink.length; i++)
          MyFlexItem(
              sizes: "xs-6 sm-6 md-4 lg-2",
              child: SizedBox(
                  height: 170,
                  child: MyContainer(
                    width: 165,
                    onTap: () {
                      controller.onSelectLink(i);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          controller.listaLink[i]['image'] ?? '',
                          height: 100,
                        ),
                        MySpacing.height(8),
                        MyText.bodyMedium(
                          controller.listaLink[i]['name'] ?? '',
                          textAlign: TextAlign.center,
                          fontWeight: 600,
                        ),
                      ],
                    ),
                  ))),
      ],
    );
  }

  Widget buildDashboardAD() {
    return Stack(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      alignment: Alignment.topLeft,
      children: [
        MyContainer(
          height: 280,
          color: contentTheme.primary.withAlpha(40),
        ),
        Positioned(
          width: 250,
          bottom: 100,
          left: -40,
          child: MyContainer.rounded(
            height: 250,
            color: contentTheme.light.withAlpha(100),
          ),
        ),
        Positioned(
          width: 200,
          top: 40,
          left: -120,
          child: MyContainer.rounded(
            height: 250,
            color: contentTheme.light.withAlpha(100),
          ),
        ),
        Positioned(
          right: 50,
          width: 100,
          top: 60,
          child: MyContainer.rounded(
            height: 100,
            color: contentTheme.light.withAlpha(100),
          ),
        ),
        Positioned(
          right: 20,
          width: 100,
          top: 20,
          child: MyContainer.rounded(
            height: 100,
            color: contentTheme.light.withAlpha(100),
          ),
        ),
        Positioned(
          right: 80,
          width: 100,
          top: 20,
          child: MyContainer.rounded(
            height: 100,
            color: contentTheme.light.withAlpha(100),
          ),
        ),
        Positioned(
          height: 200,
          width: 500,
          right: 150,
          bottom: -50,
          child: MyContainer(
            color: contentTheme.light.withAlpha(100),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(200),
              topLeft: Radius.circular(100),
              bottomLeft: Radius.circular(200),
            ),
          ),
        ),
        Positioned.fill(child: loadingDownload()),
        MyFlex(
          children: [
            MyFlexItem(
                sizes: 'lg-6 mg-6 sm-6 xs-6',
                child: MyContainer.transparent(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText.bodyMedium(
                        "Light In The Stomach, Good\nFor Your Health",
                        fontWeight: 900,
                        maxLines: 4,
                        overflow: TextOverflow.visible,
                        letterSpacing: 5,
                        fontSize: 20,
                      ),
                      MySpacing.height(40),
                      SizedBox(
                        width: 150,
                        child: MyButton.block(
                          onPressed: () {},
                          elevation: 0,
                          backgroundColor: contentTheme.light,
                          child: MyText.bodyMedium(
                            'Order Now',
                            fontWeight: 600,
                            color: contentTheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            MyFlexItem(
                sizes: 'lg-6 mg-6 sm-6 xs-6',
                child: MyContainer.transparent(
                  child: Image.asset(
                    'assets/images/fast_food/delivery_boy.png',
                    height: 250,
                  ),
                )),
          ],
        )
      ],
    );
  }

  Widget buildPremiumContainer() {
    return Container(
      height: 280,
      padding: MySpacing.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          tileMode: TileMode.decal,
          colors: [
            Colors.red.withAlpha(100),
            Colors.pink.withAlpha(100),
            Colors.redAccent.withAlpha(100),
            Colors.purple.withAlpha(100),
          ],
        ),
        color: contentTheme.danger.withAlpha(36),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText.bodyLarge(
            "You do not have a valid Subscription. Please active your subscription",
            fontSize: 20,
            fontWeight: 600,
            muted: true,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          MyButton.block(
              borderRadiusAll: 12,
              elevation: 0,
              backgroundColor: contentTheme.danger.withAlpha(100),
              onPressed: () {},
              child: MyText.bodyMedium(
                'Go to Pro Now!',
                // color: contentTheme.danger,
                fontWeight: 600,
              ))
        ],
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
