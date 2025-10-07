# AI Agent Instructions for Multiplication Trainer

## Project Overview

This is a Flutter application for multiplication training, following Clean Architecture principles with a feature-first directory structure.

## Architecture

- **Clean Architecture** implementation with three layers:
  - `data/` - Data sources and repositories implementations
  - `domain/` - Business logic and entities
  - `presentation/` - UI components and state management

### Key Dependencies

- State Management: `flutter_bloc` (^8.0.1)
- Dependency Injection: `get_it` (^8.2.0)
- Functional Programming: `dartz` (^0.10.1)
- Local Storage: `shared_preferences` (^2.5.3)

## Project Structure

```
lib/
├── core/           # Shared utilities and base classes
├── features/       # Feature modules
│   └── generateQuestion/  # Example feature module
└── main.dart       # Application entry point
```

## Development Workflow

1. **Testing**:

   - Tests mirror the source directory structure under `test/`
   - Each feature has its own test directory with the same layer separation
   - Use `mockito` for mocking in tests

2. **Code Style**:
   - Follows standard Flutter lint rules (flutter_lints package)
   - No custom lint rules configured yet

## Common Patterns

1. **Feature Organization**:

   - Each feature follows the same layer separation (data/domain/presentation)
   - Business logic should be in the domain layer
   - UI components should be dumb and only depend on BLoC for state

2. **Error Handling**:
   - Use `Either` from `dartz` for error handling
   - Domain errors should be defined in `core/error/`

## Getting Started

1. Install dependencies:

   ```bash
   flutter pub get
   ```

2. Run tests:

   ```bash
   flutter test
   ```

3. Generate mocks (if needed):
   ```bash
   flutter pub run build_runner build
   ```
