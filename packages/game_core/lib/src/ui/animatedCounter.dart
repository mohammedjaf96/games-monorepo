import 'package:flutter/widgets.dart';

/// Rolls smoothly from its previous displayed value to [value] instead of
/// snapping instantly (GAME_IDEAS.md §3.8-c: "coins and points increment
/// with a gradual counter animation rather than jumping suddenly").
class AnimatedCounter extends StatelessWidget {
  const AnimatedCounter({
    super.key,
    required this.value,
    required this.style,
    this.duration = const Duration(milliseconds: 400),
    this.prefix = '',
    this.suffix = '',
  });

  final int value;
  final TextStyle style;
  final Duration duration;
  final String prefix;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: value, end: value),
      duration: duration,
      curve: Curves.easeOut,
      builder: (context, animatedValue, child) => Text('$prefix$animatedValue$suffix', style: style),
    );
  }
}
