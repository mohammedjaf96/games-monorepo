import 'package:game_core/game_core.dart';

import '../routing/appRoutes.dart';

/// Dashy's splash screen: dramatic purple gradient (GAME_IDEAS.md §3.13.3).
final SplashConfig dashySplashConfig = SplashConfig(
  bgColor: GameTheme.dashy.splashStart,
  bgColorEnd: GameTheme.dashy.splashEnd,
  logoText: 'DASHY',
  game: 'dashy',
  homeRoute: AppRoutes.home,
);
