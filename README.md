# Tap and Learn

**Tap and Learn** is a Flutter-based educational application designed to help users practice and master multiplication tables. It provides an interactive and customizable training environment where learners can improve their arithmetic skills through targeted exercises.

## 🚀 Features

- **Multiplication Training**: Practice multiplication tables with randomly generated questions.
- **Customizable Practice**: Select specific operands (e.g., practice only the 7x and 8x tables) to focus on weak areas.
- **Interactive Feedback**: Get immediate visual feedback on answers.
- **Persistent Settings**: Your preferred operands are saved automatically.
- **Localization**: Supports multiple languages (currently English and German).
- **Clean Architecture**: Built with scalability and maintainability in mind using the Clean Architecture principles.

## 🛠 Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **Language**: [Dart](https://dart.dev/)
- **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- **Dependency Injection**: [get_it](https://pub.dev/packages/get_it)
- **Functional Programming**: [dartz](https://pub.dev/packages/dartz)
- **Persistence**: [shared_preferences](https://pub.dev/packages/shared_preferences)
- **Localization**: `flutter_localizations` & `intl`

## 📂 Project Structure

The project follows **Clean Architecture** to ensure separation of concerns:

```
lib/
├── config/             # App configuration (themes, routes, etc.)
├── core/               # Core utilities, error handling, and shared use cases
├── features/           # Feature-based modules
│   └── arithmetic/
│       ├── data/       # Data sources and repositories implementation
│       ├── domain/     # Entities, repositories interfaces, and use cases
│       └── presentation/ # UI (Pages, Widgets) and State Management (Bloc/Cubit)
├── l10n/               # Localization files (.arb)
├── injection_container.dart # Dependency injection setup
└── main.dart           # Application entry point
```

## 🏁 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.4.3 or higher)
- An IDE (VS Code, Android Studio, or IntelliJ)

### Installation

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/aschog/tap-and-learn.git
    cd tap-and-learn
    ```

2.  **Install dependencies:**

    ```bash
    flutter pub get
    ```

3.  **Run the app:**

    The application supports two flavors: **Multiplication** and **Addition**.

    ### Android
    To run the app on an Android device or emulator with the specific flavor configuration (custom app name and ID):

    **Multiplication Trainer:**
    ```bash
    flutter run --flavor multiplication -t lib/main_multiplication.dart
    ```

    **Addition Trainer:**
    ```bash
    flutter run --flavor addition -t lib/main_addition.dart
    ```

    ### iOS
    To run the app on the iOS Simulator or a physical device:

    **Multiplication Trainer:**
    ```bash
    flutter run -t lib/main_multiplication.dart
    ```

    **Addition Trainer:**
    ```bash
    flutter run -t lib/main_addition.dart
    ```

    *Note: To use the `--flavor` flag on iOS (which enables separate app bundles), you must manually configure Xcode Schemes matching the flavor names (`multiplication`, `addition`).*

## 📱 Flavors & Configuration

This project is configured to build multiple app variants from the same codebase:

- **Multiplication**: The default experience for practicing multiplication tables.
- **Addition**: A variant for practicing addition sums.

Each flavor has its own entry point (`lib/main_multiplication.dart`, `lib/main_addition.dart`) and configuration (`ArithmeticConfig`), allowing for dynamic customization of:
- App Title and Icons
- Arithmetic Strategy (Logic)
- UI Labels and Examples

## 🧪 Testing

To run the unit and widget tests:

```bash
flutter test
```

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1.  Fork the project.
2.  Create your feature branch (`git checkout -b feature/AmazingFeature`).
3.  Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4.  Push to the branch (`git push origin feature/AmazingFeature`).
5.  Open a Pull Request.

## 🚀 Deployment

The project is configured to automatically deploy to GitHub Pages via GitHub Actions when pushing to the `main` branch.

The deployment workflow:
1.  Builds the **Multiplication** web app to `/multiplication/`.
2.  Builds the **Addition** web app to `/addition/`.
3.  Deploys a landing page at the root to navigate between them.

**Note:** Ensure your repository name matches the `base-href` configured in `.github/workflows/deploy.yml` (currently set to `/tap-and-learn/`). If your repo name is different, update the workflow file.