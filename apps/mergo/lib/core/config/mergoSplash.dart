import 'package:game_core/game_core.dart';

import '../routing/appRoutes.dart';

/// Mergo's splash screen: turquoise gradient (GAME_IDEAS.md §3.13.3).
final SplashConfig mergoSplashConfig = SplashConfig(
  bgColor: GameTheme.mergo.splashStart,
  bgColorEnd: GameTheme.mergo.splashEnd,
  logoText: 'MERGO',
  game: 'mergo',
  homeRoute: AppRoutes.home,
);
