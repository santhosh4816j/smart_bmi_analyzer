# Smart BMI Analyzer — by Beachweather

An offline-first BMI, BMR, and nutrition companion built with Flutter.
Every calculation and every byte of data stays on-device — no internet
connection is ever required.

Published on the Microsoft Store as **Smart BMI Analyzer by beachweather**
(Store ID `9MX75BQZ8PX6`).

---

## Features

### Profiles
- Unlimited local profiles (name, age, sex, height, weight, activity
  level, goal, diet preference, notes)
- Search, edit, delete, set-active
- Every profile keeps its own independent BMI/weight history

### BMI & body composition
- BMI calculation + WHO category (Underweight → Obese Class III)
- Healthy/ideal weight range for the user's height
- Estimated body fat % (Deurenberg formula)
- Body surface area (Mosteller formula)
- Category-specific health-risk note and personalized advice

### BMR & calories
- BMR via the Mifflin-St Jeor equation
- TDEE across 5 activity levels
- Mild/standard calorie targets for weight loss and weight gain
- Daily water-intake recommendation

### Nutrition
- Bundled offline food database spanning global everyday foods across
  10 categories (Protein, Vegan Protein, Legume, Grain, Vegetable,
  Fruit, Nuts & Seeds, Dairy, Beverage, Meal) — tagged
  vegetarian/vegan/non-vegetarian/high-protein/low-carb/high-fiber/
  weight-loss/weight-gain/diabetic-friendly — with calories/protein/
  carbs/fat/fiber/sugar per serving.
- A dedicated **Food** tab: search by name, filter by dietary tag,
  browse full macro breakdown per item. See
  [Extending the food database](#extending-the-food-database) to grow
  the catalog further.

### Dashboard
- Current BMI gauge, weight, ideal range, goal
- Maintenance calories and water target at a glance
- Weight-trend line chart (last 14 entries)
- Personalized advice card

### History
- Full weigh-in timeline per profile
- One-tap "log today's weight" bottom sheet, auto-recalculates BMI

### Settings
- Light / Dark / System theme
- 6 accent color options (Material 3 dynamic color scheme)
- Metric ⇄ Imperial unit toggle
- Fully offline — no accounts, no telemetry

---

## Architecture

Clean Architecture, layered as:

```
UI (screens/widgets)
   ↓ watches / calls
Providers (state — Provider package)
   ↓ calls
Repositories (data access)
   ↓ reads/writes
Hive boxes (offline storage) + Services (pure calculation logic)
```

- **Services** (`bmi_calculator_service.dart`, `bmr_calculator_service.dart`,
  `food_database_service.dart`) are pure, side-effect-free, and 100%
  unit-testable — they know nothing about Flutter widgets or Hive.
- **Repositories** are the only classes that touch a `Hive.Box` directly.
- **Providers** (`ProfileProvider`, `ThemeProvider`, `UnitProvider`) hold
  UI state and orchestrate repositories + services.
- **Hive models** ship with **hand-written `TypeAdapter`s** (see
  `lib/models/profile_model.dart` / `bmi_record_model.dart`) so the
  project compiles without requiring a `build_runner` codegen step.

---

## Folder structure

```
lib/
  constants/       # AppConstants — no magic numbers anywhere else
  models/          # ProfileModel, BmiRecordModel, FoodModel, enums
  providers/       # ChangeNotifier state: profile, theme, units
  repositories/     # Hive box access layer
  services/        # Pure BMI/BMR/food-database logic
  theme/           # Material 3 ThemeData builder
  screens/
    splash/
    dashboard/
    profiles/
    history/
    settings/
    root_shell.dart # Adaptive NavigationBar/NavigationRail shell
  widgets/          # GlassCard, BmiGauge, StatTile
  utils/            # Form validators
  main.dart
assets/
  data/food_database.json
  images/ animations/ icons/
test/
  bmi_calculator_service_test.dart
  bmr_calculator_service_test.dart
  splash_screen_test.dart
.github/
  workflows/        # flutter_ci.yml, android.yml, windows.yml, release.yml
  dependabot.yml
  ISSUE_TEMPLATE/
  pull_request_template.md
```

---

## Packages used

`provider` · `hive` / `hive_flutter` · `shared_preferences` ·
`google_fonts` · `intl` · `fl_chart` · `flutter_svg` · `lottie` ·
`animations` · `path_provider` · `permission_handler` · `image_picker` ·
`uuid` · `csv` · `pdf` · `printing` · `msix` (Windows Store packaging)

---

## Getting started

### 1. Prerequisites
- Flutter SDK (latest stable channel)
- For Windows builds: Visual Studio 2022 with the "Desktop development
  with C++" workload
- For Android builds: Android Studio / Android SDK + a JDK 17

### 2. Clone and scaffold platform folders
This repository ships the Dart/Flutter source, assets, CI, and MSIX
config as the source of truth. The `android/` and `windows/` platform
folders are Flutter's own generated boilerplate (native project files,
Gradle wrappers, CMake) — generate them once locally:

