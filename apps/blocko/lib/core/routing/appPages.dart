import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../../features/game/bindings/gameBinding.dart';
import '../../features/game/views/pages/gamePage.dart';
import '../../features/home/bindings/homeBinding.dart';
import '../../features/home/views/pages/homePage.dart';
import '../config/blockoCatalog.dart';
import '../config/blockoSplash.dart';
import 'appRoutes.dart';

/// GetX route table for Blocko (GAME_IDEAS.md §4.3/§4.10).
class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      // permanent: SplashPage's mascot/dots keep animating during the
      // Home transition's outgoing frames; a non-permanent binding gets
      // disposed by Get.offAllNamed before those frames finish, crashing
      // GetView<SplashController>.
      binding: BindingsBuilder(() => Get.put(SplashController(blockoSplashConfig), permanent: true)),
    ),
    GetPage(name: AppRoutes.home, page: () => const HomePage(), binding: HomeBinding()),
    GetPage(name: AppRoutes.game, page: () => const GamePage(), binding: GameBinding()),
    GetPage(
      name: AppRoutes.store,
      page: () => StorePage(catalog: blockoCatalog, primaryColor: GameTheme.blocko.primary),
    ),
    GetPage(name: AppRoutes.settings, page: () => const SettingsPage()),
  ];
}
