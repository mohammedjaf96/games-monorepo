# Project Instructions

## Mandatory: Code Standards

Before writing, editing, or reviewing any Dart/Flutter code in this repository,
read **[`CODE_STANDARDS.md`](./CODE_STANDARDS.md)** in full and follow every rule
in it exactly. This applies to this session and every future session, without
exception.

Key non-negotiables from that file (see it for full detail):
- Folder structure: `lib/core/<serviceName>/` and `lib/features/<featureName>/{bindings,controllers,data/datasources,data/model,views/pages,views/widgets}`.
- Naming: UpperCamelCase for classes, lowerCamelCase for everything else. No underscores, no hyphens, no abbreviations, anywhere.
- One class per file.
- UI files (pages/widgets) are 1–200 lines; split by feature-named files, never generically.
- View files contain nothing outside `build()` — no functions, no variables, no nested widget classes.
- `StatelessWidget` / `GetView<T>` only — never `StatefulWidget`, never `initState`/`dispose`/`setState`.
- One `GetxController` per main page, named after the page; split pages, never controllers.
- `.obs`/`Obx()` only for values that must drive a UI rebuild or animation — not for everything.
- Endpoint/page status uses `StateMixin` + `controller.obx()` — never `Obx()` for page-level status.

If any instruction in a task conflicts with `CODE_STANDARDS.md`, follow `CODE_STANDARDS.md` unless the user explicitly says otherwise for that task.

## Mandatory: Game Feel / Juice Standard

This is a multi-game platform, not a single-game repo — Blocko, Dashy, and
Mergo are the first three games, and more will be added over time. Before
considering any new game "done", read **[`JUICE_CHECKLIST.md`](./JUICE_CHECKLIST.md)**
in full and apply every technique in it. Reuse the shared `game_core` widgets
it lists (`ShakeWidget`, `AnimatedCounter`, `FloatingScoreText`/`Overlay`,
`ParticleBurst`/`Overlay`) rather than reimplementing them, and follow the
same per-game patterns (squash & stretch, motion trail, parallax, speed
lines, Home screen entrance choreography) that were applied to the existing
three games. This applies to this session and every future session, without
exception — a new game must not ship feeling less polished than the first
three by omission.

## Available: Game-dev skills + further reading

`.agents/skills/` has installed Agent Skills (`game-feel`, `game-ui-ux`,
`puzzle`, `art-direction-and-readability`, `onboarding-and-teaching`) —
reach for these first for concrete technique on juice, HUD/menu layout,
grid-puzzle resolution, visual readability, and tutorial design. For
broader design inspiration (postmortems, mobile F2P practice, palette
theory) that isn't a skill, see **[`GAME_DESIGN_RESOURCES.md`](./GAME_DESIGN_RESOURCES.md)**
— optional reading, not a rule set like the two sections above.
