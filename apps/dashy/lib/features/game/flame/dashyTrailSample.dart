/// One historical player-position sample used to render Dashy's motion
/// trail (GAME_IDEAS.md §5.8): the position at capture time plus how much
/// time has elapsed since, which the trail uses to fade and displace it.
class DashyTrailSample {
  DashyTrailSample({required this.x, required this.y, required this.age});

  final double x;
  final double y;
  double age;
}
