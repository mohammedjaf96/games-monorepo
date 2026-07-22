# games-monorepo

Three ad-monetized casual mobile games built from one Flutter monorepo:

| App | Genre | Style |
|-----|-------|-------|
| **Blocko** | 8×8 block puzzle | Candy squishy |
| **Dashy** | one-tap endless runner | Clash-style HUD |
| **Mergo** | 2048-style merge | Clean + 3D hero |

Shared code lives in `packages/game_core` (ads, economy, store, daily rewards,
settings, theme, custom sticker-style UI, icons, audio). Each `apps/<game>` is an
independent Flutter app with its own bundle id and ships separately to the stores.

## Structure
```
packages/game_core/   shared code + assets (16 icons, 19 SFX)
apps/blocko|dashy|mergo/   independent apps (+ 3 mascot states each)
GAME_IDEAS.md         full build spec (give this to an AI coding model)
```

## Setup
```bash
dart pub global activate melos
melos bootstrap
```

## Build one app
```bash
cd apps/blocko
flutter build appbundle --release   # Android
flutter build ipa --release         # iOS
```

See `GAME_IDEAS.md` §7 / §7.1 for full build & publish steps.
