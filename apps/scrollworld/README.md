# scrollworld

A scroll-driven onboarding scene for **فحص**, on Flutter web.

```bash
cd apps/scrollworld
flutter run -d chrome          # or: flutter build web && serve build/web
```

## The trick, in one sentence

The page does not animate because time passed. It animates because the finger
moved:

```dart
progress = scroll.offset / scroll.position.maxScrollExtent;   // 0.0 … 1.0
```

Every painter reads that one number. Scroll down and the story advances;
scroll back up and it runs backwards frame for frame, because nothing anywhere
is driven by a clock. That reversibility is what makes it feel like the
elements are moving rather than the page — a conventional animation can only
be replayed, and people notice the difference even when they cannot name it.

## How the illusion is built

Two layers in a `Stack`:

| Layer | What it is |
|---|---|
| bottom | a pinned full-screen `CustomPaint` that **never scrolls** — only repaints |
| top | a `SingleChildScrollView` holding six screens of **empty space** |

So the finger scrolls a transparent void, and what appears to move is the
artwork behind it.

## The six acts

Defined once, in `SceneAct`, as fractions of the whole scroll — so a timing is
changed in one place rather than in every painter that depends on it.

| Act | Range | What happens |
|---|---|---|
| `warning` | 0.00–0.16 | a dark cabin, one amber check-engine lamp |
| `plugIn`  | 0.16–0.33 | the adapter slides in, seats, LED turns green |
| `pair`    | 0.33–0.49 | BLE rings, the phone appears, the link draws |
| `scan`    | 0.49–0.72 | the car turns; modules answer as the sweep passes |
| `faults`  | 0.72–0.88 | fault codes rise, coloured by severity |
| `verdict` | 0.88–1.00 | the health dial sweeps to 72 |

## No assets

No image sequence, no 3D engine, no Rive file. The car, the connector, the
warning glyph and the dial are vector maths — a few hundred bytes that scale to
any display and can be drawn *progressively*, which is what the scan act needs
and what no pre-rendered sequence can do. The three-quarter turn is a shear,
not a camera: at this size the difference is invisible.

Compare: the equivalent rendered-frames approach (the technique Apple's product
pages use) is 5–15 MB for one screen somebody sees once.

## Files

```
lib/
  main.dart                     app + forced RTL
  scene/
    scene_act.dart              the timeline, as data
    scene_controller.dart       scroll offset → progress
    scene_page.dart             the two layers, and the copy
    scene_caption.dart          per-act words, cross-faded
    scene_progress_rail.dart    six dots, tappable
    scene_palette.dart          colours
  painters/
    car_shape.dart              geometry and module positions
    scene_painter.dart          the whole scene, from one number
test/
  scene_timeline_test.dart      the timeline's silent failures, asserted
```

## Why the timeline is tested

None of its failures crash anything. A gap between two acts is a stretch where
the scene sits frozen; an overlap is two captions at once; an unclamped act is
a car that keeps rotating after its beat is over. Each looks like a design
decision, and each is invisible unless somebody scrolls slowly through that
exact seam.
