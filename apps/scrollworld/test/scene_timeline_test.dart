import 'package:flutter_test/flutter_test.dart';
import 'package:scrollworld/scene/scene_act.dart';
import 'package:scrollworld/scene/scene_controller.dart';
import 'package:scrollworld/scene/scene_page.dart';

/// The timeline, asserted — because its failures are all silent.
///
/// Nothing here can crash the app. A gap between two acts is a stretch of
/// scrolling where the scene sits frozen; an overlap is two captions on screen
/// at once; an unclamped act is a car that keeps rotating after its beat is
/// over. Every one of them looks like a design decision rather than a bug, and
/// every one is invisible unless somebody happens to scroll slowly through
/// that exact seam.
void main() {
  group('the acts tile the scroll', () {
    test('from zero to one, with no gap and no overlap', () {
      final acts = SceneAct.values;

      expect(acts.first.start, 0);
      expect(acts.last.end, 1);

      for (var index = 1; index < acts.length; index++) {
        expect(acts[index].start, acts[index - 1].end,
            reason: '${acts[index].name} does not begin where '
                '${acts[index - 1].name} ends');
      }
    });

    test('exactly one act holds any point on the scroll', () {
      for (var step = 0; step < 100; step++) {
        final progress = step / 100;
        final holding =
            SceneAct.values.where((act) => act.holds(progress)).toList();

        expect(holding, hasLength(1), reason: 'at $progress');
      }
    });

    test('every act has words', () {
      for (final act in SceneAct.values) {
        expect(ScenePage.captions.containsKey(act), isTrue, reason: act.name);
      }
    });
  });

  group('progress within an act', () {
    test('is clamped at both ends', () {
      const act = SceneAct.scan;

      expect(act.at(0), 0);
      expect(act.at(1), 1);
      expect(act.at(act.start), 0);
      expect(act.at(act.end), 1);
      expect(act.at((act.start + act.end) / 2), closeTo(0.5, 0.001));
    });

    test('captions fade at the seams rather than cutting', () {
      // Zero at both edges is what makes the cross-fade continuous. A caption
      // still at full opacity when its act ends is a hard cut, and a hard cut
      // turns a scroll story back into a slideshow.
      for (final act in SceneAct.values) {
        expect(act.opacityAt(act.start), 0, reason: act.name);
        expect(act.opacityAt(act.end), 0, reason: act.name);
        expect(act.opacityAt((act.start + act.end) / 2), 1, reason: act.name);
      }
    });
  });

  group('the controller', () {
    test('an unlaid-out scroll view does not poison the scene with NaN', () {
      // Before the first layout `maxScrollExtent` is zero. Dividing by it does
      // not throw — it silently makes every painter draw nothing, and leaves a
      // blank screen with no error anywhere to search for.
      final controller = SceneController();
      addTearDown(controller.onClose);

      controller.scrub();

      expect(controller.progress.value, 0);
      expect(controller.progress.value.isNaN, isFalse);
    });

    test('the scroll is long enough to read but not a chore', () {
      // Six acts over six screens. Taller does not add content; it only makes
      // the same story take longer, which is the commonest way this effect is
      // ruined.
      expect(SceneController.screensOfScroll, 6);
    });
  });
}
