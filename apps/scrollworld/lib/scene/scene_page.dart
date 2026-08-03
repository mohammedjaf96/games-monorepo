import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../painters/scene_painter.dart';
import 'scene_act.dart';
import 'scene_caption.dart';
import 'scene_controller.dart';
import 'scene_palette.dart';
import 'scene_progress_rail.dart';

/// The scroll-driven onboarding scene.
///
/// ## How the "the page does not move" illusion is built
///
/// Two layers. Underneath, a full-screen [CustomPaint] that never scrolls —
/// it is pinned, and only its *painting* changes. On top, a [SingleChildScrollView]
/// holding nothing but empty space six screens tall, which exists purely to
/// generate a scroll offset.
///
/// So the finger scrolls a transparent void, and what it appears to move is
/// the artwork behind it. That is the whole effect: not one line of it is a
/// scroll animation in the usual sense, and every frame is a function of the
/// offset alone.
class ScenePage extends GetView<SceneController> {
  const ScenePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScenePalette.night,
      body: Stack(
        children: [
          // The scene. Pinned, repainted, never moved.
          Positioned.fill(
            child: RepaintBoundary(
              child: Obx(() => CustomPaint(
                    painter: ScenePainter(controller.progress.value),
                    size: Size.infinite,
                  )),
            ),
          ),

          // The captions ride above the artwork, in the lower third where they
          // do not cover the car.
          Positioned.fill(
            child: IgnorePointer(
              child: Obx(() => Align(
                    alignment: const Alignment(0, 0.62),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          for (final entry in captions.entries)
                            SceneCaption(
                              act: entry.key,
                              progress: controller.progress.value,
                              headline: entry.value.$1,
                              body: entry.value.$2,
                            ),
                        ],
                      ),
                    ),
                  )),
            ),
          ),

          // The void that produces the offset.
          Positioned.fill(
            child: SingleChildScrollView(
              controller: controller.scroll,
              physics: const ClampingScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height *
                    SceneController.screensOfScroll,
              ),
            ),
          ),

          const Positioned(top: 0, bottom: 0, left: 16, child: SceneProgressRail()),

          Positioned(
            left: 0,
            right: 0,
            bottom: 26,
            child: IgnorePointer(
              ignoring: false,
              child: Obx(() => SceneFooter(progress: controller.progress.value)),
            ),
          ),
        ],
      ),
    );
  }

  /// One headline and one line of body per act.
  ///
  /// The copy is the product's own argument, in order: you have a warning and
  /// no explanation → here is the thing that reads it → it finds your phone →
  /// it asks every module → here is what is wrong → here is how bad it is.
  static const Map<SceneAct, (String, String)> captions = {
    SceneAct.warning: (
      'ضوء أشعل في لوحتك',
      'ولا أحد يعرف لماذا — لا أنت، ولا الميكانيكي قبل أن يفتح.',
    ),
    SceneAct.plugIn: (
      'وصّل الجهاز',
      'منفذ تحت المقود، موجود في كل سيارة بعد ٢٠٠٨.',
    ),
    SceneAct.pair: (
      'يجد هاتفك',
      'بلوتوث، بلا أسلاك وبلا إعدادات.',
    ),
    SceneAct.scan: (
      'يسأل كل وحدة',
      'المحرك، الناقل، المكابح، الوسائد — واحدة واحدة.',
    ),
    SceneAct.faults: (
      'ويقول لك الحقيقة',
      'أكواد الأعطال بلغتك، لا بالإنجليزية ولا بالأرقام وحدها.',
    ),
    SceneAct.verdict: (
      'وكم تساوي فعلاً',
      'درجة صحة واحدة تختصر كل ما وجده.',
    ),
  };
}

/// The hint at the bottom: scroll, then the way in.
///
/// A scroll-driven scene has one failure mode above all others — the person
/// does not realise they are supposed to scroll, and sits looking at a still
/// image deciding the app is broken. The hint is not decoration; it is the
/// instruction the whole thing depends on.
class SceneFooter extends GetView<SceneController> {
  const SceneFooter({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final atEnd = progress > 0.97;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 320),
      child: atEnd
          ? Column(
              key: const ValueKey('cta'),
              mainAxisSize: MainAxisSize.min,
              children: [
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: ScenePalette.brand,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('ابدأ الفحص',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: controller.restart,
                  child: const Text('شاهدها مرة أخرى',
                      style: TextStyle(color: ScenePalette.muted)),
                ),
              ],
            )
          : Column(
              key: const ValueKey('hint'),
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('اسحب للأسفل',
                    style: TextStyle(
                      color: ScenePalette.muted
                          .withValues(alpha: 0.6 * (1 - progress * 3).clamp(0.0, 1.0)),
                      fontSize: 13,
                    )),
                const SizedBox(height: 6),
                Icon(Icons.keyboard_arrow_down,
                    color: ScenePalette.muted.withValues(
                        alpha: 0.6 * (1 - progress * 3).clamp(0.0, 1.0))),
              ],
            ),
    );
  }
}
