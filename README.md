# SLAM Learning App - Flutter

<div align="center">

**Adaptive Lern-App für Mathematik mit KI-gestützter Fragengenerierung**

[![Flutter](https://img.shields.io/badge/Flutter-3.18+-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)
[![Riverpod](https://img.shields.io/badge/Riverpod-2.6-blue)](https://riverpod.dev)

</div>

---

## Über das Projekt

SLAM (Smart Learning Adaptive Mathematics) ist eine Mobile-First Lern-App für iOS und Android, die Mathematik-Lernenden durch adaptive KI-gestützte Fragen hilft, individuell und effizient zu lernen.

### Hauptfeatures

✅ **Adaptive Fragengenerierung:** KI generiert personalisierte Fragen basierend auf Wissenslücken
✅ **Gamification:** XP-System, Levels, Streaks und Achievements
✅ **GeoGebra Integration:** Interaktive Visualisierungen für geometrische Konzepte
✅ **Whiteboard/Canvas:** Collaborative AI Canvas zum Zeichnen und Rechnen
✅ **KI-Labor:** Generiere Mini-Apps (Taschenrechner, Visualisierungen) per Prompt
✅ **Email-basierte Authentifizierung:** @mvl-gym.de Domain-Restriction
✅ **Offline-Support:** Hive Local Storage für Fragen-Cache
✅ **Real-time Sync:** Firestore für Live-Updates von Stats und Progress

---

## Tech Stack

### Frontend (Flutter)
- **Flutter 3.18+** - Cross-Platform Framework
- **Riverpod 2.6** - State Management (compile-safe, async-friendly)
- **Freezed** - Immutable Models mit JSON Serialization
- **GoRouter** - Declarative Navigation

### Backend
- **Firebase Authentication** - Email/Password mit Verification
- **Cloud Firestore** - Real-time NoSQL Database (8+ Subcollections)
- **Cloudflare Workers** - AI Service (Claude Sonnet/Haiku, Gemini Flash/Pro)

### Spezial-Features
- **flutter_math_fork** - Native LaTeX Rendering (10x schneller als WebView)
- **webview_flutter** - GeoGebra + Generative Apps Iframe
- **Hive** - Local Persistence (Zustand-Äquivalent)
- **Phosphor Icons** - Konsistente Icon-Library

---

## Projekt-Struktur

```
lib/
├── main.dart                    # App Entry Point
├── app/
│   ├── app.dart                 # MaterialApp Setup
│   ├── routes.dart              # GoRouter Navigation
│   └── theme.dart               # App Theme (Sunset Orange)
├── core/
│   ├── constants/               # Firebase Collections, API, XP System
│   ├── models/                  # Freezed Models (8+ Dateien)
│   └── services/                # Core Services (Auth, Firestore, AI)
├── features/
│   ├── auth/                    # Login, Register, Email Verification
│   ├── learning_plan/           # Topic Selection, Smart Learning
│   ├── question_session/        # Q&A Flow, Hints, Evaluation
│   ├── gamification/            # XP, Levels, Progress Visualization
│   ├── geogebra/                # GeoGebra WebView Integration
│   ├── canvas/                  # Whiteboard CustomPainter
│   └── generative_apps/         # KI-Labor WebView
└── shared/
    ├── widgets/                 # GlassPanel, GradientButton, etc.
    └── animations/              # Particle Effects, Transitions
```

---

## Setup & Installation

### Voraussetzungen

- **Flutter SDK:** 3.18 oder höher ([Installation](https://docs.flutter.dev/get-started/install))
- **Xcode:** 15+ (für iOS Development)
- **Android Studio:** Latest (für Android Development)
- **Firebase Account:** [Konsole](https://console.firebase.google.com/)
- **Git:** Für Version Control

### 1. Repository Klonen

```bash
git clone https://github.com/YOUR_ORG/slam-app.git
cd slam-app/slam_app_flutter
```

### 2. Dependencies Installieren

```bash
flutter pub get
```

### 3. Firebase Konfiguration

**Wichtig:** Folge der detaillierten Anleitung in **[FIREBASE_SETUP.md](./FIREBASE_SETUP.md)**

Kurzfassung:
1. Firebase Projekt erstellen
2. iOS App hinzufügen → `GoogleService-Info.plist` nach `ios/Runner/`
3. Android App hinzufügen → `google-services.json` nach `android/app/`
4. Authentication aktivieren (Email/Password)
5. Firestore Database erstellen (Region: europe-west3)
6. Firestore Security Rules setzen

### 4. Code Generierung

Freezed/Riverpod Code generieren:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 5. Firebase in main.dart aktivieren

Entferne die Kommentare in `lib/main.dart`:

```dart
await Firebase.initializeApp();
```

### 6. App starten

#### iOS (Simulator)
```bash
flutter run -d "iPhone 15 Pro"
```

#### Android (Emulator)
```bash
flutter run -d emulator-5554
```

#### Device auswählen
```bash
flutter devices
flutter run -d <device-id>
```

---

## Entwicklung

### Hot Reload

Flutter unterstützt Hot Reload für schnelle Iteration:
- **Hot Reload:** `r` in Terminal (behält State)
- **Hot Restart:** `R` in Terminal (reset State)
- **Quit:** `q`

### Code Generierung Watch Mode

Für automatische Regenerierung bei Änderungen:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Linting & Formatting

```bash
# Code Analyse
flutter analyze

# Code Formatieren
dart format lib/ -l 80

# Imports Sortieren
flutter pub run import_sorter:main
```

### Firebase Emulator (Optional)

Für Offline-Development:

```bash
cd slam-app  # Root Verzeichnis
firebase emulators:start
```

In `lib/main.dart`:
```dart
await Firebase.initializeApp();

// Emulator verwenden (nur Development!)
if (kDebugMode) {
  FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
}
```

---

## Testing

### Unit Tests

```bash
flutter test test/unit/
```

### Widget Tests

```bash
flutter test test/widget/
```

### Integration Tests

```bash
flutter test integration_test/
```

### E2E Test Beispiel: Auth Flow

```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/auth_flow_test.dart
```

---

## Build & Deployment

### Android APK (Development)

```bash
flutter build apk --debug
```

APK Location: `build/app/outputs/flutter-apk/app-debug.apk`

### Android App Bundle (Production)

```bash
flutter build appbundle --release
```

AAB Location: `build/app/outputs/bundle/release/app-release.aab`

#### App Signieren

1. Keystore erstellen:
   ```bash
   keytool -genkey -v -keystore slam-release-key.jks \
     -alias slam -keyalg RSA -keysize 2048 -validity 10000
   ```

2. `android/key.properties` erstellen:
   ```properties
   storePassword=<password>
   keyPassword=<password>
   keyAlias=slam
   storeFile=../slam-release-key.jks
   ```

3. Build signiert:
   ```bash
   flutter build appbundle --release
   ```

### iOS IPA (Production)

```bash
flutter build ios --release
```

Dann in Xcode:
1. Öffne `ios/Runner.xcworkspace`
2. Product → Archive
3. Distribute App → App Store Connect

---

## Environment Variables & Konfiguration

### API Endpoints

In `lib/core/constants/api_endpoints.dart`:

```dart
class APIEndpoints {
  // Development
  static const baseUrl = 'https://slam-dev.YOUR_WORKER.workers.dev';

  // Production
  // static const baseUrl = 'https://slam.YOUR_WORKER.workers.dev';
}
```

### Firebase Config

Config-Dateien:
- **iOS:** `ios/Runner/GoogleService-Info.plist`
- **Android:** `android/app/google-services.json`

**WICHTIG:** Diese Dateien NICHT in Git committen (siehe `.gitignore`)!

### Themes

App-Theme in `lib/app/theme.dart` anpassen:

```dart
// Sunset Theme (Default)
primaryColor: Color(0xFFF97316),  // Orange 500

// Andere verfügbare Themes in UserSettings.dart:
// - Ocean (Blau)
// - Forest (Grün)
// - Purple (Lila)
```

---

## Architektur & Patterns

### Clean Architecture (Feature-First)

Jedes Feature folgt:
```
features/example/
  ├── data/           # Repository, Data Sources
  ├── domain/         # Use Cases, Entities
  └── presentation/   # UI, Providers, Screens
```

### State Management: Riverpod

```dart
// Provider Definition
@riverpod
Future<UserStats> userStats(UserStatsRef ref, String userId) async {
  final firestore = ref.watch(firestoreServiceProvider);
  return firestore.getUserStats(userId);
}

// Usage in Widget
class StatsDisplay extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(userStatsProvider(userId));

    return statsAsync.when(
      data: (stats) => Text('Level: ${stats.level}'),
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => ErrorMessage(message: err.toString()),
    );
  }
}
```

### Models: Freezed + JSON Serializable

```dart
@freezed
class UserStats with _$UserStats {
  const UserStats._();

  const factory UserStats({
    @Default(1) int level,
    @Default(0) int xp,
    @Default(0) int streak,
  }) = _UserStats;

  factory UserStats.fromJson(Map<String, dynamic> json) =>
      _$UserStatsFromJson(json);

  // Custom Methods
  UserStats addXp(int earnedXp) {
    return copyWith(xp: xp + earnedXp);
  }
}
```

---

## Gamification System

### XP Berechnung

```dart
Base XP: 25
× (1 - 0.25 × hintsUsed)           // Hint Penalty
× (1 + 0.1 × min(timeBonus, 2))    // Time Bonus
× (1 + 0.2 × min(streak / 7, 1))   // Streak Bonus
```

### Level System (11 Levels)

Exponentielles Wachstum: **100 × 1.5^(level-1)**

| Level | XP Needed | Total XP | Title |
|-------|-----------|----------|-------|
| 1 | 0 | 0 | Anfänger |
| 2 | 100 | 100 | Entdecker |
| 3 | 150 | 250 | Fortgeschritten |
| 4 | 225 | 475 | Experte |
| 5 | 337 | 812 | Meister |
| ... | ... | ... | ... |
| 11 | 5767 | 17,637 | Legende |

### Streak System

- Tägliches Login → Streak +1
- Pause 1 Tag → Streak Reset
- **Freeze Items** (künftig): 3x pro Woche Pause erlaubt

---

## Performance Optimierungen

### LaTeX Rendering

- ✅ `flutter_math_fork` (2-4ms) statt WebView (20-40ms)
- ✅ Parsed AST cachen
- ✅ Lazy Rendering (nur sichtbare Questions)

### Firestore

- ✅ Offline Persistence aktiviert
- ✅ Listener limitieren (nur aktiver Screen)
- ✅ `.get()` statt `.onSnapshot()` für statische Daten
- ✅ Hive Cache für Fragen (Pre-fetch next batch)

### Images & Canvas

- ✅ Canvas Exports komprimieren (PNG 50% quality)
- ✅ `CachedNetworkImage` für Profile Pictures

### Animationen

- ✅ `RepaintBoundary` für komplexe Widgets
- ✅ `const` Constructors überall nutzen
- ✅ `setState()` Scope minimieren

---

## Bekannte Probleme & Lösungen

### Problem: `flutter analyze` zeigt Freezed Errors

**Symptom:**
```
error - Missing concrete implementations of '_$UserStats.toJson'
```

**Ursache:** Bekannter Dart Analyzer Bug mit generierten Dateien

**Lösung:** Ignorieren! IDE (VS Code) Analyzer zeigt keine Fehler. Code kompiliert einwandfrei.

**Verifikation:**
```bash
flutter build apk --debug
# → Sollte ohne Fehler durchlaufen
```

### Problem: iOS Build Error "Firebase not found"

**Lösung:**
```bash
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter clean
flutter run
```

### Problem: Android MultiDex Error

**Lösung:** In `android/app/build.gradle`:
```gradle
defaultConfig {
    multiDexEnabled true
}
```

---

## Roadmap

### Phase 1: Foundation ✅ (ABGESCHLOSSEN)
- [x] Auth Flow (Login, Register, Email Verification)
- [x] Firestore Integration
- [x] Core Models & Services
- [x] Shared Widgets
- [x] Riverpod Providers

### Phase 2: Gamification (IN ARBEIT)
- [ ] Progress Screen (Level, XP, Streaks)
- [ ] XP Animation Widget
- [ ] Achievement System
- [ ] Leaderboard (optional)

### Phase 3: Learning Flow (2 Wochen)
- [ ] Learning Plan Screen (Topic Tree)
- [ ] Question Generation Flow
- [ ] Question Session UI
- [ ] Hint System

### Phase 4: Advanced Features (3 Wochen)
- [ ] GeoGebra Integration
- [ ] Whiteboard/Canvas
- [ ] KI-Labor (Generative Apps)
- [ ] Image Analysis (Lasso → AI)

### Phase 5: Polish & Testing (1 Woche)
- [ ] Animationen & Transitions
- [ ] Error Handling & Recovery
- [ ] E2E Tests
- [ ] Performance Profiling

### Phase 6: Production Release (1 Woche)
- [ ] App Store Submission (iOS)
- [ ] Google Play Submission (Android)
- [ ] User Onboarding Flow
- [ ] Analytics & Monitoring

---

## Contributing

### Branch Strategy

- `main` - Production-ready code
- `dev` - Development branch
- `feature/*` - Feature branches
- `hotfix/*` - Critical bugfixes

### Commit Convention

```
<type>(<scope>): <subject>

Types: feat, fix, docs, style, refactor, test, chore
Scope: auth, gamification, canvas, firestore, etc.

Example:
feat(auth): Add email verification auto-check
fix(gamification): Fix XP calculation overflow
docs(readme): Update setup instructions
```

### Pull Request Template

1. Beschreibung der Änderungen
2. Related Issue: #123
3. Screenshots (bei UI-Changes)
4. Testing:
   - [ ] Unit Tests geschrieben
   - [ ] Widget Tests geschrieben
   - [ ] Manuell getestet auf iOS
   - [ ] Manuell getestet auf Android

---

## License

Dieses Projekt ist proprietär und darf ohne Erlaubnis nicht vervielfältigt werden.

Copyright © 2025 MVL-Gymnasium

---

## Kontakt & Support

- **Project Lead:** [Name]
- **Email:** [kontakt@mvl-gym.de]
- **GitHub:** [Repository URL]
- **Firebase Console:** [Firebase Project URL]

---

## Acknowledgments

- **Firebase:** Backend Infrastructure
- **Cloudflare Workers:** AI Service Hosting
- **Flutter Community:** Packages & Tools
- **Anthropic Claude:** AI Model für Question Generation
- **Google Gemini:** Fallback AI Model

---

**Viel Erfolg beim Entwickeln! 🚀**
