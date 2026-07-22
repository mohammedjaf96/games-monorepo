# Release TODO

Everything in this repo that is genuinely blocked on external accounts,
credentials, real art, or a live Flutter toolchain — none of it could be
finished inside this session. Work through it before shipping to either
store. Grouped by what unblocks it.

## Blocked on a Flutter/Dart toolchain (do this first, locally)
- [ ] `melos bootstrap` (or `flutter pub get` in each app + `packages/game_core`)
      to resolve the dependencies added during this build (flame, flutter_svg,
      app_tracking_transparency, collection).
- [ ] `melos run analyze` / `flutter analyze` in each app — this code was
      never compiled (no Flutter SDK was available while building it). Fix
      whatever the analyzer flags.
- [ ] Run each app on a simulator/device and play a full round of each game
      (placement/clear, swipe/merge, jump/obstacles) before trusting the
      logic described in code review.

## Blocked on a Google AdMob account
- [ ] Create an AdMob account + one app entry per game.
- [ ] Replace the **test** ad unit IDs with real ones in each app's
      `GameConfig.adUnits` (currently `apps/<game>/lib/main.dart`).
- [ ] Replace the **test** AdMob App ID in:
      `apps/<game>/android/app/src/main/AndroidManifest.xml` and
      `apps/<game>/ios/Runner/Info.plist` (`GADApplicationIdentifier`).
- [ ] Re-verify the `SKAdNetworkItems` list in each `Info.plist` against
      Google's current published list (https://support.google.com/admob/answer/9995322)
      — it was filled in from a commonly published version, not fetched live.

## Blocked on real art/audio assets
- [ ] Cosmetic preview images referenced in `core/config/*Catalog.dart`
      (e.g. `assets/cosmetics/character_robot.png`) don't exist yet —
      `CosmeticCard` falls back to a rarity-colored icon. Add real art and
      register the folder in each app's `pubspec.yaml` assets.
- [ ] Background music (BGM) files — `AudioService.playBgm()` silently
      no-ops without one. Add a track and pass its asset path in
      `SettingsController.toggleMusic()`.
- [ ] App icons (all three apps still ship Flutter's default icon). Add
      real 1024x1024 source art and run `flutter_launcher_icons`.
- [ ] Store feature graphics / screenshots for both store listings.

## Blocked on store/developer accounts
- [ ] Android signing keystore per app (`android/key.properties`, never
      commit the `.jks`) — see GAME_IDEAS.md §7.1.2.
- [ ] iOS signing team/certificates in Xcode, and a distinct bundle ID
      already set (`com.mgames.<game>`) — just needs a real Apple Developer
      account attached.
- [ ] Host `PRIVACY_POLICY.md` at a public URL (GitHub Pages works) and
      fill in the `[FILL IN]` placeholders first. Put that URL in both
      store listings.
- [ ] Google Play: data-safety form, content rating questionnaire, ads
      declaration. App Store: App Privacy "nutrition label", ATT usage
      description review.

## Deferred by design (later phases, not required for MVP)
- [ ] Firebase Analytics — `AnalyticsService` is currently a `debugPrint`
      stub (GAME_IDEAS.md §3.7 explicitly allows this for MVP). Wire a real
      provider when ready.
- [ ] AppLovin MAX mediation (GAME_IDEAS.md Phase 6) — AdMob-only for now.
- [ ] Arabic localization of the iOS ATT prompt — currently English only
      in `Info.plist`; a full fix needs an `ar.lproj/InfoPlist.strings` file
      registered in each app's Xcode project (risky to hand-edit blind
      without Xcode open — left alone here).

## Known simplifications (not blockers, just worth knowing)
- Mergo's tile movement animates as a pop-in on value change, not a true
  slide tween (would need per-tile identity tracking across moves).
- Particle bursts on line-clear/merge are centered on the game screen, not
  positioned at the exact cleared cells (the controller is UI-geometry
  agnostic by design).
- Dashy's obstacle "passability guarantee" is time-based spacing that grows
  with speed, not a full jump-arc physics validation.
