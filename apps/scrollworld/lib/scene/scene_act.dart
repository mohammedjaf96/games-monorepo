/// The six beats of the story, and where each one sits on the scroll.
///
/// ## Why the timeline is data rather than a chain of `if`s
///
/// Every painter and every caption asks the same question — "how far into *my*
/// act are we?" — and answering it from scattered magic numbers is how a scene
/// drifts: you shorten one act, the caption still fades on the old boundary,
/// and the mismatch is only visible if you happen to scroll slowly through
/// that exact seam.
///
/// [start] and [end] are fractions of the whole scroll, 0 to 1.
enum SceneAct {
  /// A dark cabin and one amber light. The question the app exists to answer.
  warning(0.00, 0.16),

  /// The adapter slides into the port under the wheel and seats with a click.
  plugIn(0.16, 0.33),

  /// It finds the phone. Rings go out, the link draws itself.
  pair(0.33, 0.49),

  /// The sweep. The car draws itself and the modules answer one by one.
  scan(0.49, 0.72),

  /// What it found, as codes with a severity you can read across a room.
  faults(0.72, 0.88),

  /// The score, and the way in.
  verdict(0.88, 1.00);

  const SceneAct(this.start, this.end);

  final double start;
  final double end;

  /// How far through this act [progress] is, clamped to 0…1.
  ///
  /// Clamped rather than left to run negative or past one, because every
  /// painter multiplies by it. An unclamped value does not look like an error;
  /// it looks like a car that keeps rotating after the act is over.
  double at(double progress) =>
      ((progress - start) / (end - start)).clamp(0.0, 1.0);

  /// Whether this act is the one on screen right now.
  bool holds(double progress) => progress >= start && progress < end;

  /// Fades in over the first fifth of the act and out over the last fifth.
  ///
  /// The captions cross-fade rather than cut. A cut makes the scroll feel like
  /// a slideshow with pages; a fade keeps it feeling like one continuous move
  /// that the finger is driving.
  double opacityAt(double progress) {
    final t = at(progress);
    if (t <= 0 || t >= 1) return 0;
    if (t < 0.2) return t / 0.2;
    if (t > 0.8) return (1 - t) / 0.2;
    return 1;
  }
}
