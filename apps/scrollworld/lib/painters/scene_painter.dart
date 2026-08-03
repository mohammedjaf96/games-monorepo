import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../scene/scene_act.dart';
import '../scene/scene_palette.dart';
import 'car_shape.dart';

/// The whole scene, painted once per frame from one number.
///
/// ## Why one painter and not six widgets
///
/// The acts overlap: the warning light is still fading while the adapter is
/// already sliding in, and the car keeps turning underneath the fault codes.
/// Six stacked widgets would each need to know the others' timings to avoid
/// popping, which is the same coupling with more moving parts. One painter
/// reading one [progress] has the timeline in front of it.
///
/// Nothing here allocates per frame beyond paths and paints, and nothing reads
/// a clock. Given the same progress it paints the same pixels — which is why
/// scrolling backwards is exact rather than approximate.
class ScenePainter extends CustomPainter {
  const ScenePainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    paintBackdrop(canvas, size);

    // The car is the spine of the scene: it appears in the plug-in act and
    // stays to the end, turning as the story goes on.
    final reveal = SceneAct.plugIn.at(progress);
    if (reveal > 0) paintCar(canvas, size, reveal);

    paintWarningLight(canvas, size);
    paintAdapter(canvas, size);
    paintPairing(canvas, size);
    paintScan(canvas, size);
    paintFaults(canvas, size);
    paintVerdict(canvas, size);
  }

  // ---- The cabin ---------------------------------------------------------

  /// A dark vignette that lifts as the diagnosis arrives.
  ///
  /// The scene literally gets lighter as it learns more. It is the cheapest
  /// possible way to say "this went from unknown to known", and it works
  /// without a word of copy.
  void paintBackdrop(Canvas canvas, Size size) {
    final lift = SceneAct.verdict.at(progress);
    final rect = Offset.zero & size;

    canvas.drawRect(
      rect,
      Paint()
        ..shader = ui.Gradient.radial(
          Offset(size.width * 0.5, size.height * 0.42),
          size.longestSide * (0.55 + 0.25 * lift),
          [
            Color.lerp(ScenePalette.deep, const Color(0xFF16203A), lift)!,
            ScenePalette.night,
          ],
        ),
    );
  }

  // ---- Act 1: the light nobody can explain -------------------------------

  void paintWarningLight(Canvas canvas, Size size) {
    // Bright through its own act, then down to an ember that stays lit until
    // the verdict finally puts it out.
    final own = SceneAct.warning.at(progress);
    final settled = 1 - 0.72 * SceneAct.plugIn.at(progress);
    final extinguish = 1 - SceneAct.verdict.at(progress);
    final strength = (own * settled * extinguish).clamp(0.0, 1.0);
    if (strength <= 0.01) return;

    // Rises with the act, then parks near the car's nose.
    final centre = Offset.lerp(
      Offset(size.width * 0.5, size.height * 0.46),
      Offset(size.width * 0.74, size.height * 0.34),
      SceneAct.plugIn.at(progress),
    )!;

    final scale = size.shortestSide * (0.10 - 0.045 * SceneAct.plugIn.at(progress));

    canvas.drawCircle(
      centre,
      scale * 1.6,
      Paint()
        ..color = ScenePalette.amber.withValues(alpha: 0.18 * strength)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, scale),
    );

    canvas.save();
    canvas.translate(centre.dx, centre.dy);
    canvas.scale(scale / 40);
    canvas.drawPath(
      engineGlyph(),
      Paint()..color = ScenePalette.amber.withValues(alpha: strength),
    );
    canvas.restore();
  }

  /// The check-engine glyph — a block with a fan and two studs.
  ///
  /// Recognisable at a glance and drawn rather than taken from an icon font,
  /// because the real dashboard symbol is what carries the meaning and no
  /// Material icon is it.
  Path engineGlyph() {
    final path = Path()
      ..moveTo(-26, -6)
      ..lineTo(-18, -6)
      ..lineTo(-18, -14)
      ..lineTo(-6, -14)
      ..lineTo(-2, -20)
      ..lineTo(12, -20)
      ..lineTo(12, -12)
      ..lineTo(20, -12)
      ..lineTo(20, -4)
      ..lineTo(26, -4)
      ..lineTo(26, 10)
      ..lineTo(20, 10)
      ..lineTo(20, 16)
      ..lineTo(-2, 16)
      ..lineTo(-8, 10)
      ..lineTo(-18, 10)
      ..lineTo(-18, 4)
      ..lineTo(-26, 4)
      ..close();

    return path;
  }

  // ---- The car ------------------------------------------------------------

  /// Draws the car, turning as the scroll goes on.
  ///
  /// During the plug-in act the outline draws itself stroke-first. That is the
  /// one thing a pre-rendered sequence cannot do, and it is what makes the car
  /// feel constructed by the app rather than pasted onto it.
  void paintCar(Canvas canvas, Size size, double reveal) {
    final lean = SceneAct.scan.at(progress) * 0.7 +
        SceneAct.faults.at(progress) * 0.3;

    final box = Size(size.width * 0.78, size.width * 0.78 * 0.46);
    final origin = Offset(
      (size.width - box.width) / 2,
      size.height * 0.40,
    );

    canvas.save();
    canvas.translate(origin.dx + box.width / 2, origin.dy + box.height / 2);
    canvas.transform(CarShape.tilt(lean).storage);
    canvas.translate(-box.width / 2, -box.height / 2);

    final matrix = Matrix4.diagonal3Values(box.width, box.height, 1);
    final body = CarShape.outline().transform(matrix.storage);

    // Drawn in two passes: a wide blurred stroke for the glow, a thin one for
    // the edge. One paint with a blur alone reads as fog rather than neon.
    final edge = ScenePalette.ink.withValues(alpha: 0.10 + 0.55 * reveal);

    canvas.drawPath(body, ScenePalette.glow(ScenePalette.cyan.withValues(
        alpha: 0.22 * reveal), 6, 12));
    canvas.drawPath(body, ScenePalette.stroke(edge, 1.6));

    for (final wheel in [CarShape.frontWheel, CarShape.rearWheel]) {
      canvas.drawCircle(
        Offset(wheel.dx * box.width, wheel.dy * box.height),
        CarShape.wheelRadius * box.height * 2.1,
        ScenePalette.stroke(edge, 1.6),
      );
    }

    paintModules(canvas, box);
    canvas.restore();
  }

  /// The control units, lighting one at a time as the sweep passes them.
  void paintModules(Canvas canvas, Size box) {
    final scanning = SceneAct.scan.at(progress);
    if (scanning <= 0) return;

    final modules = CarShape.modules;

    for (var index = 0; index < modules.length; index++) {
      final module = modules[index];

      // Staggered by position along the car, not by list order, so the sweep
      // and the answers line up. Answering in list order while a line moves
      // across the screen is the detail that makes the whole thing read as a
      // canned animation.
      final due = 0.15 + module.at.dx * 0.7;
      final lit = ((scanning - due) / 0.18).clamp(0.0, 1.0);
      if (lit <= 0) continue;

      final at = Offset(module.at.dx * box.width, module.at.dy * box.height);
      final colour = index == 0 ? ScenePalette.amber : ScenePalette.good;

      canvas.drawCircle(at, 12 * lit,
          Paint()..color = colour.withValues(alpha: 0.16 * lit));
      canvas.drawCircle(at, 3.4, Paint()..color = colour.withValues(alpha: lit));
      canvas.drawCircle(at, 8 * lit, ScenePalette.stroke(
          colour.withValues(alpha: 0.55 * lit), 1.2));

      label(canvas, module.code, at + const Offset(0, -18), colour, lit, 10);
    }
  }

  // ---- Act 2: the adapter -------------------------------------------------

  void paintAdapter(Canvas canvas, Size size) {
    final t = SceneAct.plugIn.at(progress);
    if (t <= 0) return;

    // Slides in from the right, seats, and then stays put for the rest.
    final travel = Curves.easeOutCubic.transform(math.min(t / 0.7, 1));
    final seated = t > 0.7;

    final target = Offset(size.width * 0.5, size.height * 0.62);
    final at = Offset.lerp(
        Offset(size.width * 1.15, size.height * 0.62), target, travel)!;

    final body = RRect.fromRectAndRadius(
      Rect.fromCenter(center: at, width: 62, height: 34),
      const Radius.circular(9),
    );

    canvas.drawRRect(body, ScenePalette.fill(const Color(0xFF1B2438)));
    canvas.drawRRect(body, ScenePalette.stroke(
        ScenePalette.ink.withValues(alpha: 0.35), 1.4));

    // The LED: red while it is on its way, green the instant it seats. The
    // click, said in colour.
    final led = seated ? ScenePalette.good : ScenePalette.danger;
    final pulse = seated ? 1.0 : 0.55;

    canvas.drawCircle(at + const Offset(18, 0), 9,
        Paint()..color = led.withValues(alpha: 0.25 * pulse)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7));
    canvas.drawCircle(at + const Offset(18, 0), 3.6,
        Paint()..color = led.withValues(alpha: pulse));

    // The pins.
    for (var index = 0; index < 4; index++) {
      final x = at.dx - 22 + index * 7.0;
      canvas.drawLine(Offset(x, at.dy + 17), Offset(x, at.dy + 23),
          ScenePalette.stroke(ScenePalette.faint, 2));
    }
  }

  // ---- Act 3: it finds the phone -----------------------------------------

  void paintPairing(Canvas canvas, Size size) {
    final t = SceneAct.pair.at(progress);
    if (t <= 0) return;

    final from = Offset(size.width * 0.5, size.height * 0.62);
    final fade = 1 - SceneAct.scan.at(progress);
    if (fade <= 0) return;

    // Three rings, each a third of a cycle apart, expanding and thinning.
    for (var ring = 0; ring < 3; ring++) {
      final phase = (t * 2.2 + ring / 3) % 1;
      final radius = size.shortestSide * 0.06 + phase * size.shortestSide * 0.30;

      canvas.drawCircle(
        from,
        radius,
        ScenePalette.stroke(
          ScenePalette.cyan.withValues(alpha: (1 - phase) * 0.45 * fade),
          1.6,
        ),
      );
    }

    // The phone, and the line that ties it to the adapter.
    final phoneAt = Offset(size.width * 0.5, size.height * 0.80);
    final arrive = Curves.easeOutBack.transform(math.min(t / 0.6, 1));

    final phone = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: phoneAt,
        width: 46 * arrive,
        height: 84 * arrive,
      ),
      const Radius.circular(10),
    );

    canvas.drawRRect(phone, ScenePalette.fill(
        ScenePalette.night.withValues(alpha: 0.9 * fade)));
    canvas.drawRRect(phone, ScenePalette.stroke(
        ScenePalette.cyan.withValues(alpha: 0.75 * fade * arrive), 1.6));

    if (t > 0.5) {
      final link = ((t - 0.5) / 0.3).clamp(0.0, 1.0);
      canvas.drawLine(
        from,
        Offset.lerp(from, phoneAt - const Offset(0, 44), link)!,
        ScenePalette.stroke(
            ScenePalette.cyan.withValues(alpha: 0.5 * fade), 1.2),
      );
    }
  }

  // ---- Act 4: the sweep ---------------------------------------------------

  void paintScan(Canvas canvas, Size size) {
    final t = SceneAct.scan.at(progress);
    if (t <= 0 || t >= 1) return;

    canvas.drawPath(
      CarShape.sweep(size, t),
      ScenePalette.stroke(
          ScenePalette.cyan.withValues(alpha: 0.5 * (1 - t)), 1.4),
    );
  }

  // ---- Act 5: what it found -----------------------------------------------

  void paintFaults(Canvas canvas, Size size) {
    final t = SceneAct.faults.at(progress);
    if (t <= 0) return;

    const codes = [
      ('P0420', ScenePalette.amber),
      ('P0301', ScenePalette.danger),
      ('U0100', ScenePalette.amber),
    ];

    final fade = 1 - SceneAct.verdict.at(progress) * 0.85;

    for (var index = 0; index < codes.length; index++) {
      final due = index * 0.22;
      final rise = ((t - due) / 0.35).clamp(0.0, 1.0);
      if (rise <= 0) continue;

      final eased = Curves.easeOutCubic.transform(rise);
      final at = Offset(
        size.width * (0.22 + index * 0.28),
        size.height * 0.74 - 30 * eased,
      );

      final chip = RRect.fromRectAndRadius(
        Rect.fromCenter(center: at, width: 86, height: 34),
        const Radius.circular(17),
      );

      canvas.drawRRect(chip, ScenePalette.fill(
          codes[index].$2.withValues(alpha: 0.14 * eased * fade)));
      canvas.drawRRect(chip, ScenePalette.stroke(
          codes[index].$2.withValues(alpha: 0.7 * eased * fade), 1.3));

      label(canvas, codes[index].$1, at, codes[index].$2,
          eased * fade, 14, centred: true);
    }
  }

  // ---- Act 6: the score ---------------------------------------------------

  void paintVerdict(Canvas canvas, Size size) {
    final t = SceneAct.verdict.at(progress);
    if (t <= 0) return;

    final centre = Offset(size.width * 0.5, size.height * 0.44);
    final radius = size.shortestSide * 0.20;
    final eased = Curves.easeOutCubic.transform(t);

    canvas.drawCircle(centre, radius, ScenePalette.stroke(
        ScenePalette.faint.withValues(alpha: 0.5 * eased), 8));

    // 72 out of 100 — a real-looking score, not a perfect one. A dial that
    // always lands on 100 tells the viewer the number is decorative.
    const target = 0.72;
    canvas.drawArc(
      Rect.fromCircle(center: centre, radius: radius),
      -math.pi / 2,
      math.pi * 2 * target * eased,
      false,
      ScenePalette.stroke(
        Color.lerp(ScenePalette.amber, ScenePalette.good, 0.45)!
            .withValues(alpha: eased),
        8,
      ),
    );

    label(canvas, '${(target * 100 * eased).round()}', centre,
        ScenePalette.ink, eased, 46, centred: true);
  }

  // ---- Text ---------------------------------------------------------------

  /// Paints one short string. Laid out per call, which is fine at this count.
  void label(Canvas canvas, String text, Offset at, Color colour,
      double opacity, double size,
      {bool centred = false}) {
    if (opacity <= 0.02) return;

    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: colour.withValues(alpha: opacity),
          fontSize: size,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    painter.paint(
      canvas,
      centred
          ? at - Offset(painter.width / 2, painter.height / 2)
          : at - Offset(painter.width / 2, painter.height),
    );
  }

  /// Repaints only when the scroll moved.
  ///
  /// The scene has no clock of its own, so a frame with the same progress is
  /// the same frame — and saying so keeps a still finger at zero repaints
  /// instead of sixty a second.
  @override
  bool shouldRepaint(ScenePainter old) => old.progress != progress;
}
