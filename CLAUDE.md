# SLAM – Claude Code Guide

**Framework:** Flutter 3.27+ / Dart 3.6+
**Backend:** Firebase + Cloud Functions (`https://learn-smart.app`)
**State management:** Riverpod 2.6+ with code generation
**Design:** Material 3 with Google Sans Flex font

---

## Quick Start

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run                 # -d chrome  for web
```

Configure AI/backend in **Settings → Debug Panel** after first run (Claude API key, backend URL).

---

## Project Structure

```
lib/
├── main.dart                    # Entry point — AppInitializer → runApp
├── firebase_options.dart        # Auto-generated Firebase config
├── app/
│   ├── app.dart                 # SLAMApp (MaterialApp.router)
│   ├── routes.dart              # GoRouter + auth redirect + GoRouterRefreshStream
│   └── theme.dart               # Material 3 theme presets
├── core/
│   ├── app_initializer.dart     # Firebase, Hive, services init
│   ├── constants/               # API endpoints, Firebase collection names, topic catalog
│   ├── data/
│   │   ├── datasources/         # local_datasource (Hive), remote_datasource (Firestore)
│   │   ├── models/result.dart   # Result<T,E> functional error type
│   │   └── repositories/        # base, lernplan, settings
│   ├── models/                  # Freezed domain models (question, user_stats, lernplan, …)
│   ├── services/
│   │   ├── ai_service.dart      # Cloud Functions wrapper (generate-questions, evaluate-answer, …)
│   │   ├── auth_service.dart    # Firebase Auth + authStateChanges stream
│   │   └── firestore_service.dart # All Firestore CRUD (stats, settings, lernplan, question cache)
│   └── utils/                   # logger, error_handler, performance_monitor, security_utils
├── features/
│   ├── auth/                    # splash_screen, login, register, email verification
│   ├── home/                    # main_navigation (3 tabs), profil_screen
│   ├── live_feed/               # Adaptive question feed (providers, screen, widgets)
│   ├── learning_plan/           # Lernplan topic picker
│   ├── question_session/        # Step-by-step question answering
│   ├── apps/                    # AppsHub, GeoGebra, KI-Labor, Content Library
│   ├── gamification/            # XP/coins/streaks, shop, progress screen
│   └── settings/                # Theme, education level, debug panel
└── shared/widgets/              # Reusable widgets (GlassPanel, GradientButton, …)
```

### Generated files — never edit manually

```
**/*.g.dart        # riverpod_generator + json_serializable
**/*.freezed.dart  # freezed
```

---

## Architecture

### Clean Architecture layers

```
Presentation (screens + providers)
    ↓  reads/writes
Domain (models)
    ↓  persisted by
Data (datasources + repositories + services)
```

### State management

- **Riverpod `@riverpod` + code generation** for all providers.
- **Freezed** for immutable models with `copyWith` and JSON serialisation.
- **AsyncValue** for loading/error/data in async providers.

### Navigation

GoRouter with an expressive Material 3 fade+scale transition (400 ms).
The `routerProvider` attaches a `GoRouterRefreshStream` to
`authService.authStateChanges` so the redirect re-fires whenever Firebase
restores a persisted session (critical for web).

### Offline-first caching

| Layer | Storage | Used for |
|---|---|---|
| L1 | In-memory (Riverpod state) | Current session |
| L2 | SharedPreferences | Local question queue fallback |
| L3 | Hive boxes | User profile, settings, lernplan |
| L4 | Cloud Firestore | Primary question queue cache, all user data |

---

## Key Features

### Live Feed (`lib/features/live_feed/`)

- **Queue system (`LiveFeedQueue`)**: maintains a buffer of pre-fetched questions.
- **Firebase-backed cache**: remaining questions are saved to
  `users/{uid}/questionQueueCache/current` and reloaded on the next session so
  the user never stares at a spinner on app open.
- **Adaptive difficulty**: auto-adjusts based on recent performance.
- Triggers a background prefetch when fewer than 10 questions remain.

### Authentication (`lib/features/auth/`)

- Domain-restricted to `@mvl-gym.de`.
- `SplashScreen` waits for `authStateChanges().first` (async) before routing —
  this prevents the grey-screen race condition on web where Firebase Auth
  restores a session asynchronously.

### Gamification (`lib/features/gamification/`)

- XP, coins, streak, level stored in `users/{uid}.stats` in Firestore.
- Shop sells unlockable themes (coins deducted in a Firestore transaction).
- Streak freezes purchasable with coins or XP.

---

## Backend

**Base URL:** `https://learn-smart.app`
**Source:** `https://github.com/Seminarkurs-Lernapp-Mathematik/slam-backend`

