# Flutter Project — Architecture & Code Standards

> For AI assistants & developers: Read this file completely before writing any code.
> Every rule below is mandatory — no exceptions, no workarounds.
> If you are an AI working on this project, follow every rule in this file exactly as written.

---

## 1. Folder Structure

```
lib/
├── core/                          # Shared services, utilities, algorithms
│   ├── network/                   # HTTP client, interceptors, base API
│   ├── storage/                   # Local storage service
│   ├── theme/                     # App theme, colors, text styles
│   ├── routing/                   # GetX routes & bindings
│   ├── utils/                     # Formatters, validators, helpers
│   └── <serviceName>/             # Any reusable service gets its own folder
│
├── features/                      # One folder per feature — strictly isolated
│   └── <featureName>/
│       ├── bindings/              # GetX bindings — dependency registration
│       ├── controllers/           # GetxController only — all logic & state live here
│       ├── data/
│       │   ├── datasources/       # API calls, local DB, remote sources
│       │   └── model/             # Data models / entities
│       └── views/
│           ├── pages/             # Full screens + page-tree splits  (see §4, §5)
│           └── widgets/           # Cards, spec widgets, reusable UI pieces  (see §6)
│
└── main.dart
```

### Folder rules
- Every feature must live inside `lib/features/<featureName>/`.
- Features must never import directly from another feature's `controllers/` or `views/`.
- Share data through `core/` services or GetX dependency injection only.
- `core/` is for code that is written once and reused many times.
- Every reusable service, algorithm, or utility gets its own named subfolder inside `core/`.
- `views/pages/` = the screen itself and any file it is split into (§5).
- `views/widgets/` = cards, spec widgets, and reusable UI pieces (§6).

---

## 2. Naming Conventions — ZERO TOLERANCE

| Element | Rule | ✅ Correct | ❌ Wrong |
|---|---|---|---|
| Classes | UpperCamelCase | `HomeController` | `home_controller`, `homeController` |
| Files | lowerCamelCase.dart | `homeController.dart` | `home_controller.dart` |
| Variables | lowerCamelCase | `userName` | `user_name`, `UserName` |
| Functions | lowerCamelCase | `fetchUser()` | `fetch_user()`, `FetchUser()` |
| Folders | lowerCamelCase | `userProfile/` | `user_profile/`, `UserProfile/` |
| Constants | lowerCamelCase | `apiBaseUrl` | `API_BASE_URL`, `api_base_url` |

**Rule:** No underscores (`_`) and no hyphens (`-`) anywhere in class names, variable names,
function names, folder names, or file names. Use UpperCamelCase for classes,
lowerCamelCase for everything else.

### 2.1 Never use the underscore `_` — for anything
The underscore prefix is forbidden for every identifier: variables, functions, classes, widgets, methods, and fields.
This includes "private" members and local helper builders. No `_buildHeader()`, no `_MyCard`, no `_isLoading`.
If something needs to be reused → give it a real name and its own file. If it does not → inline it (§6).

```dart
// ❌ WRONG — underscore-prefixed helper widget / method
Widget _buildProductCard() { ... }
class _ProductCard extends StatelessWidget { ... }

// ✅ CORRECT — real name, own file in views/widgets/  →  productCard.dart
class ProductCard extends StatelessWidget { ... }
```

### 2.2 No shortcut or abbreviated names
Names must be full words, spelled out. No abbreviations, no shortcuts, anywhere.

❌ `usr`, `btn`, `img`, `ctrl`, `qty`, `catList`, `prodDtl`
✅ `user`, `button`, `image`, `controller`, `quantity`, `categoryList`, `productDetail`

---

## 3. One Class Per File — ABSOLUTE RULE

One class = one file. Always.
Never write two classes in one file — not a page + a widget, not a widget + a helper, nothing.
No helper classes, no private classes, no enums bundled inside another class file.
Each class gets its own dedicated `.dart` file.

```dart
// ✅ CORRECT — homeController.dart contains only HomeController
class HomeController extends GetxController { ... }

// ❌ WRONG — two classes in one file
class HomeController extends GetxController { ... }
class HomeState { ... }  // must be in its own file: homeState.dart
```

---

## 4. File Size — Every UI File Is 1–200 Lines

Any UI file (page or widget) must be between 1 and 200 lines. Hard limit.
If a file grows beyond 200 lines, it must be split into two (or more) files.
Splits are meaningful, never random. Name each split after the feature + the part it holds — never a generic name like `part2.dart` or `widgets.dart`.

```dart
// ❌ WRONG — one 380-line file, or random split names
productDetailsPage.dart        // 380 lines
productDetailsPage2.dart

// ✅ CORRECT — split by section, feature-named
productDetailsPage.dart        // < 200 lines, composes the parts
productDetailsHeader.dart
productDetailsBody.dart
```

Where each split goes (page split vs widget extraction) is decided in §5.

---

## 5. Splitting a Large UI Tree — pages/ vs widgets/

When a screen crosses 200 lines you split it. Where the split file lives depends on what it is:

