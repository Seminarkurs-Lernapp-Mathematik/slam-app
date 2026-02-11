# SLAM App - Comprehensive Overhaul Plan

## Context

The SLAM Flutter app has many features wired up but relies heavily on hardcoded mock data, stub backend endpoints, and missing integrations. The user wants a complete overhaul: a working Lernplan system that drives the Feed, removal of all mock data, backend endpoint implementations for KI-Labor/GeoGebra/hints, auto-mode for adaptive learning, server-side purchase validation, education settings fixes, and Material 3 Expressive polish everywhere.

---

## Sprint 1: Foundation & Quick Fixes

### 1.1 Replace "App Center" with "Lernplan" on Profile
**File:** `lib/features/home/presentation/screens/profil_screen.dart`
- Change App Center button (line ~136) to "Lernplan" button with `Icons.menu_book`
- Navigate to `/lernplan` instead of opening command center modal

### 1.2 Create Lernplan Data Model
**New file:** `lib/core/models/lernplan.dart`
- Freezed model: `Lernplan` with `id`, `userId`, `topics` list, `createdAt`, `updatedAt`
- `LernplanTopic`: `leitidee`, `thema`, `unterthema`, `addedAt`, `source` (manual/upload)
- Run `dart run build_runner build`

### 1.3 Lernplan Firestore + Provider
**File:** `lib/core/services/firestore_service.dart`
- Add `saveLernplan()`, `getLernplanStream()`, `addTopics()`, `removeTopic()`
- Store at `users/{uid}` document field `lernplan` (or subcollection)

**New file:** `lib/features/learning_plan/presentation/providers/lernplan_providers.dart`
- `lernplanStreamProvider` - real-time Firestore stream
- `lernplanNotifierProvider` - add/remove topics, persist to Firestore
- `lernplanTopicsAsTopicDataProvider` - converts to `List<TopicData>` for AI service

### 1.4 Topic Catalog Constant
**New file:** `lib/core/constants/topic_catalog.dart`
- Move 15 hardcoded topics from `topic_tree.dart` (lines 18-71) to proper constant
- Organized by Leitidee > Thema > Unterthema (German math curriculum)

### 1.5 Conditional Kursart Selector
**File:** `lib/features/settings/presentation/widgets/education_settings.dart`
- Only show Kursart dropdown when grade is "11" or "12"
- Set internally to "nicht zutreffend" for other grades
- Fix "Leistungsfach" vs "Leistungskurs" mismatch

### 1.6 Debug Panel - Force Model Refresh + Show Default
**File:** `lib/features/settings/presentation/widgets/model_selection_panel.dart`
- Invalidate `availableModelsProvider` when panel builds (force re-fetch)
- Change hint from "Standard verwenden" to "Standard (Claude Sonnet 4.5)" showing actual model

### 1.7 Auto-Mode Default to Enabled
**File:** `lib/features/settings/presentation/providers/settings_providers.dart`
- Set `autoMode: true` in default `AppSettings` constructor

---

## Sprint 2: Lernplan Screen & Feed Integration

### 2.1 Lernplan Screen (New)
**New file:** `lib/features/learning_plan/presentation/screens/lernplan_screen.dart`
- Two sections:
  - **Themen manuell hinzufuegen**: Browse topic catalog, tap to add to Lernplan
  - **Themenliste hochladen**: Image upload placeholder (analyze-image stub)
- Current Lernplan display with swipe-to-delete
- Empty state: "Fuege Themen hinzu, um im Feed Fragen zu erhalten"
- M3 Expressive design (GlassPanel, proper colors, animations)

### 2.2 Add Route
**File:** `lib/app/routes.dart`
- Add `/lernplan` route to GoRouter

### 2.3 Feed Reads from Lernplan (Critical)
**File:** `lib/features/live_feed/presentation/screens/live_feed_screen.dart`
- Remove hardcoded topics (lines 86-97) - read from `lernplanTopicsAsTopicDataProvider`
- Remove demo question fallback (lines 126-236) entirely
- Read education settings (grade, course) from `appSettingsNotifierProvider`
- Read API key from `appSettingsNotifierProvider` (hybrid storage)
- Show empty state when Lernplan has no topics

**File:** `lib/features/live_feed/presentation/providers/live_feed_providers.dart`
- Depend on `lernplanTopicsAsTopicDataProvider` for topics
- Block generation if topics list is empty

### 2.4 Remove ALL Mock Data
- `live_feed_screen.dart` - Remove 3 demo questions fallback
- `question_session_providers.dart` - Remove `demoQuestionsProvider` (lines 111-171)
- `learning_plan_screen.dart` - Remove simulated generation, link to real Lernplan
- `topic_tree.dart` - Remove inline hardcoded topics (use catalog constant)
- Show proper error states everywhere instead of fake data

---

## Sprint 3: Backend Endpoint Implementations

### 3.1 KI-Labor (generate-mini-app)
**Backend:** `slam-backend/src/api/generate-mini-app.ts`
- Implement real generation with Claude/Gemini via model router
- Accept: `{ description, selectedModel, apiKey, provider }`
- Return: `{ html, css, javascript }`

