import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mexalorder/helpers/localizations/app_localization_delegate.dart';
import 'package:mexalorder/helpers/localizations/language.dart';
import 'package:mexalorder/helpers/services/navigation_service.dart';
import 'package:mexalorder/helpers/storage/local_storage.dart';
import 'package:mexalorder/helpers/theme/app_notifire.dart';
import 'package:mexalorder/helpers/theme/app_style.dart';
import 'package:mexalorder/helpers/theme/theme_customizer.dart';
import 'package:mexalorder/routes.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:windows_single_instance/windows_single_instance.dart';

Future<void> main(List<String> args) async {
  //HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    await WindowsSingleInstance.ensureSingleInstance(args, "identifier",
        onSecondWindow: (args) {
      print(args);
    });
  }

  setPathUrlStrategy();

  await LocalStorage.init();
  AppStyle.init();
  await ThemeCustomizer.init();

  /*runApp(ChangeNotifierProvider<AppNotifier>(
    create: (context) => AppNotifier(),
    child: const MyApp(),
  ));*/
  runZoned<Future<void>>(
    () async {
      runApp(ChangeNotifierProvider<AppNotifier>(
        create: (context) => AppNotifier(),
        child: const MyApp(),
      ));
    },
    onError: (dynamic error, StackTrace stackTrace) {
      print("=================== CAUGHT DART ERROR");
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
      builder: (_, notifier, ___) {
        return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeCustomizer.instance.theme,
            navigatorKey: NavigationService.navigatorKey,
            initialRoute: "/home",
            getPages: getPageRoute(),
            builder: (_, child) {
              NavigationService.registerContext(_);
              return Directionality(
                  textDirection: AppTheme.textDirection,
                  child: child ?? Container());
            },
            localizationsDelegates: [
              AppLocalizationsDelegate(context),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: Language.getLocales(),
            scrollBehavior: MyCustomScrollBehavior());
      },
    );
  }
}

/*class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}*/

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