**Page-tree split → `views/pages/`.**
If you are splitting out a large piece of the page's own layout (for example a big `Container … Column` subtree that is only part of this screen and is not a reusable component), the extracted file goes in `views/pages/`, next to the page. It is still part of the page — not a widget.

**Reusable UI piece → `views/widgets/`.**
If the piece is a self-contained, reusable component (a card, a spec widget, a spec element), it goes in `views/widgets/` (§6).

```
featuresV2/category/views/
├── pages/
│   ├── categoryPage.dart          # the screen — composes the parts below
│   ├── categoryPageHeader.dart    # page-tree split (part of THIS screen)
│   └── categoryPageBody.dart      # page-tree split (part of THIS screen)
└── widgets/
    └── categoryCard.dart          # reusable component → widgets/
```

Splitting a page never splits its controller. All split page files share the one controller for that page (§9).

---

## 6. Custom Widgets — Cards, Spec Widgets, Spec Elements

Cards, spec widgets, and spec elements each get their own file in `views/widgets/`, named for exactly what they are: `productCard.dart`, `categoryCard.dart`, `storeCard.dart`, `offerCardWidget.dart` …

Never define a custom widget inside the page file.
Never create a custom widget as a local `_`-prefixed method or class (§2.1). If you need a custom widget, create a new file with the widget's name in `views/widgets/` and put the widget there.

**Exception — inline it, don't extract:** if the tree is small / not big, or the widget is very simple / very small, do not create a separate file. Just place it inline in the build tree.

```dart
// ❌ WRONG — custom widget defined inside the page as a local builder
class ProductPage extends GetView<ProductController> {
  Widget buildCard() { ... }          // ← forbidden: widget inside the page
}

// ✅ CORRECT — own file: views/widgets/productCard.dart
class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) { ... }
}

// ✅ ALSO CORRECT — simple/small piece stays inline in the tree (do NOT extract)
Padding(
  padding: const EdgeInsets.all(8),
  child: Text(controller.title),
)
```

---

## 7. View Files Are Pure — Nothing Outside build()

Inside a page/view file, put nothing outside `Widget build(BuildContext context)`:

- ❌ No custom widget classes.
- ❌ No functions, no void methods.
- ❌ No variables, no logic.

Keep the build tree clean and declarative. Everything else has a home:

| Need | Where it goes |
|---|---|
| A function / any logic | the page's controller (`controllers/`) |
| A custom widget | `views/widgets/` (§6), or `views/pages/` for a page-tree split (§5) |
| State / variables | the page's controller |

```dart
// ✅ CORRECT — page file has ONLY the build tree
class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const ProfileHeader(),                 // widget → views/widgets/
          Obx(() => Text(controller.userName.value)),
          ProfileMenuList(onTap: controller.openItem),  // function → controller
        ],
      ),
    );
  }
}

// ❌ WRONG — helper widget / function declared outside build()
class ProfilePage extends GetView<ProfileController> {
  Widget buildHeader() { ... }           // ← forbidden
  void openItem() { ... }                // ← forbidden — belongs in controller
}
```

---

## 8. Widget Rules — StatelessWidget Only

### 8.1 Never use StatefulWidget
`StatefulWidget` is forbidden.
Use `StatelessWidget`, or `GetView<Controller>` when the widget has a controller.
All state lives in the `GetxController`.

```dart
// ✅ CORRECT
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Text(controller.title.value));
  }
}

// ❌ WRONG
class HomeView extends StatefulWidget { ... }
```

### 8.2 A StatelessWidget with a controller becomes GetView
If a `StatelessWidget` has a controller, replace it with `GetView<ControllerName>`.
`GetView` gives you `controller` for free without calling `Get.find()` manually.

---

## 9. Controllers — One Per Main Page

### 9.1 One controller per main page, named after the page
Every main page gets its own controller: `categoryPage`, `productDetails`, `subCategoryPage`, `profilePage` … each has exactly one controller.
The controller is named after the feature page: page `categoryPage` → controller `CategoryController`; page `productDetails` → `ProductDetailsController`.
Do NOT create controllers for custom widgets (cards / spec widgets / spec elements). Controllers exist for pages, not for widgets.

### 9.2 Split the page, never the controller
When a long page is split into several page files (§5), they all share the single controller for that page.
Split only the page. Never split the controller.

### 9.3 Never use initState / dispose

| ❌ Forbidden | ✅ Use instead |
|---|---|
| `initState()` | `onInit()` in `GetxController` |
| `dispose()` | `onClose()` in `GetxController` |
| `setState()` | `.value =` on Rx variable or `update()` |

```dart
// ✅ CORRECT
class CategoryController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
```

### 9.4 No logic or functions in the View
Zero functions in the view file.
Zero variables declared in the view file.
Every function, every variable, every piece of logic → goes in the controller (§7).

---

## 10. Reactive Variables — Two Types Only

There are exactly two kinds of variables. Decide which one you need before adding `.obs`.

**Type 1 — Reactive (Rx)**
Use Rx only for a value whose change must drive a UI change or an animation.
Only the widget that must react to that value is wrapped in `Obx()` — nothing more (§12).

