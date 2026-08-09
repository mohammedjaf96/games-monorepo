import 'package:flutter/widgets.dart';

import '../dailyReward/dailyRewardDialog.dart';

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
    this.dailyRewardDialogBuilder = defaultDailyRewardDialogBuilder,
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

  /// Builds the dialog `SplashController` auto-shows on launch when a daily
  /// reward is waiting — lets a game swap in its own styled dialog instead
  /// of the shared cutesy one. Defaults to the shared `DailyRewardDialog`.
  final Widget Function() dailyRewardDialogBuilder;

  static Widget defaultDailyRewardDialogBuilder() => const DailyRewardDialog();
}
