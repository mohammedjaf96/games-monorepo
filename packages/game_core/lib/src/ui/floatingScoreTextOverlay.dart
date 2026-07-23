import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/appText.dart';
import 'floatingScoreText.dart';

/// Renders each active [FloatingScoreText] drifting upward and fading out
/// (GAME_IDEAS.md §3.8-c). The caller owns the entry list's lifecycle (add
/// on reward, remove after ~1.1s).
class FloatingScoreTextOverlay extends StatelessWidget {
  const FloatingScoreTextOverlay({super.key, required this.entries});

  final List<FloatingScoreText> entries;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (final entry in entries)
            Text(entry.text, key: ValueKey(entry.id), style: AppText.title(color: entry.color))
                .animate()
                .moveY(begin: 0, end: -50, duration: 900.ms, curve: Curves.easeOut)
                .fadeOut(delay: 300.ms, duration: 600.ms),
        ],
      ),
    );
  }
}