**Type 2 — Normal (no Rx)**
A value that changes but does not change the UI and does not drive an animation stays a plain `var` / `final`.
No `.obs`. Do not make it reactive just because it changes.

```dart
// Type 2 — normal var: changes, but nothing in the UI observes it
final String apiUrl = 'https://api.example.com';
int retryCount = 0;

// Type 1 — Rx var: its change must rebuild a widget / run an animation
final RxString userName = ''.obs;
final RxBool isMenuOpen = false.obs;
final RxList<Product> products = <Product>[].obs;
```

**Rule:** Do not make everything `.obs` — only what the UI actually observes.
Over-using `.obs` causes unnecessary rebuilds.

---

## 11. Page / Endpoint Status — StateMixin + controller.obx()

When an endpoint call has multiple statuses (loading / empty / error / success), you must use GetX `StateMixin` and render it with `controller.obx()`.

- Controller: `extends GetxController with StateMixin<T>`; drive status with `change(data, status: ...)`.
- View: render with `controller.obx(...)`.
- Do NOT use `Obx()` to handle page/endpoint status. `Obx()` is only for individual reactive widgets (§12) — never for page status.
- Do NOT scatter `bool isLoading` + `bool hasError` variables — the status is one object, owned by `StateMixin`.

```dart
// In the controller
class ProductsController extends GetxController with StateMixin<List<Product>> {
  ProductsController(this.repository);
  final ProductsRepository repository;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    change(null, status: RxStatus.loading());
    final result = await repository.getProducts();
    result.fold(
      (failure) => change(null, status: RxStatus.error(failure.message)),
      (products) => products.isEmpty
          ? change(null, status: RxStatus.empty())
          : change(products, status: RxStatus.success()),
    );
  }
}

// In the view — controller.obx handles every status, NOT Obx
class ProductsPage extends GetView<ProductsController> {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: controller.obx(
        (products) => ProductsList(products: products!),
        onLoading: const AppLoader(),
        onEmpty: const AppEmptyState(),
        onError: (message) => AppErrorState(message: message),
      ),
    );
  }
}
```

---

## 12. Obx Usage Rules

`Obx()` is for one reactive widget (Type 1 variable, §10) — never for page status (§11).
Wrap only the widget that changes — never wrap the entire page in one `Obx`.
Avoid rebuilding the full widget tree for a single value change.

```dart
// ✅ CORRECT — only the Text rebuilds
Column(
  children: [
    const HeaderWidget(),
    Obx(() => Text(controller.userName.value)),
    const FooterWidget(),
  ],
)

// ❌ WRONG — entire page rebuilds for one value
Obx(() => Scaffold(
  body: Column(
    children: [
      HeaderWidget(),
      Text(controller.userName.value),
      FooterWidget(),
    ],
  ),
))
```

---

## 13. Summary Checklist for AI Assistants

Before generating or editing any code in this project, confirm:

- [ ] Feature is inside `lib/features/<featureName>/` with `bindings/`, `controllers/`, `data/model/`, `data/datasources/`, `views/pages/`, `views/widgets/`
- [ ] Reusable service is inside `lib/core/<serviceName>/`
- [ ] No underscores or hyphens in any name — including no `_`-prefixed private/local members or builders
- [ ] No abbreviated / shortcut names — full words only
- [ ] One class per file — never two classes in one file
- [ ] Every UI file is 1–200 lines; anything longer is split into feature-named files
- [ ] Page-tree splits go in `views/pages/`; cards / spec widgets / spec elements go in `views/widgets/`
- [ ] A custom widget is its own file in `views/widgets/` — never inside the page, never a local `_` builder (small/simple pieces stay inline)
- [ ] View file has nothing outside `build()` — no functions, no vars, no widget classes
- [ ] No `StatefulWidget` — use `StatelessWidget`, or `GetView<T>` when there is a controller
- [ ] No `initState` or `dispose` in any widget — use `onInit` / `onClose` in the controller
- [ ] One controller per main page, named after the page; no controllers for widgets; split the page, never the controller
- [ ] Rx used only where the UI must react or animate — normal var for everything else
- [ ] Endpoint status uses `StateMixin` + `controller.obx()` — never `Obx()` for page status
- [ ] `Obx` wraps only the specific widget that changes — not the full page

---

## 14. analysis_options.yaml — Lint Enforcement

The rules below are enforced by the linter. Warnings appear in your IDE in real time.
See `analysis_options.yaml` at the project root for the full configuration.

| Lint Rule | Enforces |
|---|---|
| `prefer_const_constructors` | Use `const` wherever possible |
| `avoid_unnecessary_containers` | No pointless `Container` wrappers |
| `use_key_in_widget_constructors` | Always pass `key` to widgets |
| `prefer_final_fields` | Mark fields `final` when never reassigned |
| `avoid_print` | Use a logging service, not `print()` |
| `unnecessary_this` | Don't write `this.` when not needed |
| `camel_case_types` | Class names must be UpperCamelCase |
| `non_constant_identifier_names` | Variables and functions must be lowerCamelCase |
| `file_names` | File names must be lowerCamelCase.dart |
