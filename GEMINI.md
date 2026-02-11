# SLAM Learning App - Gemini CLI Context

**Version:** 1.0
**Last Updated:** February 2026
**Framework:** Flutter 3.27+
**Backend:** Firebase + Cloud Functions (learn-smart.app)

---

## 📋 Table of Contents

1. [Project Overview](#project-overview)
2. [Quick Start](#quick-start)
3. [Architecture](#architecture)
4. [Key Features](#key-features)
5. [Technology Stack](#technology-stack)
6. [Project Structure](#project-structure)
7. [Development Workflow](#development-workflow)
8. [Backend Integration](#backend-integration)
9. [Common Tasks](#common-tasks)
10. [Troubleshooting](#troubleshooting)
11. [Code Conventions](#code-conventions)
12. [Project Status](#project-status)

---

## 🎯 Project Overview

SLAM (Smart Learning Adaptive Math) is an AI-powered adaptive learning platform for mathematics education. The app uses Claude and Gemini AI models to generate personalized questions, provide intelligent feedback, and create custom learning experiences.

### Core Philosophy
- **Adaptive Learning**: Questions adjust difficulty based on performance
- **AI-First**: Leverages Claude Sonnet/Haiku and Gemini for intelligent tutoring
- **Gamification**: XP, levels, streaks, coins, and unlockable themes
- **Material 3 Design**: Modern, expressive UI with smooth animations

### Key Differentiators
- Real-time adaptive difficulty in Live Feed
- LaTeX rendering for mathematical expressions
- GeoGebra integration for visualizations
- Spaced repetition memory system
- Collaborative canvas (planned)

---

## 🚀 Quick Start

### Prerequisites
```bash
- Flutter SDK 3.27.0 or higher
- Dart SDK 3.6.0 or higher
- Android Studio / VS Code with Flutter extensions
- Android Emulator or physical device
- Git
```

### Initial Setup

1. **Clone and Install**
```bash
# Ensure you are in the project root
flutter pub get
```

2. **Generate Code**
```bash
dart run build_runner build --delete-conflicting-outputs
```

3. **Run the App**
```bash
flutter run
# For hot reload: press 'r' in terminal
# For hot restart: press 'R'
```

4. **Configure API Keys** (Required for AI features)
   - Run the app and navigate to Settings → Debug Panel
   - Enter your Claude API key and/or Gemini API key
   - Set backend URL to `https://learn-smart.app` (default)

### Test Credentials
```
Email: test@example.com
Password: test123
```

---

## 🏗️ Architecture

### Clean Architecture Layers

```
lib/
├── app/               # App-level configuration
│   ├── routes.dart    # GoRouter navigation setup
│   └── theme.dart     # Material 3 theme configuration
├── core/              # Shared business logic
│   ├── constants/     # API endpoints, colors, etc.
│   ├── models/        # Domain models (Question, User, etc.)
│   ├── services/      # Core services (AI, Auth, Firestore)
│   └── utils/         # Helper functions
├── features/          # Feature modules
│   ├── auth/         # Authentication
│   ├── home/         # Main navigation & profile
│   ├── live_feed/    # Adaptive question feed
│   ├── learning_plan/# Topic selection & planning
│   ├── question_session/ # Question answering UI
│   ├── apps/         # GeoGebra, Content Library, etc.
│   ├── gamification/ # XP, coins, shop, themes
│   ├── settings/     # User preferences & debug
│   └── progress/     # Stats & analytics
└── shared/           # Reusable widgets

Feature Structure:
feature/
├── data/
│   ├── models/       # Data models (Freezed)
│   └── repositories/ # Data access (optional)
├── domain/
│   └── entities/     # Business entities (optional)
└── presentation/
    ├── providers/    # Riverpod state management
    ├── screens/      # Full-page views
    └── widgets/      # Feature-specific components
```

### State Management
- **Riverpod 2.x**: Primary state management
- **Freezed**: Immutable models with copy-with
- **AsyncValue**: Loading, error, and data states

### Navigation
- **GoRouter**: Declarative routing with Material 3 page transitions
- Custom expressive animations (400ms fade + scale)

---

## ✨ Key Features

### 1. Live Feed (Adaptive Learning)
**Location:** `lib/features/live_feed/`

- Real-time adaptive difficulty adjustment
- Question buffer for smooth UX
- Streak tracking and statistics
- AI-powered hint system

**Key Files:**
- `live_feed_screen.dart` - Main feed UI
- `feed_question_card.dart` - Question display with LaTeX
- `live_feed_providers.dart` - State management

### 2. Learning Plan
**Location:** `lib/features/learning_plan/`

- Hierarchical topic selection (Leitidee → Thema → Unterthema)
- Progress tracking per topic
- Smart mode with AI assessment

### 3. Question Sessions
**Location:** `lib/features/question_session/`

- Step-by-step questions with hints
- Multiple question types (MCQ, Fill-in, Step-by-step)
- LaTeX rendering with `flutter_math_fork`
- Answer evaluation with AI feedback

### 4. Apps Hub
**Location:** `lib/features/apps/`

- **GeoGebra Integration**: Interactive math visualizations
- **Content Library**: Save and organize learning materials
- **KI-Labor** (Generative Apps): AI-generated mini apps

### 5. Gamification System
**Location:** `lib/features/gamification/`

- XP and leveling system
- Daily streak tracking with freeze mechanic
- Coins earned from correct answers
- Shop with unlockable themes
- Animated coin rewards

### 6. Settings & Configuration
**Location:** `lib/features/settings/`

- AI model selection (Claude vs Gemini, tier selection)
- Theme customization (5+ presets + custom)
- Education settings (grade level, course type)
- Debug panel for developers
- Account management (password change, reset)

---

## 🛠️ Technology Stack

### Frontend
- **Flutter 3.27+**: Cross-platform framework
- **Material 3**: Modern design system
- **Google Sans Flex**: Primary font family

### State Management
- **Riverpod 2.6+**: Robust state management
- **Freezed**: Immutable data classes
- **Riverpod Annotation**: Code generation for providers

### Backend & Services
- **Firebase Auth**: User authentication
- **Cloud Firestore**: Database
- **Cloud Functions**: API backend at `https://learn-smart.app/api/`

### AI Services
- **Claude (Anthropic)**: Sonnet 4.5, Haiku 4.5
- **Gemini (Google)**: Pro 3, Flash 3

### Key Packages
```yaml
# Core
flutter_riverpod: ^2.6.1
riverpod_annotation: ^2.6.1
freezed: ^2.5.7
go_router: ^14.6.2

# UI
flutter_math_fork: ^0.7.2  # LaTeX rendering
google_fonts: ^6.2.1
flutter_svg: ^2.0.10

# Firebase
firebase_core: ^3.8.1
firebase_auth: ^5.3.4
cloud_firestore: ^5.5.2

# HTTP
dio: ^5.7.0

# Storage
shared_preferences: ^2.3.3
```

---

## 📁 Project Structure

### Important Files

```
slam-app/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── firebase_options.dart        # Firebase config
│   ├── app/
│   │   ├── routes.dart              # All app routes
│   │   └── theme.dart               # Theme configuration
│   ├── core/
│   │   ├── constants/
│   │   │   └── api_endpoints.dart   # Backend API endpoints
│   │   ├── models/
│   │   │   ├── question.dart        # Question model
│   │   │   └── user_stats.dart      # User statistics
│   │   └── services/
│   │       ├── ai_service.dart      # AI API wrapper
│   │       ├── auth_service.dart    # Firebase Auth
│   │       └── firestore_service.dart # Firestore operations
│   └── features/
│       ├── home/
│       │   ├── presentation/
│       │   │   ├── screens/
│       │   │   │   └── profil_screen.dart  # New profile tab
│       │   │   └── widgets/
│       │   │       └── main_navigation.dart # Bottom nav
│       └── [other features...]
├── docs/                            # Documentation
│   ├── feature-liste.md            # Feature documentation
│   ├── BACKEND_ANALYSIS.md         # Backend API reference
│   └── COMPLETION_STATUS.md        # Implementation status
├── test/                           # Unit tests
├── integration_test/               # Integration tests
├── pubspec.yaml                    # Dependencies
├── analysis_options.yaml           # Linter rules
└── TEST_PROTOCOL.md                # Test documentation
```

### Generated Files (Don't Edit)
```
**/*.g.dart         # Generated by build_runner
**/*.freezed.dart   # Generated by Freezed
```

---

## 🔄 Development Workflow

### Daily Development Cycle

1. **Pull Latest Changes**
```bash
git pull origin flutter-app
```

2. **Update Dependencies** (if pubspec.yaml changed)
```bash
flutter pub get
```

3. **Regenerate Code** (if models/providers changed)
```bash
dart run build_runner build --delete-conflicting-outputs
```

4. **Run App with Hot Reload**
```bash
flutter run
# Press 'r' for hot reload after changes
# Press 'R' for hot restart
# Press 'q' to quit
```

5. **Check for Issues**
```bash
flutter analyze
```

### Making Changes

**Editing Models (Freezed):**
```dart
// 1. Edit the model file
@freezed
class MyModel with _$MyModel {
  const factory MyModel({
    required String id,
    required String name,
  }) = _MyModel;

  factory MyModel.fromJson(Map<String, dynamic> json) =>
      _$MyModelFromJson(json);
}

// 2. Regenerate code
dart run build_runner build
```

**Adding a Provider (Riverpod):**
```dart
// 1. Add annotation
@riverpod
class MyNotifier extends _$MyNotifier {
  @override
  MyState build() => MyState.initial();

  void updateState() {
    state = state.copyWith(/* changes */);
  }
}

// 2. Regenerate code
dart run build_runner build
```

**Adding a New Route:**
```dart
// In lib/app/routes.dart
GoRoute(
  path: '/my-feature',
  name: 'myFeature',
  pageBuilder: (context, state) => buildPageWithExpressiveTransition(
    context: context,
    state: state,
    child: const MyFeatureScreen(),
  ),
),
```

---

## 🌐 Backend Integration

### API Configuration

**Base URL:** `https://learn-smart.app`

**Endpoints:** (Defined in `lib/core/constants/api_endpoints.dart`)

```dart
/api/generate-questions      # POST - Generate question session
/api/evaluate-answer         # POST - Evaluate user answer
/api/update-auto-mode        # POST - Update AI parameters
/api/custom-hint             # POST - Get personalized hint
/api/generate-geogebra       # POST - Generate GeoGebra visualization
/api/generate-mini-app       # POST - Generate interactive app
/api/manage-learning-plan    # POST - Learning plan operations
/api/manage-memories         # POST - Spaced repetition
/api/analyze-image           # POST - Image upload & analysis
```

### AI Service Usage

```dart
// Example: Generate questions
final aiService = ref.read(aiServiceProvider);
final session = await aiService.generateQuestions(
  apiKey: 'your-api-key',
  userId: currentUserId,
  learningPlanItemId: 123,
  topics: [
    TopicData(
      leitidee: 'Algebra',
      thema: 'Gleichungen',
      unterthema: 'Lineare Gleichungen',
    ),
  ],
  selectedModel: 'claude-sonnet-4-5-20250929',
  userContext: UserContext(
    gradeLevel: '11',
    courseType: 'Leistungskurs',
  ),
);
```

### Configuring Backend URL

**Debug Panel Method:**
1. Open app → Settings → Debug Panel
2. Enter custom backend URL
3. Quick buttons: Localhost / Production

**Code Method:**
```dart
// lib/features/settings/presentation/providers/settings_providers.dart
@override
DebugConfig build() {
  return const DebugConfig(
    backendUrl: 'https://learn-smart.app',
    // ... other config
  );
}
```

### Firebase Configuration

**Firestore Collections:**
```
users/
  {userId}/
    - displayName, email, photoURL
    - level, xp, coins
    - streakCount, lastActiveDate
    - settings (theme, education, etc.)

userStats/
  {userId}/
    - totalQuestions, correctAnswers
    - streakCurrent, streakBest
    - totalXP, coinsEarned

learningPlans/
  {planId}/
    - userId, topics[], createdAt
    - items[] (questions, progress)

questionSessions/
  {sessionId}/
    - userId, questions[], performance
    - completedAt, xpEarned

savedContent/
  {contentId}/
    - userId, title, content, type
    - category, tags[], createdAt
```

---

## 📝 Common Tasks

### Testing Features

**1. Test Live Feed:**
```bash
# Ensure API keys are configured in Debug Panel
# Navigate to Feed tab
# Click "Frage generieren"
# Answer questions to test adaptive difficulty
```

**2. Test AI Integration:**
```dart
// Add to debug panel or test screen
final debugConfig = ref.read(debugConfigNotifierProvider);
print('Claude Key: ${debugConfig.claudeApiKey.isNotEmpty}');
print('Gemini Key: ${debugConfig.geminiApiKey.isNotEmpty}');
print('Backend URL: ${debugConfig.backendUrl}');
```

**3. Test Navigation:**
```bash
# Use GoRouter navigation
context.go('/learning-plan');
context.push('/question-session/123');
context.pop();
```

### Debugging

**Enable Verbose Logging:**
1. Settings → Debug Panel
2. Toggle "Verbose Logging"
3. Check terminal output

**Firebase Auth State:**
```dart
final currentUser = ref.watch(currentUserProvider);
print('User: ${currentUser?.email}');
print('UID: ${currentUser?.uid}');
```

**Network Requests (Dio):**
```dart
// Already configured with logging interceptor in ai_service.dart
// Check terminal for request/response logs
```

### Building for Release

**Android:**
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

**iOS:**
```bash
flutter build ios --release
# Requires Mac with Xcode
```

---

## 🐛 Troubleshooting

### Common Issues

**1. Build Runner Errors**
```bash
# Clean generated files
flutter clean
rm -rf build/
find . -name "*.g.dart" -type f -delete
find . -name "*.freezed.dart" -type f -delete

# Regenerate
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

**2. Hot Reload Not Working**
```
Solution: Use Hot Restart (press 'R' instead of 'r')
Or: Stop app and run again with `flutter run`
```

**3. Firebase Auth Errors**
```dart
// Check Firebase configuration
final options = DefaultFirebaseOptions.currentPlatform;
print('Firebase Project: ${options.projectId}');

// Verify initialization in main.dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

**4. API Calls Failing**
```
Check:
1. Backend URL is correct (https://learn-smart.app)
2. API keys are configured in Debug Panel
3. Network connectivity is available
4. Check terminal for Dio error logs
```

**5. LaTeX Not Rendering**
```dart
// Ensure flutter_math_fork is up to date
// Use Math.tex() widget for LaTeX
import 'package:flutter_math_fork/flutter_math.dart';

Math.tex(
  r'x = \frac{-b \pm \sqrt{b^2-4ac}}{2a}',
  textStyle: TextStyle(fontSize: 20),
);
```

**6. Theme Not Updating**
```dart
// Check if theme is persisted to Firestore
final themeNotifier = ref.read(themeNotifierProvider.notifier);
await themeNotifier.setTheme(AppThemePreset.oceanBlue);

// Clear SharedPreferences cache if needed
final prefs = await SharedPreferences.getInstance();
await prefs.clear();
```

---

## 📐 Code Conventions

### Naming

- **Files:** `snake_case.dart`
- **Classes:** `PascalCase`
- **Variables/Functions:** `camelCase`
- **Constants:** `camelCase` (not SCREAMING_SNAKE_CASE)
- **Private:** Prefix with `_`

### File Organization

```dart
// 1. Imports (grouped and sorted)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:slam_app/core/models/question.dart';
import 'package:slam_app/features/settings/providers.dart';

// 2. Part directives
part 'my_file.g.dart';
part 'my_file.freezed.dart';

// 3. Public classes
class MyWidget extends ConsumerWidget { }

// 4. Private classes
class _MyPrivateWidget extends StatelessWidget { }

// 5. Providers (at end or in separate file)
@riverpod
class MyNotifier extends _$MyNotifier { }
```

### Widget Structure

```dart
class MyScreen extends ConsumerWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch providers at top
    final state = ref.watch(myProvider);
    final notifier = ref.read(myProvider.notifier);

    // 2. Build UI
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context, state),
    );
  }

  // 3. Private helper methods
  AppBar _buildAppBar(BuildContext context) { }
  Widget _buildBody(BuildContext context, MyState state) { }
}
```

### Riverpod Patterns

**Notifier for State:**
```dart
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;

  void increment() => state++;
  void decrement() => state--;
}
```

**FutureProvider for Async:**
```dart
@riverpod
Future<UserData> userData(UserDataRef ref, String userId) async {
  final firestore = ref.watch(firestoreServiceProvider);
  return firestore.getUserData(userId);
}
```

**StreamProvider for Realtime:**
```dart
@riverpod
Stream<UserStats> userStats(UserStatsRef ref, String userId) {
  final firestore = ref.watch(firestoreServiceProvider);
  return firestore.userStatsStream(userId);
}
```

### Error Handling

```dart
// Use AsyncValue for loading/error states
final dataAsync = ref.watch(myFutureProvider);

return dataAsync.when(
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => ErrorWidget(error),
  data: (data) => DataWidget(data),
);

// Try-catch for mutations
try {
  await ref.read(myProvider.notifier).performAction();
} catch (e) {
  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}
```

### Material 3 Colors

```dart
// Use theme colors, not hardcoded
final theme = Theme.of(context);

Container(
  color: theme.colorScheme.primary,           // Primary color
  child: Text(
    'Hello',
    style: theme.textTheme.headlineMedium,    // Typography
  ),
);

// For opacity, use withValues() not withOpacity()
color.withValues(alpha: 0.5)  // ✅ New
color.withOpacity(0.5)         // ❌ Deprecated
```

---

## 🎉 Project Status

### ✅ Completed Features

- ✅ Firebase Authentication (login, register, password reset)
- ✅ Material 3 UI with Google Sans Flex font
- ✅ Live Feed with adaptive difficulty
- ✅ Learning Plan with topic selection
- ✅ Question Sessions with LaTeX rendering
- ✅ GeoGebra integration
- ✅ Content Library
- ✅ Gamification system (XP, levels, coins, streaks)
- ✅ Shop with unlockable themes
- ✅ Settings and debug panel
- ✅ Profile screen with progress tracking
- ✅ Backend integration with learn-smart.app
- ✅ Smooth Material 3 Expressive animations

### 🚧 In Progress / Future Work

- 🚧 Collaborative Canvas/Whiteboard
- 🚧 Image upload to Learning Plan
- 🚧 Profile picture upload
- 🚧 Keyboard shortcuts
- 🚧 Offline mode improvements
- 🚧 Additional progress screen analytics
- 🚧 Comprehensive unit test coverage

---

## 🛑 Critical Patterns & Troubleshooting

### Critical Debugging Patterns

**1. API Key Persistence (Hybrid Storage Pattern)**
- **Problem:** Keys must work offline but sync to Firebase on login.
- **Solution:** Use BOTH SharedPreferences (local) AND Firebase (cloud).
- **Critical:** Use `.set(..., SetOptions(merge: true))` instead of `.update()` to avoid crashes on new documents.

**2. Optional Backend Fields**
- **Problem:** Backend might omit fields like `createdAt`.
- **Solution:** Mark these as nullable (`?`) in Freezed models.

**3. Debug Logging**
- **Style:** Use emoji prefixes for readability (e.g., 🔄 Loading, ✅ Success, ❌ Error).

### Common Pitfalls

**1. Riverpod Provider Confusion**
- `debugConfigNotifierProvider`: Local-only (avoid for keys).
- `appSettingsNotifierProvider`: Hybrid (Syncs to Cloud) -> **USE THIS for API Keys**.

**2. Firebase Auth State**
- Always check `ref.read(currentUserProvider)` before attempting Firestore writes.

**3. Hot Reload vs Restart**
- Provider changes often require a **Hot Restart (R)**, not just a Reload (r).

### Backend Reference
- **Repo:** `../slam-backend` (sibling directory)
- **Deployment:** Automatic via GitHub Actions on push to `main`.
- **Verify:** `curl https://api.learn-smart.app/`


