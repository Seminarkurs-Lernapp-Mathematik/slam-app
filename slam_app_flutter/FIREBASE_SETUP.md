# Firebase Setup Guide für SLAM App

Diese Anleitung erklärt, wie du Firebase für die SLAM Flutter App konfigurierst.

## Voraussetzungen

- Google-Account
- Flutter SDK installiert (Version 3.18+)
- Xcode (für iOS) oder Android Studio (für Android)

---

## 1. Firebase Projekt erstellen

### 1.1 Neues Projekt anlegen

1. Gehe zu [Firebase Console](https://console.firebase.google.com/)
2. Klicke auf **"Projekt hinzufügen"**
3. Projektname: **SLAM Learning App** (oder beliebiger Name)
4. Google Analytics: **Optional** (empfohlen für Production)
5. Warte, bis das Projekt erstellt wurde

### 1.2 Upgrade auf Blaze Plan (Optional für Production)

Für Production mit vielen Nutzern:
1. Gehe zu **"Upgrade"** in der Firebase Console
2. Wähle **"Blaze (Pay as you go)"** Plan
3. Setze Budgetalarme (empfohlen: €10-20/Monat für Entwicklung)

---

## 2. Firebase Authentication einrichten

### 2.1 Email/Password Authentication aktivieren

1. In Firebase Console: **Authentication** → **Get Started**
2. Tab **"Sign-in method"**
3. Aktiviere **"Email/Password"**
4. Speichern

### 2.2 Email-Templates konfigurieren (Optional)

1. **Authentication** → **Templates**
2. Passe **"E-Mail-Adresse bestätigen"** Template an:
   - Absendername: "SLAM Learning App"
   - Betreffzeile: "Verifiziere deine E-Mail-Adresse"

---

## 3. Cloud Firestore einrichten

### 3.1 Firestore Database erstellen

1. In Firebase Console: **Firestore Database** → **Create database**
2. Wähle **"Start in production mode"** (wir setzen später custom rules)
3. Region: **europe-west3** (Frankfurt) - WICHTIG für DSGVO!
4. Warte auf Initialisierung

### 3.2 Sicherheitsregeln setzen

Gehe zu **Firestore** → **Rules** und ersetze die Regeln mit:

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {

    // Helper Functions
    function isAuthenticated() {
      return request.auth != null;
    }

    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }

    function isValidEmail() {
      return isAuthenticated() &&
             request.auth.token.email.matches('.*@mvl-gym\\.de$');
    }

    // Users Collection
    match /users/{userId} {
      allow read: if isOwner(userId) && isValidEmail();
      allow create: if isOwner(userId) && isValidEmail();
      allow update: if isOwner(userId) && isValidEmail();

      // User Stats Subcollection
      match /stats/{document=**} {
        allow read, write: if isOwner(userId) && isValidEmail();
      }

      // User Settings Subcollection
      match /settings/{document=**} {
        allow read, write: if isOwner(userId) && isValidEmail();
      }

      // Generated Questions Subcollection
      match /generatedQuestions/{document=**} {
        allow read, write: if isOwner(userId) && isValidEmail();
      }

      // Question Progress Subcollection
      match /questionProgress/{document=**} {
        allow read, write: if isOwner(userId) && isValidEmail();
      }

      // Topic Progress Subcollection
      match /topicProgress/{document=**} {
        allow read, write: if isOwner(userId) && isValidEmail();
      }

      // Learning Sessions Subcollection
      match /learningSessions/{document=**} {
        allow read, write: if isOwner(userId) && isValidEmail();
      }

      // Learning Plan Subcollection
      match /learningPlan/{document=**} {
        allow read, write: if isOwner(userId) && isValidEmail();
      }

      // Generated Apps Subcollection
      match /generatedApps/{document=**} {
        allow read, write: if isOwner(userId) && isValidEmail();
      }
    }
  }
}
```

**Wichtig:** Diese Rules erlauben nur Zugriff für verifizierte @mvl-gym.de Email-Adressen!

### 3.3 Indexes erstellen

Firestore erstellt automatisch Single-Field-Indexes. Für komplexe Queries brauchst du Composite Indexes:

Gehe zu **Firestore** → **Indexes** und erstelle:

#### Index 1: Question Progress Query
- Collection: `users/{userId}/questionProgress`
- Fields:
  - `completedAt` (Descending)
  - `correct` (Ascending)

#### Index 2: Topic Progress Query
- Collection: `users/{userId}/topicProgress`
- Fields:
  - `lastAccessed` (Descending)
  - `avgAccuracy` (Ascending)

**Hinweis:** Indexes werden beim ersten Query-Fehler automatisch vorgeschlagen. Du kannst sie dann on-demand erstellen.

---

## 4. iOS App hinzufügen

### 4.1 App in Firebase registrieren

1. In Firebase Console: **Projekteinstellungen** (Zahnrad-Icon)
2. Unter **"Deine Apps"** → **iOS Icon** klicken
3. **iOS Bundle ID:** `de.mvl-gym.slam` (WICHTIG: Exakt diese verwenden!)
4. App-Spitzname: **SLAM App iOS**
5. App Store-ID: Leer lassen (für später)
6. **"App registrieren"** klicken

### 4.2 GoogleService-Info.plist herunterladen

1. Lade **GoogleService-Info.plist** herunter
2. Speichere die Datei in:
   ```
   slam_app_flutter/ios/Runner/GoogleService-Info.plist
   ```

### 4.3 Xcode Konfiguration

1. Öffne Xcode:
   ```bash
   cd slam_app_flutter/ios
   open Runner.xcworkspace
   ```

2. Füge GoogleService-Info.plist hinzu:
   - Rechtsklick auf **Runner** Ordner
   - **"Add Files to Runner..."**
   - Wähle **GoogleService-Info.plist**
   - **WICHTIG:** Aktiviere **"Copy items if needed"**

3. Bundle Identifier prüfen:
   - Wähle **Runner** im Project Navigator
   - Tab **"Signing & Capabilities"**
   - Bundle Identifier: **de.mvl-gym.slam**

### 4.4 iOS Deployment Target

Stelle sicher, dass das Minimum iOS Version korrekt ist:
1. In Xcode: Runner → **General**
2. **Deployment Target:** iOS 12.0 (oder höher)

---

## 5. Android App hinzufügen

### 5.1 App in Firebase registrieren

1. In Firebase Console: **Projekteinstellungen**
2. Unter **"Deine Apps"** → **Android Icon** klicken
3. **Android-Paketname:** `de.mvl_gym.slam`
4. App-Spitzname: **SLAM App Android**
5. Debug-Signaturzertifikat SHA-1: **Optional** (für später)
6. **"App registrieren"** klicken

### 5.2 google-services.json herunterladen

1. Lade **google-services.json** herunter
2. Speichere die Datei in:
   ```
   slam_app_flutter/android/app/google-services.json
   ```

### 5.3 Android Package Name prüfen

Öffne `android/app/build.gradle` und prüfe:

```gradle
android {
    namespace = "de.mvl_gym.slam"
    ...
    defaultConfig {
        applicationId = "de.mvl_gym.slam"
        minSdk = 21  // Android 5.0
        targetSdk = flutter.targetSdkVersion
        ...
    }
}
```

### 5.4 MultiDex aktivieren (falls nötig)

Für Apps mit vielen Dependencies in `android/app/build.gradle`:

```gradle
android {
    defaultConfig {
        ...
        multiDexEnabled true
    }
}

