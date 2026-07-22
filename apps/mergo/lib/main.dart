import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import 'core/config/mergoCatalog.dart';
import 'core/config/mergoEconomy.dart';
import 'core/i18n/mergoTranslations.dart';
import 'core/routing/appPages.dart';
import 'core/routing/appRoutes.dart';

final GameConfig mergoConfig = GameConfig(
  gameId: 'mergo',
  adUnits: const AdUnits(),
  economy: mergoEconomy,
  storeCatalog: mergoCatalog,
  privacyPolicyUrl: 'https://mohammedjaf96.github.io/games-monorepo/',
);

void main() async {
  await bootstrapGame(config: mergoConfig);
  final startupLocale = Get.find<SettingsController>().locale.value;
  runApp(
    GetMaterialApp(
      title: 'Mergo',
      translations: MergoTranslations(),
      locale: Locale(startupLocale),
      fallbackLocale: const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('ar')],
      theme: GameTheme.build(GameTheme.mergo),
      getPages: AppPages.pages,
      initialRoute: AppRoutes.splash,
    ),
  );
}
