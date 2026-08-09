import 'dart:math';

import 'package:flutter/widgets.dart';

/// Wraps [child] and plays a short decaying screen-shake whenever [trigger]
/// changes value — increment a counter in the controller to fire one
/// (GAME_IDEAS.md §3.8-c: "Screen shake, light, on big events"). Built on
/// [TweenAnimationBuilder] so no hand-rolled animation controller/State is needed.
class ShakeWidget extends StatelessWidget {
  const ShakeWidget({
    super.key,
    required this.trigger,
    required this.child,
    this.amplitude = 10,
    this.duration = const Duration(milliseconds: 400),
  });

  final int trigger;
  final Widget child;
  final double amplitude;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(trigger),
      tween: Tween(begin: trigger == 0 ? 0.0 : 1.0, end: 0.0),
      duration: duration,
      curve: Curves.easeOut,
      builder: (context, decay, builtChild) {
        final wobble = sin(decay * pi * 8) * decay * amplitude;
        return Transform.translate(offset: Offset(wobble, 0), child: builtChild);
      },
      child: child,
    );
  }
}
