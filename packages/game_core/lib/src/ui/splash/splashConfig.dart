import 'package:flutter/widgets.dart';

/// Per-app splash screen configuration (GAME_IDEAS.md §3.13.1).
class SplashConfig {
  const SplashConfig({
    required this.bgColor,
    required this.bgColorEnd,
    required this.logoText,
    required this.game,
    required this.homeRoute,
    this.loaderColor = const Color(0xFFFFFFFF),
    this.bgmAssetPath,
  });

  final Color bgColor;
  final Color bgColorEnd;
  final String logoText;
  final String game;
  final String homeRoute;
  final Color loaderColor;

  /// Asset path (relative to the app's own bundle) for the looping BGM
  /// track, e.g. `audio/bgm/theme.wav`. Null means no BGM is shipped yet.
  final String? bgmAssetPath;
}
