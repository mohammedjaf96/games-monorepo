# Game Feel / Juice Checklist

This repo is not a single game — it's an ongoing platform. Blocko, Dashy, and
Mergo were the first three; more will be added over time. Every "juice" /
visual-feedback technique learned and applied to these three is a **standing
requirement for every future game**, not a one-off decoration. When a new game
is added, walk this checklist before considering it done, and apply each item
that has a reusable widget by importing it from `game_core` — do not
reimplement it locally.

## Reusable — import from `game_core`, do not reimplement

| Technique | Widget/class | Typical trigger |
|---|---|---|
| Screen shake | `ShakeWidget` | Big combo, game over, milestone — increment an `RxInt shakeTrigger` on the controller and wrap the page's root `Stack` in `Obx(() => ShakeWidget(trigger: ...))`. |
| Rolling number counter | `AnimatedCounter` | Any score/distance/coins display — replace a plain `Text` with `AnimatedCounter(value: ..., style: ...)`. |
| Floating "+N" / combo text | `FloatingScoreText` + `FloatingScoreTextOverlay` | Any scoring event — keep an `RxList<FloatingScoreText>` on the controller, add an entry with a unique id, auto-remove it after ~1.1s, render via `FloatingScoreTextOverlay(entries: ...)` positioned near the top of the screen. |
| Particle burst | `ParticleBurst` + `ParticleBurstOverlay` | Clears, merges, landings, coin pickups — same `RxList` + auto-remove pattern as floating text. |
| First-launch tutorial | `HowToPlayDialog` | Show once per install from `GameController.onInit()`: check a `tutorialSeen<Game>` flag via `KeyValueStore`/`HiveService.settingsBox`, set it before showing, open via `Get.dialog` inside `WidgetsBinding.instance.addPostFrameCallback`. If the game has continuous simulation (e.g. a Flame engine), pause it before showing and resume it in `onGotIt`. Add `tutorialGoal`/`tutorialControls` keys to the game's own translations (one short sentence each) — a new game is not done if a first-time player can't tell what to do. |

## Per-game (no shared widget yet — reimplement the same pattern, same style)

- **Squash & stretch** on any jump/land/impact-style motion (see
  `apps/dashy/lib/features/game/flame/dashyPlayer.dart`): stretch along the
  direction of travel while airborne, squash on impact, ease back to `(1, 1)`.
- **Motion trail** behind a fast-moving object once speed is a core mechanic
  (see `apps/dashy/lib/features/game/flame/dashyTrail.dart` +
  `dashyTrailSample.dart`): sample recent positions on a timer, age and fade
  them, remove past a max age. Length/spread should scale with current speed.
- **Multi-layer parallax background** for any side-scrolling/endless game
  (see `dashySkyComponent.dart`, `dashyCloudLayer.dart`, `dashyHillLayer.dart`):
  at least 2–3 layers, each scrolling at a different fraction of world speed,
  farthest layer slowest.
- **Speed lines / intensity effects** that only appear past a threshold and
  scale with a game's "intensity" stat (see `dashySpeedLines.dart`) — don't
  show constant visual noise at rest; earn the effect at higher stakes/speed.
- **Home screen entrance choreography** (see any `apps/*/lib/features/home/views/pages/homePage.dart`):
  - Top bar (wallet/currency): fade + slide down.
  - Logo/title: `scale` pop with `Curves.elasticOut`.
  - Mascot: continuous idle bounce — `.animate(onPlay: (c) => c.repeat(reverse: true)).moveY(begin: 0, end: -8..-10, duration: ~700ms)`.
  - Primary CTA button: fade + scale in, delayed after the logo.
  - Icon row (shop/chest/gear/etc.): staggered fade + slide-up, ~50-60ms delay between each.
  - All via `flutter_animate`'s `.animate()` chained directly on the widget inline in `build()` — never extract a helper method (violates the "view files contain nothing outside `build()`" rule in `CODE_STANDARDS.md`).

## Mandatory: light/dark theme support

Every game must support both light and dark mode, defaulting to the device's
own system setting, with a System/Light/Dark override in Settings
(`ThemeModeRow`, wired through `SettingsController.themeMode` +
`Get.changeThemeMode`). This is not just a background swap:

- `main.dart` must pass **both** `theme: GameTheme.light(palette)` and
  `darkTheme: GameTheme.dark(palette)`, plus `themeMode:` read from
  `SettingsController` at startup — see any existing `apps/*/lib/main.dart`.
- Ink/border color (`OutlineColor.color`) and default text color
  (`AppText.*`'s color when omitted) already flip automatically — don't hand
  them a hardcoded color unless it's an intentional contrast pairing (e.g.
  white text on a permanently-colored chip).
- Any **neutral chrome** fill (dialog panels, cards, board wells, empty
  cells, inactive chips — anything currently `Pal.cream`/`Colors.white`/a
  pastel hex) must be wrapped in `surfaceTone(...)` so it darkens in dark
  mode: `fill: surfaceTone(Pal.cream)`.
- **Brand/accent colors stay constant** in both modes — button fills
  (`Pal.green`/`Pal.yellow`/etc.), gameplay piece/tile colors, and a Flame
  game's own world rendering (sky, ground, obstacles) are not surfaces and
  must not be darkened; changing them would hurt gameplay recognizability
  for no benefit.
- `stickerDecoration(...)`'s `outline` and `AppText.*`'s `color` are both
  optional now — only pass them explicitly when you need something other
  than the current theme's ink color.

## Adding a new game: minimum bar

A new game is not "juice complete" until it has, at minimum:
1. Screen shake on its biggest positive/negative moment.
2. Animated counters for every numeric HUD value.
3. Floating score/reward text on every scoring event.
4. Particle burst on every clear/merge/collect-style event.
5. Squash & stretch (or an equivalent impact animation) on its core input gesture.
6. A fully choreographed Home screen entrance (not a static snap-in).
7. If the game has continuous motion/speed as a mechanic: a trail, parallax
   background, and speed-line-style intensity effect, following the Dashy
   pattern above.
8. A `HowToPlayDialog` shown once on first launch, stating the goal and the
   controls in one short sentence each — a player should never have to guess
   what the game wants from them.
9. Full light/dark theme support, following the "Mandatory: light/dark theme
   support" section above — defaulting to system, every neutral surface
   wrapped in `surfaceTone(...)`, not just the scaffold background.

If a technique doesn't fit a given game's genre, say so explicitly rather than
skipping it silently — don't leave a new game feeling flatter than the first
three by omission.