```bash
git clone <your-repo-url>
cd smart_bmi_analyzer
flutter create --platforms=android,windows .
flutter pub get
```

`flutter create .` will not overwrite `lib/`, `assets/`, `test/`, or
`pubspec.yaml` — it only fills in the missing native scaffolding.

### 3. Run locally
```bash
flutter run -d windows   # or: flutter run -d <android-device-id>
```

### 4. Verify quality gates
```bash
dart format --output=none --set-exit-if-changed .
flutter analyze --fatal-infos
flutter test
```

### 5. Build release artifacts
```bash
flutter build apk --release
flutter build windows --release
```

---

## Publishing to the Microsoft Store (MSIX)

The Store identity is already wired into `pubspec.yaml` under
`msix_config`:

| Field | Value |
|---|---|
| Display name | Smart BMI Analyzer by Beachweather |
| Identity name | `santhosh4816j.SmartBMIAnalyzerbybeachweather` |
| Publisher | `CN=56A045A8-7F10-4271-9A86-566887D6E7CD` |
| Package Family Name | `santhosh4816j.SmartBMIAnalyzerbybeachweather_fjemarjjz8bqr` |
| Store ID | `9MX75BQZ8PX6` |

Build the package with:
```bash
flutter build windows --release
dart run msix:create
```

This produces an **unsigned** `.msix` in
`build/windows/x64/runner/Release/`, which is exactly what Partner
Center expects when you let it sign on ingestion. If you instead want
to sign locally with your own EV code-signing certificate:

1. Never commit the `.pfx` file or its password to this repo — both
   are already excluded via `.gitignore`.
2. Add to `msix_config` in `pubspec.yaml`:
   ```yaml
   certificate_path: C:\path\to\your\certificate.pfx
   certificate_password: <read from a secret manager, not hardcoded>
   ```
3. Re-run `dart run msix:create`.

The `windows.yml` and `release.yml` GitHub Actions workflows build and
package the MSIX automatically on every push to `main` and on every
`vX.Y.Z` tag, respectively.

---

## Extending the food database

`assets/data/food_database.json` ships with a curated set of globally
common everyday foods — proteins, legumes, grains, vegetables, fruit,
nuts & seeds, dairy, and full meals — across common dietary tags
(vegetarian, vegan, non-vegetarian, high-protein, low-carb, high-fiber,
diabetic-friendly, weight-loss, weight-gain). Add more items by
appending objects with the same shape — no code changes required,
`FoodDatabaseService` reads the file at startup and the **Food** tab
picks up new entries automatically.

---

## Testing

```bash
flutter test               # all unit + widget tests
flutter test --coverage    # with lcov coverage report
```

Included:
- `bmi_calculator_service_test.dart` — BMI, category, ideal weight,
  BSA, and bundled-analysis coverage
- `bmr_calculator_service_test.dart` — BMR, TDEE scaling, calorie
  targets, water intake
- `splash_screen_test.dart` — widget smoke test

---

## Roadmap / not yet wired

To be transparent about scope: the following checklist items from the
original spec have their data model and service layer in place but
are not yet wired to a UI action in this drop, and are good first
issues:
- CSV/PDF export of history (the `csv`, `pdf`, and `printing` packages
  are already dependencies)
- Backup/restore to a user-chosen file (via `path_provider`)
- Local notifications for weight/water/health reminders
- Profile photo capture via `image_picker`
- Lottie animation assets (the `lottie` package is wired; drop `.json`
  animation files into `assets/animations/`)

`assets/icons/icon.png` and `assets/icons/app_icon_store.png` now use
the real Beachweather brand mark (palm tree, sun, waves). Regenerate
platform icon sets any time the source image changes:
```bash
dart run flutter_launcher_icons
```
This produces the Android launcher icon set and a Windows `.ico`
wired into the `windows/` runner project automatically.

---

## Contributing
1. Fork the repo and create a feature branch.
2. Run the quality gates above before opening a PR.
3. Fill out `.github/pull_request_template.md`.

## License
MIT — see [LICENSE](LICENSE).
