import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import 'core/config/blockoCatalog.dart';
import 'core/config/blockoEconomy.dart';
import 'core/config/blockoSplash.dart';
import 'core/i18n/blockoTranslations.dart';
import 'core/routing/appPages.dart';
import 'core/routing/appRoutes.dart';

final GameConfig blockoConfig = GameConfig(
  gameId: 'blocko',
  adUnits: const AdUnits(),
  economy: blockoEconomy,
  storeCatalog: blockoCatalog,
  privacyPolicyUrl: 'https://mohammedjaf96.github.io/privacy-policy/',
);

void main() async {
  await bootstrapGame(config: blockoConfig);
  Get.put(SplashController(blockoSplashConfig));
  final settings = Get.find<SettingsController>();
  runApp(
    GetMaterialApp(
      title: 'Blocko',
      translations: BlockoTranslations(),
      locale: Locale(settings.locale.value),
      fallbackLocale: const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('ar')],
      theme: GameTheme.light(GameTheme.blocko),
      darkTheme: GameTheme.dark(GameTheme.blocko),
      themeMode: settings.themeMode.value,
      getPages: AppPages.pages,
      initialRoute: AppRoutes.splash,
    ),
  );
}
