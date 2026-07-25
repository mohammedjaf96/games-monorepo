import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import 'core/config/mergoCatalog.dart';
import 'core/config/mergoEconomy.dart';
import 'core/config/mergoSplash.dart';
import 'core/i18n/mergoTranslations.dart';
import 'core/routing/appPages.dart';
import 'core/routing/appRoutes.dart';

final GameConfig mergoConfig = GameConfig(
  gameId: 'mergo',
  adUnits: const AdUnits(),
  economy: mergoEconomy,
  storeCatalog: mergoCatalog,
  privacyPolicyUrl: 'https://mohammedjaf96.github.io/privacy-policy/',
);

void main() async {
  await bootstrapGame(config: mergoConfig);
  Get.put(SplashController(mergoSplashConfig));
  final settings = Get.find<SettingsController>();
  runApp(
    GetMaterialApp(
      title: 'Mergo',
      translations: MergoTranslations(),
      locale: Locale(settings.locale.value),
      fallbackLocale: const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('ar')],
      theme: GameTheme.light(GameTheme.mergo),
      darkTheme: GameTheme.dark(GameTheme.mergo),
      themeMode: settings.themeMode.value,
      getPages: AppPages.pages,
      initialRoute: AppRoutes.splash,
    ),
  );
}
