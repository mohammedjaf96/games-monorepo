import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../../features/game/bindings/gameBinding.dart';
import '../../features/game/views/pages/gamePage.dart';
import '../../features/home/bindings/homeBinding.dart';
import '../../features/home/views/pages/homePage.dart';
import '../config/dashyCatalog.dart';
import 'appRoutes.dart';

/// GetX route table for Dashy (GAME_IDEAS.md §5.3/§5.9).
class AppPages {
  static final List<GetPage> pages = [
    // SplashController is put in main.dart before runApp, not via a page
    // binding: its mascot/dots keep animating during the Home transition's
    // outgoing frames, and a route-linked binding gets disposed by
    // Get.offAllNamed before those frames finish, crashing GetView<SplashController>.
    GetPage(name: AppRoutes.splash, page: () => const SplashPage()),
    GetPage(name: AppRoutes.home, page: () => const HomePage(), binding: HomeBinding()),
    GetPage(name: AppRoutes.game, page: () => const GamePage(), binding: GameBinding()),
    GetPage(
      name: AppRoutes.store,
      page: () => StorePage(catalog: dashyCatalog, primaryColor: GameTheme.dashy.primary),
    ),
    GetPage(name: AppRoutes.settings, page: () => const SettingsPage()),
  ];
}
