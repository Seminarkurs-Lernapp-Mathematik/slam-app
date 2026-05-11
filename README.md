<div align="center">

# SLAM
### Smart Learning Adaptive Mathematics

*Eine KI-gestützte Lern-App für Mathematik — entwickelt als Seminarkurs-Projekt am MVL-Gymnasium*

[![Flutter](https://img.shields.io/badge/Flutter-3.41-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android%20%7C%20Web-lightgrey?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Firestore%20%2B%20Auth-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)
[![Backend](https://img.shields.io/badge/Backend-live%20%40%20api.learn--smart.app-brightgreen)](https://api.learn-smart.app)

</div>

---

## Zahlen & Fakten

<table>
<tr>
<td align="center"><b>26.500</b><br><sub>Zeilen Dart<br>(handgeschrieben)</sub></td>
<td align="center"><b>171</b><br><sub>Git Commits<br>seit Sep 2025</sub></td>
<td align="center"><b>98</b><br><sub>Dart-Dateien<br>(+ 33 generiert)</sub></td>
<td align="center"><b>8</b><br><sub>Feature-Module</sub></td>
<td align="center"><b>44</b><br><sub>Flutter Packages</sub></td>
</tr>
</table>

> Gebaut in **~8 Monaten** — September 2025 bis heute.  
> Größte Einzeldatei: `feed_question_card.dart` mit **1.404 Zeilen**.

---

## Wer hat was gebaut?

| Autor | Commits | |
|:---|:---:|:---|
| Marco Duzevic | 141 | `████████████████░░░` 83 % |
| TheMDcraft | 25 | `███░░░░░░░░░░░░░░░░░` 15 % |
| joel12055 | 3 | `░░░░░░░░░░░░░░░░░░░░` 2 % |
| emmilang09 | 1 | `░░░░░░░░░░░░░░░░░░░░` < 1 % |

---

## Technologien

```
Dart / Flutter   ████████████████████████████████████████   77 %   26.500 Zeilen
TypeScript       ████████████                               23 %    7.900 Zeilen  (Backend)
```

| Bereich | Stack |
|:---|:---|
| Framework | Flutter 3.41 · Dart 3.6 |
| State Management | Riverpod 2.6 mit Code-Generierung (`@riverpod`) |
| Modelle | Freezed + `json_serializable` |
| Navigation | GoRouter mit Material-3-Übergängen |
| Auth | Firebase Authentication (Domain-Lock `@mvl-gym.de`) |
| Datenbank | Cloud Firestore (Offline-first, 3-Layer-Cache) |
| LaTeX | `flutter_math_fork` — native, kein WebView |
| Gamification | Eigenes XP/Level/Streak/Coin-System |

---

## Was steckt drin?

**Live Feed** — Adaptiver Fragenstream mit SM-2-Spaced-Repetition. Eine KI generiert im Hintergrund 10 Fragen pro Batch, die in einem dreistufigen Cache (RAM → SharedPreferences → Firestore) vorgehalten werden, damit beim App-Start sofort Fragen da sind.

**Gamification** — XP-System mit exponentiellem Level-Wachstum, Coin-Shop für Themes und Streak-Freezes, tägliche Streak-Verfolgung und Animationen (Partikel-Burst bei Richtigantwort).

**KI-Labor** — Per Prompt wird eine interaktive HTML/JS-Mini-App generiert, die direkt in einem WebView läuft. Für GeoGebra-Applets gibt es einen eigenen Endpunkt mit strikter Scripting-Syntax.

**Erinnerungen** — Der Backend-Dienst `manageMemories` implementiert den SM-2-Algorithmus: Intervall, Ease-Factor und Repetitions werden pro Frage gespeichert und bei der nächsten Fragengenerierung als Kontext mitgegeben.

**Lernplan** — Themenbaum nach Leitideen des bayerischen Lehrplans. Foto hochladen → KI extrahiert Aufgaben und mappt sie auf Katalogthemen.

**Lehrer-Dashboard** — XAI-Analysen (Explainable AI) pro Schüler: Stärken und Schwächen belegt mit konkreten Aufgaben-Referenzen.

---

## Quick Start

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run                   # -d chrome  für Web
```

API-Key und Backend-URL nach dem ersten Start unter **Einstellungen** konfigurieren.

---

## Verwandte Repos

| Repo | Beschreibung |
|:---|:---|
| **[slam-backend](https://github.com/Seminarkurs-Lernapp-Mathematik/slam-backend)** | Cloudflare Workers API — 5 KI-Anbieter, 12 Tasks |
| **[Dokumentation](https://learn-smart.app)** | Projektdokumentation & Deployment-Guides |

---

## Projektstruktur

```
lib/
├── app/              → Router, Theme, Design-Tokens (SlamTokens)
├── core/
│   ├── models/       → Freezed-Modelle (Question, UserStats, Memory …)
│   └── services/     → Auth, Firestore, AI-Service
└── features/
    ├── live_feed/    → Adaptiver Fragenstream + Queue-System
    ├── gamification/ → Shop, XP, Streak, Animationen
    ├── apps/         → KI-Labor, GeoGebra, Content Library
    ├── auth/         → Login, Register, Onboarding
    ├── home/         → Navigation, Profil
    ├── learning_plan/→ Themenauswahl + Bildanalyse
    ├── settings/     → Theme, Klassenstufe, KI-Erinnerungen
    └── question_session/ → Aufgaben-Flow
```

---

<div align="center">
<sub>© 2025–2026 MVL-Gymnasium · Seminarkurs Informatik</sub>
</div>
