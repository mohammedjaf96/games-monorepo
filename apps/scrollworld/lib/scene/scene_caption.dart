import 'package:flutter/material.dart';

import 'scene_act.dart';
import 'scene_palette.dart';

/// The words for one act, cross-fading with it.
///
/// Kept as a widget rather than painted into the canvas for one reason:
/// Arabic. Text laid out by the framework gets proper shaping, bidi and font
/// fallback; text drawn by hand into a painter gets whatever the default
/// resolution happens to give it, which for Arabic is often disconnected
/// letters. The picture is a painter's job, the language is not.
class SceneCaption extends StatelessWidget {
  const SceneCaption({
    super.key,
    required this.act,
    required this.progress,
    required this.headline,
    required this.body,
  });

  final SceneAct act;
  final double progress;
  final String headline;
  final String body;

  @override
  Widget build(BuildContext context) {
    final opacity = act.opacityAt(progress);
    if (opacity <= 0.01) return const SizedBox.shrink();

    // Rises a little as it fades in. Motion in the same direction as the
    // scroll, so the words feel carried by the finger rather than announced.
    final lift = (1 - opacity) * 18;

    return Opacity(
      opacity: opacity,
      child: Transform.translate(
        offset: Offset(0, lift),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              headline,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: ScenePalette.ink,
                fontSize: 27,
                height: 1.35,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              body,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: ScenePalette.muted,
                fontSize: 15,
                height: 1.7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
