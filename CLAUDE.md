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
