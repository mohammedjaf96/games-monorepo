import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../../features/game/bindings/gameBinding.dart';
import '../../features/game/views/pages/gamePage.dart';
import '../../features/home/bindings/homeBinding.dart';
import '../../features/home/views/pages/homePage.dart';
import '../config/mergoCatalog.dart';
import '../config/mergoSplash.dart';
import 'appRoutes.dart';

/// GetX route table for Mergo (GAME_IDEAS.md §6.3/§6.9).
class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: BindingsBuilder(() => Get.put(SplashController(mergoSplashConfig), permanent: true)),
    ),
    GetPage(name: AppRoutes.home, page: () => const HomePage(), binding: HomeBinding()),
    GetPage(name: AppRoutes.game, page: () => const GamePage(), binding: GameBinding()),
    GetPage(
      name: AppRoutes.store,
      page: () => StorePage(catalog: mergoCatalog, primaryColor: GameTheme.mergo.primary),
    ),
    GetPage(name: AppRoutes.settings, page: () => const SettingsPage()),
  ];
}
