# Game Design & Art Resources

Curated pointers for deeper research beyond the installed skills
(`game-feel`, `game-ui-ux`, `puzzle`, `art-direction-and-readability`,
`onboarding-and-teaching` — see `.agents/skills/`). Those skills carry
actionable, engine-neutral technique; the three repos below are link
collections, not skill files, so their value is as a reading list —
this doc pulls out what's actually worth opening rather than the raw
link dump.

## Design fundamentals & postmortems

Source: [Roobyx/awesome-game-design](https://github.com/Roobyx/awesome-game-design)

Read when questioning whether a mechanic is fun or a system is
balanced, not for API-level how-to:
- **Game Maker's Toolkit** (Mark Brown) — video essays on why specific
  mechanics work; the closest thing to a general design-critique habit.
- **Lost Garden** (Daniel Cook) — long-form design theory blog.
- **A Theory of Fun** (Raph Koster) — the "fun = pattern recognition"
  framing behind difficulty/reward pacing.
- **"The Door Problem"** (Liz England) — short essay on what a designer's
  job actually covers; good onboarding read for scoping a feature.
- Postmortems worth skimming for a casual/puzzle game specifically:
  **The Binding of Isaac**, **Super Meat Boy**, **Fez** — all
  small-team, tight-loop games closer to our scale than AAA
  postmortems (Diablo/BioShock/GTA) also in that list.

## Mobile & casual-game practice

Source: [FronkonGames/Awesome-Gamedev](https://github.com/FronkonGames/Awesome-Gamedev)

- **Game UI Database** — searchable reference of real shipped game
  interfaces, browsable by screen type (HUD, settings, store, daily
  reward, etc.) — useful to sanity-check a new dialog/screen against
  how other games solved the same layout problem.
- **"Rules for developing addictive mobile games"** and F2P
  mechanics/psychology write-ups — relevant background for the
  economy/daily-reward/rewarded-ad systems already in `game_core`, not
  a license to add dark patterns.
- **"Instant Game Feel tutorial: Secrets of Springs"** and
  "juicing cameras with math" — spring-based (not just linear-eased)
  motion; a option to revisit if a future animation still reads as
  stiff after the standard `flutter_animate` easing curves.

## Color & palette

Source: [Siilwyn/awesome-pixel-art](https://github.com/Siilwyn/awesome-pixel-art)

Stated principles worth keeping in mind for any future palette work
(this is exactly the kind of decision behind Blocko's piece-color and
`GameTheme` choices earlier this project):
- **A small, deliberate palette reads better than a large one** — Minit
  ships an entire game on two colors and still stays legible; more
  hues isn't automatically more premium.
- **Palette tone sets emotional register** — soft pastels read as warm
  /handmade (Yoshi's Island), saturated vibrant hues read as
  energetic/arcade (FEZ). Pick the tone on purpose per game, not by
  default.
- **[Lospec](https://lospec.com/palette-list)** — a large library of
  named, tagged color palettes with hex values; a fast way to
  pressure-test a proposed palette against existing, proven ones
  before committing hex codes to `Pal`/`GameTheme`.
- Palette construction is usually reasoned in **HSL**, not raw hex —
  keep hue constant and vary saturation/lightness for a family of
  related tones (this is what `surfaceTone()`/`GameTheme.darken()`
  already do programmatically).

## When to actually open these vs. use the installed skills

- Choosing/tuning colors, a new screen's layout, or feel/juice on a
  specific interaction → use the `art-direction-and-readability`,
  `game-ui-ux`, or `game-feel` skill first; they're actionable and
  already loaded.
- Questioning whether a whole feature/mechanic is fun, second-guessing
  a monetization pattern, or wanting outside inspiration beyond this
  project's own conventions → come back to this doc.
