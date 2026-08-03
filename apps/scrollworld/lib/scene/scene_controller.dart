import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

/// Turns the scroll offset into a number between 0 and 1.
///
/// ## The whole trick, in one sentence
///
/// The page does not animate *because* time passed. It animates because the
/// finger moved: [progress] is the scroll offset divided by the scrollable
/// height, and every painter in the scene reads it. Scroll down and the story
/// advances; scroll back up and it runs backwards, frame for frame, because
/// nothing anywhere is driven by a clock.
///
/// That reversibility is what makes it feel like the elements are moving
/// rather than the page. A conventional animation cannot be dragged backwards
/// — it can only be replayed — and people notice the difference immediately
/// even when they cannot name it.
class SceneController extends GetxController {
  final ScrollController scroll = ScrollController();

  /// 0 at the top, 1 at the bottom. Read by every painter.
  final RxDouble progress = 0.0.obs;

  /// How many screens tall the scrollable is.
  ///
  /// Six acts over six screens: roughly one screen of finger travel per beat,
  /// which is slow enough to read a caption and fast enough not to feel like
  /// work. Making it taller does not add content — it only makes the same
  /// story take longer, which is the most common way this effect is ruined.
  static const double screensOfScroll = 6;

  @override
  void onInit() {
    super.onInit();
    scroll.addListener(scrub);
  }

  /// Reads the offset and normalises it.
  ///
  /// Guards the empty case: before the first layout `maxScrollExtent` is zero,
  /// and dividing by it yields NaN — which does not throw, it silently paints
  /// nothing and leaves you looking at a blank screen wondering what broke.
  void scrub() {
    if (!scroll.hasClients) return;

    final span = scroll.position.maxScrollExtent;
    if (span <= 0) return;

    progress.value = (scroll.offset / span).clamp(0.0, 1.0);
  }

  /// Runs the whole story without touching anything — for a look, or a demo.
  Future<void> playThrough() async {
    if (!scroll.hasClients) return;

    await scroll.animateTo(
      scroll.position.maxScrollExtent,
      duration: const Duration(seconds: 9),
      curve: Curves.easeInOut,
    );
  }

  Future<void> restart() async {
    if (!scroll.hasClients) return;

    await scroll.animateTo(
      0,
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void onClose() {
    scroll.removeListener(scrub);
    scroll.dispose();
    super.onClose();
  }
}
