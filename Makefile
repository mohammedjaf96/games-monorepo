# Makefile — build & run Blocko, Dashy, Mergo (debug + production)
#
# Requires: Flutter SDK on PATH, `dart pub global activate melos` once.
# Run `make help` for the full target list.

SHELL := /bin/bash
APPS  := blocko dashy mergo

# NOTE: only the *aggregate*/static target names go in .PHONY. The
# per-app targets (build-debug-blocko, run-release-mergo, ...) are handled
# by the %-pattern rules below — listing a pattern-matched name here too
# would make GNU Make treat it as an empty explicit rule that shadows the
# pattern rule ("Nothing to be done for ..."), so don't add them back.
.PHONY: help bootstrap get analyze clean doctor devices \
	build-debug-all build-release-all bundle-release-all \
	build-ios-debug-all build-ios-release-all \
	build-all-debug build-all-release

help:
	@echo "games-monorepo — Blocko / Dashy / Mergo"
	@echo ""
	@echo "Setup:"
	@echo "  make bootstrap                 melos bootstrap (run this first, and after pulling changes)"
	@echo "  make get                       flutter pub get in every package/app"
	@echo "  make analyze                   flutter analyze in every package/app"
	@echo "  make doctor                    flutter doctor"
	@echo "  make devices                   list connected devices/emulators/simulators"
	@echo ""
	@echo "Build — Android APK (debug/local testing):"
	@echo "  make build-debug-blocko        (also: build-debug-dashy, build-debug-mergo)"
	@echo "  make build-debug-all           builds all three"
	@echo ""
	@echo "Build — Android APK (release/production):"
	@echo "  make build-release-blocko      (also: build-release-dashy, build-release-mergo)"
	@echo "  make build-release-all         builds all three"
	@echo ""
	@echo "Build — Android App Bundle (Play Store production upload):"
	@echo "  make bundle-release-blocko     (also: bundle-release-dashy, bundle-release-mergo)"
	@echo "  make bundle-release-all        builds all three"
	@echo ""
	@echo "Build — iOS (debug, unsigned; macOS + Xcode required):"
	@echo "  make build-ios-debug-blocko    (also: build-ios-debug-dashy, build-ios-debug-mergo)"
	@echo "  make build-ios-debug-all       builds all three"
	@echo ""
	@echo "Build — iOS (release .ipa, App Store production; macOS + Xcode + signing required):"
	@echo "  make build-ios-release-blocko  (also: build-ios-release-dashy, build-ios-release-mergo)"
	@echo "  make build-ios-release-all     builds all three"
	@echo ""
	@echo "Build everything (Android APK + iOS) at once:"
	@echo "  make build-all-debug           debug APK + unsigned iOS build, all three games"
	@echo "  make build-all-release         release APK + appbundle + ipa, all three games"
	@echo ""
	@echo "Run on a connected device/emulator/simulator (one app in the foreground at a time):"
	@echo "  make run-debug-blocko          (also: run-debug-dashy, run-debug-mergo)"
	@echo "  make run-release-blocko        (also: run-release-dashy, run-release-mergo)"
	@echo ""
	@echo "Clean build artifacts:"
	@echo "  make clean                     flutter clean in every package/app"
	@echo "  make clean-blocko              (also: clean-dashy, clean-mergo)"

# ---------------------------------------------------------------------------
# Setup
# ---------------------------------------------------------------------------

bootstrap:
	melos bootstrap

get:
	melos run get

analyze:
	melos run analyze

doctor:
	flutter doctor -v

devices:
	flutter devices

clean:
	melos exec -- flutter clean

clean-%:
	cd apps/$* && flutter clean

# ---------------------------------------------------------------------------
# Build — Android APK
# ---------------------------------------------------------------------------

build-debug-%:
	@echo "==> [$*] building debug APK"
	cd apps/$* && flutter build apk --debug

build-release-%:
	@echo "==> [$*] building release APK"
	cd apps/$* && flutter build apk --release

build-debug-all: $(addprefix build-debug-,$(APPS))
build-release-all: $(addprefix build-release-,$(APPS))

# ---------------------------------------------------------------------------
# Build — Android App Bundle (what you actually upload to Google Play)
# ---------------------------------------------------------------------------

bundle-release-%:
	@echo "==> [$*] building release App Bundle (Play Store)"
	cd apps/$* && flutter build appbundle --release

bundle-release-all: $(addprefix bundle-release-,$(APPS))

# ---------------------------------------------------------------------------
# Build — iOS (macOS + Xcode required; not available on Linux/CI without a Mac)
# ---------------------------------------------------------------------------

build-ios-debug-%:
	@echo "==> [$*] building debug iOS app (unsigned)"
	cd apps/$* && flutter build ios --debug --no-codesign

build-ios-release-%:
	@echo "==> [$*] building release .ipa (App Store) — requires signing set up in Xcode"
	cd apps/$* && flutter build ipa --release

build-ios-debug-all: $(addprefix build-ios-debug-,$(APPS))
build-ios-release-all: $(addprefix build-ios-release-,$(APPS))

# ---------------------------------------------------------------------------
# Build — everything at once
# ---------------------------------------------------------------------------

build-all-debug: build-debug-all build-ios-debug-all
build-all-release: build-release-all bundle-release-all build-ios-release-all

# ---------------------------------------------------------------------------
# Run (interactive — attaches to whatever device/emulator/simulator is connected)
# ---------------------------------------------------------------------------

run-debug-%:
	@echo "==> [$*] running in debug mode"
	cd apps/$* && flutter run --debug

run-release-%:
	@echo "==> [$*] running in release mode"
	cd apps/$* && flutter run --release
