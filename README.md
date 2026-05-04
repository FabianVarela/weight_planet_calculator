# Flutter · Weight Planet Calculator

Flutter app that calculates your weight on each planet in the solar system using real gravity data. Features custom GLSL
fragment shaders for animated planet visuals.

---

## Features

- Browse all 8 planets in a responsive grid layout (Earth highlighted as home)
- Enter your Earth weight and instantly see your weight on any planet
- Toggle between **kg** and **lb** units
- Planet detail card showing gravity multiplier and year duration
- Custom per-planet GLSL fragment shaders rendered via `flutter_shaders`

## Screens

| Screen        | Description                                                  |
|---------------|--------------------------------------------------------------|
| Planet List   | Scrollable grid with all planets; Earth full-width in center |
| Planet Detail | Shader animation, weight stepper, unit toggle, planet info   |

## Planet Data

| Planet  | Gravity (m/s²) | Gravity Factor | Year (days) |
|---------|----------------|----------------|-------------|
| Mercury | 3.7            | 0.38×          | 88          |
| Venus   | 8.87           | 0.91×          | 225         |
| Earth   | 9.81           | 1.00×          | 365         |
| Mars    | 3.71           | 0.38×          | 687         |
| Jupiter | 24.79          | 2.34×          | 4 333       |
| Saturn  | 10.44          | 0.93×          | 10 759      |
| Uranus  | 8.69           | 0.92×          | 30 687      |
| Neptune | 11.15          | 1.12×          | 60 190      |

---

## Requirements

- Flutter `^3.41.0`
- Dart `^3.11.0`

## Getting Started

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

---

## Packages

### Dependencies

| Package                                                     | Purpose                      |
|-------------------------------------------------------------|------------------------------|
| [collection](https://pub.dev/packages/collection)           | List utilities               |
| [flutter_hooks](https://pub.dev/packages/flutter_hooks)     | Stateful logic via hooks     |
| [flutter_shaders](https://pub.dev/packages/flutter_shaders) | GLSL fragment shader loading |
| [google_fonts](https://pub.dev/packages/google_fonts)       | Custom typography            |

### Dev Dependencies

| Package                                                                   | Purpose                    |
|---------------------------------------------------------------------------|----------------------------|
| [build_runner](https://pub.dev/packages/build_runner)                     | Code generation runner     |
| [flutter_gen_runner](https://pub.dev/packages/flutter_gen_runner)         | Type-safe asset references |
| [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) | App icon generation        |
| [very_good_analysis](https://pub.dev/packages/very_good_analysis)         | Strict lint rules          |

## Project Structure

```
lib/
├── app.dart                    # App entry, theme, routing
├── model/
│   └── planet_model.dart       # Planet data + gravity constants
├── styles/
│   └── generated/assets.gen.dart
└── ui/
    ├── planet_list_view.dart   # Home screen grid
    ├── planet_detail_view.dart # Weight calculator screen
    ├── common/
    │   └── custom_theme.dart
    └── widgets/
        ├── planet_card_widget.dart
        └── planet_shader_widget.dart

shaders/                        # Per-planet GLSL fragment shaders
assets/planets/                 # Planet PNG images
```
