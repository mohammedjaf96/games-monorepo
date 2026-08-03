import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'scene_act.dart';
import 'scene_controller.dart';
import 'scene_palette.dart';

/// Six dots down the side, one per act, filling as the scroll goes.
///
/// ## Why a scroll-driven scene needs this specifically
///
/// The usual objection to scroll-jacking is fair: when the page stops moving
/// the way pages move, people lose their sense of where they are and how much
/// is left. A rail answers both without a word — six dots, two filled, means
/// a third of the way through and four beats to go.
///
/// It is also the escape hatch. Somebody who has seen this once can tap the
/// last dot and be at the button in a second.
class SceneProgressRail extends GetView<SceneController> {
  const SceneProgressRail({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(() {
        final progress = controller.progress.value;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final act in SceneAct.values) ...[
              GestureDetector(
                onTap: () => controller.scroll.animateTo(
                  controller.scroll.position.maxScrollExtent * act.start,
                  duration: const Duration(milliseconds: 520),
                  curve: Curves.easeOutCubic,
                ),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: act.holds(progress) ? 9 : 6,
                    height: act.holds(progress) ? 9 : 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: progress >= act.start
                          ? ScenePalette.brand
                          : ScenePalette.faint,
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      }),
    );
  }
}