dependencies {
    implementation 'androidx.multidex:multidex:2.0.1'
}
```

---

## 6. Firebase in Flutter Code initialisieren

### 6.1 main.dart anpassen

Öffne `lib/main.dart` und entferne die Kommentare:

```dart
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialisieren
  await Firebase.initializeApp();

  // Hive für lokales Caching
  await Hive.initFlutter();

  runApp(const ProviderScope(child: SLAMApp()));
}
```

---

## 7. Testen

### 7.1 iOS Test

```bash
cd slam_app_flutter
flutter run -d ios
```

Prüfe in der Console:
```
✓ Firebase initialized successfully
```

### 7.2 Android Test

```bash
cd slam_app_flutter
flutter run -d android
```

Prüfe in der Console:
```
✓ Firebase initialized successfully
```

### 7.3 Authentication Test

1. Starte die App
2. Registriere einen Test-User:
   - Email: **test@mvl-gym.de**
   - Password: **Test1234**
3. Prüfe in Firebase Console → **Authentication** → **Users**:
   - User sollte erscheinen mit Status "Email not verified"
4. Öffne Email und verifiziere (im Emulator: Prüfe Logs)
5. Nach Verifizierung sollte Navigation zu `/home` erfolgen

---

## 8. Firestore Test

### 8.1 User Profile initialisieren

Nach erfolgreicher Registrierung sollten automatisch folgende Dokumente erstellt werden:

```
users/{userId}/
  ├─ (root doc mit: displayName, email, createdAt)
  ├─ stats/{statsDoc}  (level, xp, streak, ...)
  └─ settings/{settingsDoc}  (theme, aiModel, ...)
