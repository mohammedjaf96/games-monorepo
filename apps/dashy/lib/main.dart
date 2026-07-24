import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import 'core/config/dashyCatalog.dart';
import 'core/config/dashyEconomy.dart';
import 'core/i18n/dashyTranslations.dart';
import 'core/routing/appPages.dart';
import 'core/routing/appRoutes.dart';

final GameConfig dashyConfig = GameConfig(
  gameId: 'dashy',
  adUnits: const AdUnits(),
  economy: dashyEconomy,
  storeCatalog: dashyCatalog,
  privacyPolicyUrl: 'https://mohammedjaf96.github.io/privacy-policy/',
);

void main() async {
  await bootstrapGame(config: dashyConfig);
  final settings = Get.find<SettingsController>();
  runApp(
    GetMaterialApp(
      title: 'Dashy',
      translations: DashyTranslations(),
      locale: Locale(settings.locale.value),
      fallbackLocale: const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('ar')],
      theme: GameTheme.light(GameTheme.dashy),
      darkTheme: GameTheme.dark(GameTheme.dashy),
      themeMode: settings.themeMode.value,
      getPages: AppPages.pages,
      initialRoute: AppRoutes.splash,
    ),
  );
}
