# SLAM (Smart Learning Adaptive Mathematics)

Adaptive learning app for mathematics with AI-powered question generation.

## Project Overview

SLAM is a cross-platform mobile application (iOS & Android) designed to help students learn mathematics more effectively through personalized, AI-generated questions. It uses an adaptive difficulty system that adjusts to the user's performance and gaps in knowledge.

### Core Technologies
- **Frontend Framework:** Flutter 3.27+ (Dart 3.6+)
- **State Management:** Riverpod 2.6+ with code generation
- **Navigation:** GoRouter 16+
- **Database:** Google Cloud Firestore (primary) & Hive (local L3 cache)
- **Authentication:** Firebase Auth (restricted to `@mvl-gym.de` domain)
- **AI Backend:** Cloudflare Workers acting as a proxy to Claude (Sonnet/Haiku) and Gemini (Pro/Flash)
- **Models & Serialization:** Freezed & JSON Serializable
- **LaTeX Rendering:** `flutter_math_fork`

---

## Architecture & Conventions

### Clean Architecture (Feature-First)
The project follows a feature-based organization, with each feature subdivided into Clean Architecture layers:
- **Presentation:** Widgets, Screens, and Riverpod Providers.
- **Domain:** Models (Freezed) and Business Logic.
- **Data:** Repositories, Services, and Data Sources (Hive/Firestore).

### Directory Structure
- `lib/main.dart`: Entry point, initializes `AppInitializer`.
- `lib/app/`: Root app configuration (`MaterialApp.router`, routes, theme).
- `lib/core/`: Global constants, base models, core services (Auth, AI, Firestore), and utilities.
- `lib/features/`: Feature modules (auth, learning_plan, question_session, gamification, etc.).
- `lib/shared/`: Reusable UI components and animations.

### Coding Standards
- **Naming:** `snake_case` for files, `PascalCase` for classes, `camelCase` for variables/functions.
- **Immutability:** Always use **Freezed** for domain models.
- **Providers:** Use `@riverpod` annotation (Riverpod Generator) for all providers.
- **Colors:** Use `Theme.of(context).colorScheme` rather than hardcoding hex values.
- **Transparency:** Prefer `color.withValues(alpha: 0.x)` over the deprecated `withOpacity`.
- **Constructors:** Use `const` constructors whenever possible for performance.
- **Logging:** Use the custom `Logger` class (e.g., `Logger.info(...)`).

---

## Getting Started

### Prerequisites
- Flutter SDK (>= 3.6.0)
- Firebase project setup
- Android Studio / Xcode for emulators

### Initial Setup
```bash
# 1. Install dependencies
flutter pub get

# 2. Generate required code (Freezed, Riverpod, etc.)
dart run build_runner build --delete-conflicting-outputs

# 3. Run the application
flutter run
```

### Development Workflow
- **Code Generation (Watch):** `dart run build_runner watch --delete-conflicting-outputs`
- **Linting:** `flutter analyze`
- **Formatting:** `dart format lib/ -l 80`
- **Testing:** `flutter test`

---

## Backend & API

### API Endpoints
Base URL: `https://api.learn-smart.app` (Defined in `ApiEndpoints.baseUrl`)

Key Endpoints:
- `POST /api/generate-questions`: Batch generation of adaptive questions.
- `POST /api/evaluate-answer`: AI evaluation of user input.
- `POST /api/custom-hint`: Generates a context-aware hint.
- `POST /api/generate-geogebra`: Integration with GeoGebra visualizer.

### AI Models
- **Standard:** Claude Sonnet 4.5 / Gemini 3 Flash
- **Lightweight:** Claude Haiku 4.5
- **Advanced:** Gemini 3 Pro

---

## Authentication Rules

- **Domain Restriction:** Registration and login are restricted to the `@mvl-gym.de` domain.
- **Verification:** Users must verify their email before accessing core learning features.
- **Session Persistence:** Managed via Firebase Auth and synchronized across tabs (for Web) via `GoRouterRefreshStream`.

---

## Troubleshooting

- **Missing Generated Files:** Run `dart run build_runner build` to regenerate `.g.dart` and `.freezed.dart` files.
- **Firebase Auth Grey Screen (Web):** This is a race condition. Ensure `SplashScreen` waits for `authStateChanges().first`.
- **LaTeX Rendering Issues:** Ensure expressions are wrapped with `Math.tex(r'...')` and use `r''` (raw strings) to avoid escape character issues.
- **Build Errors after Dependency Updates:** Run `flutter clean && flutter pub get` before rebuilding.