```

### 8.2 Manueller Test

In Firebase Console → **Firestore** → **users** Collection:
- Sollte nach Registrierung einen neuen User sehen
- Öffne User-Dokument → Sollte Subcollections sehen

---

## 9. Troubleshooting

### Problem: "Firebase not initialized"

**Lösung:** Prüfe, dass `Firebase.initializeApp()` in `main()` VOR `runApp()` aufgerufen wird.

### Problem: "Invalid iOS bundle ID"

**Lösung:** Bundle ID in Xcode muss EXAKT mit Firebase übereinstimmen: `de.mvl-gym.slam`

### Problem: "Android package name mismatch"

**Lösung:** Prüfe `android/app/build.gradle` → `applicationId` und `namespace` müssen `de.mvl_gym.slam` sein.

### Problem: "Email domain not allowed"

**Lösung:**
1. Prüfe `AuthService.isValidEmail()` in `lib/core/services/auth_service.dart`
2. Für Testing: Temporär andere Domains erlauben oder Test-Email mit @mvl-gym.de nutzen

### Problem: "Permission denied" in Firestore

**Lösung:**
1. Prüfe Firestore Rules (siehe 3.2)
2. Stelle sicher, dass User Email verifiziert ist
3. Prüfe, dass Email @mvl-gym.de Domain hat

### Problem: iOS Build Fehler "GoogleService-Info.plist not found"

**Lösung:**
1. Prüfe, dass Datei in `ios/Runner/` liegt
2. In Xcode: File Inspector → Target Membership → **Runner** aktiviert
3. Clean Build: `flutter clean && cd ios && pod install && cd ..`

### Problem: Android Build Fehler "google-services.json not found"

**Lösung:**
1. Prüfe, dass Datei in `android/app/` liegt (NICHT `android/`)
2. Build neu ausführen: `flutter clean && flutter build apk`

---

## 10. Production Checklist

Vor dem Release:

- [ ] Firestore Rules überprüfen (keine `allow read, write: if true;`!)
- [ ] Email-Verification aktiviert und getestet
- [ ] Budget Alerts in Firebase Console gesetzt
- [ ] Firestore Indexes für alle komplexen Queries erstellt
- [ ] iOS App mit korrektem Bundle ID und Provisioning Profile
- [ ] Android App signiert mit Release Key
- [ ] Firebase Analytics aktiviert (für Usage Monitoring)
- [ ] Crashlytics konfiguriert (für Error Tracking)
- [ ] Performance Monitoring aktiviert

---

## Nächste Schritte

Nach erfolgreichem Setup:

1. **Phase 1 abschließen:** README.md mit allgemeiner Setup-Anleitung
2. **Phase 2 starten:** Gamification UI (Progress Screen, XP Animations)
3. **Cloudflare Workers:** AI Service Endpoints testen
4. **Testing:** E2E Tests für Auth Flow schreiben

---

## Support

Bei Problemen:
- Firebase Dokumentation: https://firebase.google.com/docs
- FlutterFire: https://firebase.flutter.dev
- GitHub Issues: [Projekt Repository]
