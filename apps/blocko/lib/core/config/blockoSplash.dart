import 'package:game_core/game_core.dart';

import '../routing/appRoutes.dart';

/// Blocko's splash screen: blue sky gradient (GAME_IDEAS.md §3.13.2).
final SplashConfig blockoSplashConfig = SplashConfig(
  bgColor: GameTheme.blocko.splashStart,
  bgColorEnd: GameTheme.blocko.splashEnd,
  logoText: 'BLOCKO',
  game: 'blocko',
  homeRoute: AppRoutes.home,
);
