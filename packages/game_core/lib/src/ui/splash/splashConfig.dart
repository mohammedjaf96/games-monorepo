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
  });

  final Color bgColor;
  final Color bgColorEnd;
  final String logoText;
  final String game;
  final String homeRoute;
  final Color loaderColor;
}