**Frontend:** `lib/features/apps/presentation/screens/generative_apps_screen.dart`
- Fix hardcoded 'gpt-4' model (line 63) - use user's selected model
- Pass API key from `appSettingsNotifierProvider`
- Show proper error messages

### 3.2 GeoGebra (generate-geogebra)
**Backend:** `slam-backend/src/api/generate-geogebra.ts`
- Implement real generation for GeoGebra commands via AI
- Accept: `{ questionText, topic, userPrompt, apiKey, provider }`
- Return: `{ commands: string[], explanation: string }`

**Frontend:** `lib/features/apps/presentation/screens/geogebra_screen.dart`
- Pass API key and model from settings
- Fix WebView timing (wait for GeoGebra CDN before commands)
- Proper loading/error states

### 3.3 Custom Hint (Wo haengts?)
**Backend:** `slam-backend/src/api/custom-hint.ts`
- Implement AI hint generation
- Accept: `{ question, userAnswer, hintsUsed, apiKey, provider }`
- Return: `{ hint: string }`

---

## Sprint 4: User Tracking, Auto-Mode & Purchase Validation

### 4.1 Save User Behavior
**File:** `lib/core/services/firestore_service.dart`
- Add `saveQuestionResult()` - save each answer with timing, hints, topic, difficulty
- Add `getRecentPerformance()` - fetch last N results
- Store at `users/{uid}/questionHistory` subcollection

**File:** `lib/features/live_feed/presentation/providers/live_feed_providers.dart`
- After each answer evaluation, call `saveQuestionResult()`

### 4.2 Auto-Mode Backend
**Backend:** `slam-backend/src/api/update-auto-mode.ts`
- Implement AI parameter adjustment based on performance history
- Accept: `{ userId, currentSettings, recentPerformance }`
- Return: updated difficulty/model parameters

### 4.3 Theme Purchase Enforcement
**File:** `lib/features/settings/presentation/widgets/theme_selector.dart`
- Check `unlockedThemes` before allowing theme selection
- Show lock icon + coin price for locked themes
- Default theme always available free
- Replace `withOpacity()` with `withValues(alpha:)` here

### 4.4 Server-Side Purchase Validation
**New backend:** `slam-backend/src/api/purchase.ts`
- `POST /api/purchase` endpoint
- Accept: `{ userId, itemType, itemId, cost }`
- Firestore transaction: verify balance -> deduct coins -> add item (atomic)
- Return: `{ success, newBalance, unlockedItems }`

**Register route:** `slam-backend/src/index.ts` - add `/api/purchase`

**File:** `lib/features/gamification/presentation/screens/shop_screen.dart`
- Replace two separate Firestore writes with single `/api/purchase` backend call
- Remove race condition

---

## Sprint 5: Material 3 Expressive Polish

### 5.1 Fix Deprecated APIs
- Replace all `withOpacity()` with `withValues(alpha: x)` across entire codebase
- Files: theme_selector.dart, shop_screen.dart, model_selection_panel.dart, + others

### 5.2 M3 Consistency Audit
- Ensure all screens use `Theme.of(context).colorScheme` (no hardcoded colors)
- Consistent card radius (16px), proper elevation
- FilledButton/OutlinedButton/TextButton hierarchy
- Proper M3 typography scale usage
- Focus on: Lernplan screen, GeoGebra screen, KI-Labor screen, education settings

### 5.3 New Screens M3 Design
- Lernplan screen: GlassPanel, gradient accents, smooth transitions
- All new UI follows existing M3 Expressive patterns from app/theme.dart

---

## Verification

### End-to-End Testing
1. **Lernplan Flow**: Profile > Lernplan button > Add 3 topics from catalog > Verify saved in Firestore > Go to Feed > Verify only those topics used for generation
2. **Feed (No Mock)**: With Lernplan: questions generate from real API. Without Lernplan: shows empty state, no demo questions
3. **KI-Labor**: Generate an app with user's API key + selected model > No red error > HTML renders in WebView
4. **GeoGebra**: Enter prompt > Commands generated by AI > GeoGebra renders visualization
5. **Wo haengts?**: Answer wrong in Feed > Tap "Wo haengts?" > Real AI hint returned
6. **Auto-Mode**: Answer 5 questions > Check Firestore questionHistory > Verify results saved
7. **Theme Purchase**: In settings, locked themes show lock icon > Purchase in shop > Theme unlocked > Verify via Firestore (not client-side bypass)
8. **Education Settings**: Select grade 9 > Kursart hidden. Select grade 11 > Kursart appears
9. **Debug Panel**: Open settings > Models refresh (not cached) > Standard shows actual model name
10. **M3 Polish**: Visual check all screens for consistent styling, no `withOpacity` deprecation warnings

### Build Verification
```bash
flutter analyze    # No new warnings
dart run build_runner build --delete-conflicting-outputs  # Models regenerate
flutter run        # App starts without errors
```
