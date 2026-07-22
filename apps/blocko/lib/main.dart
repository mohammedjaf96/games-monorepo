import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import 'core/config/blockoCatalog.dart';
import 'core/config/blockoEconomy.dart';
import 'core/i18n/blockoTranslations.dart';
import 'core/routing/appPages.dart';
import 'core/routing/appRoutes.dart';

final GameConfig blockoConfig = GameConfig(
  gameId: 'blocko',
  adUnits: const AdUnits(),
  economy: blockoEconomy,
  storeCatalog: blockoCatalog,
  privacyPolicyUrl: 'https://mohammedjaf96.github.io/games-monorepo/',
);

void main() async {
  await bootstrapGame(config: blockoConfig);
  final startupLocale = Get.find<SettingsController>().locale.value;
  runApp(
    GetMaterialApp(
      title: 'Blocko',
      translations: BlockoTranslations(),
      locale: Locale(startupLocale),
      fallbackLocale: const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('ar')],
      theme: GameTheme.build(GameTheme.blocko),
      getPages: AppPages.pages,
      initialRoute: AppRoutes.splash,
    ),
  );
}
