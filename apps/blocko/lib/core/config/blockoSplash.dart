import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';

import '../routing/appRoutes.dart';

/// Blocko's splash screen: the "Neon Drop" night gradient, matching the
/// gameplay screen instead of the old blue-sky theme.
final SplashConfig blockoSplashConfig = SplashConfig(
  bgColor: const Color(0xFF1A0B33),
  bgColorEnd: const Color(0xFF050308),
  logoText: 'BLOCKO',
  game: 'blocko',
  homeRoute: AppRoutes.home,
  loaderColor: const Color(0xFFCCFF00),
  bgmAssetPath: 'audio/bgm/theme.wav',
);
