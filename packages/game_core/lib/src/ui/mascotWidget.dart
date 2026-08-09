import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'mascotMood.dart';

/// Displays a game's mascot in one of its three states. Each app ships its
/// own `assets/mascots/<game>_<mood>.svg` — this widget is shared, the art
/// is not (GAME_IDEAS.md § "Ready mascots").
class MascotWidget extends StatelessWidget {
  const MascotWidget({
    super.key,
    this.mood = MascotMood.idle,
    required this.game,
    this.size = 90,
  });

  final MascotMood mood;
  final String game;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/mascots/${game}_${mood.name}.svg',
      width: size,
      height: size,
    );
  }
}
