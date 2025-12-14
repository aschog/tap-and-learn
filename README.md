# Tap and Learn

**Tap and Learn** is a Flutter-based educational application designed to help users practice and master multiplication tables. It provides an interactive and customizable training environment where learners can improve their arithmetic skills through targeted exercises.

## 🚀 Features

- **Multiplication Training**: Practice multiplication tables with randomly generated questions.
- **Customizable Practice**: Select specific multiplicands (e.g., practice only the 7x and 8x tables) to focus on weak areas.
- **Interactive Feedback**: Get immediate visual feedback on answers.
- **Persistent Settings**: Your preferred multiplicands are saved automatically.
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

    ```bash
    flutter run
    ```

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