| Endpoint | Purpose |
|---|---|
| `POST /api/generate-questions` | Generate a batch of adaptive questions |
| `POST /api/evaluate-answer` | AI-powered answer evaluation + feedback |
| `POST /api/custom-hint` | Personalized hint for the current question |
| `POST /api/update-auto-mode` | Adjust AI difficulty parameters |
| `POST /api/generate-geogebra` | GeoGebra visualisation for a topic |
| `POST /api/generate-mini-app` | KI-Labor interactive mini app |
| `POST /api/manage-learning-plan` | CRUD on the learning plan |
| `POST /api/manage-memories` | Spaced repetition operations |
| `POST /api/analyze-image` | Image upload & mathematical analysis |

AI models used: Claude Sonnet 4.6, Claude Haiku 4.5, Gemini Pro 3, Gemini Flash 3.

---

## Firestore Schema

```
users/{userId}
  .profile      { displayName, email, createdAt, lastLogin }
  .stats        { totalXp, coins, streak, streakFreezes, level, … }
  .settings     { theme, gradeLevel, courseType, aiModel, … }
  .learningPlan { id, userId, topics[], createdAt, updatedAt }
  .taskHistory  []

  /generatedQuestions/{sessionId}   QuestionSession
  /questionHistory/{autoId}         QuestionResult (per answered question)
  /questionQueueCache/current       { questions[], savedAt, expiresAt }
  /questionProgress/{questionId}    QuestionProgress
  /topicProgress/{topicKey}         TopicProgress
  /memories/{memoryId}              Memory (spaced repetition)
  /savedContent/{contentId}         Saved GeoGebra / KI-Lab content
  /learningSessions/{sessionId}     Learning session records
```

---

## Common Development Tasks

### Edit a Freezed model

```bash
# 1. Edit the .dart file
# 2. Regenerate
dart run build_runner build --delete-conflicting-outputs
```

### Add a new route

```dart
// lib/app/routes.dart
GoRoute(
  path: '/my-feature',
  name: 'myFeature',
  pageBuilder: (context, state) => buildPageWithExpressiveTransition(
    context: context, state: state,
    child: const MyFeatureScreen(),
  ),
),
```

### Add a Riverpod provider

```dart
@riverpod
class MyNotifier extends _$MyNotifier {
  @override
  MyState build() => MyState.initial();

  void doSomething() => state = state.copyWith(…);
}
// then: dart run build_runner build
```

### Check for issues

```bash
flutter analyze
dart run build_runner build --delete-conflicting-outputs
```

### Build for release

```bash
flutter build web --release          # web
flutter build apk --release          # Android APK
flutter build appbundle --release    # Google Play
flutter build ios --release          # iOS (requires macOS + Xcode)
```

---

## Code Conventions

- **Files:** `snake_case.dart`
- **Classes:** `PascalCase`
- **Variables/functions:** `camelCase`
- **Private members:** prefix `_`
- Use `color.withValues(alpha: 0.5)` — NOT the deprecated `withOpacity`.
- Use `Theme.of(context).colorScheme.*` — never hard-code colors.
- Prefer `const` constructors everywhere possible.

---

## Troubleshooting

| Symptom | Fix |
|---|---|
| Build runner errors | `flutter clean && flutter pub get && dart run build_runner build --delete-conflicting-outputs` |
| Grey screen on web after splash | Caused by Firebase Auth async restoration — fixed via `GoRouterRefreshStream` + `authStateChanges().first` in SplashScreen |
| No questions on app open | Firebase question queue cache (`questionQueueCache/current`) is expired or empty; app falls back to generating new ones |
| LaTeX not rendering | Ensure `flutter_math_fork` is up to date; wrap expressions with `Math.tex(r'...')` |
| API calls failing | Check backend URL in Settings → Debug Panel; verify Claude/Gemini key is set |
| Hot reload not picking up provider changes | Use Hot Restart (`R`) instead of Hot Reload (`r`) |
