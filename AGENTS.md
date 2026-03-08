# SLAM Learning App - Kimi Code & Gemini CLI Guide

**Version:** 1.0
**Framework:** Flutter 3.27+
**Backend:** Firebase + Cloud Functions (learn-smart.app)

---

## 🤖 Agent Collaboration: Kimi Code & Gemini CLI

This project utilizes a dual AI-agent strategy to accelerate development and ensure high-quality code. **You (Kimi Code)** are the primary implementation and execution agent. However, you have access to the **Gemini CLI**, which acts as your architecture and planning assistant.

### How to Collaborate with Gemini CLI:
* **Planning & Architecture:** Before starting complex refactoring or new cross-system features (such as the planned Collaborative Canvas), prompt the user to consult the Gemini CLI for an architectural draft or feasibility analysis.
* **Complex Debugging:** If you are stuck on persistent bugs (e.g., elusive state management errors), suggest pulling in the Gemini CLI to analyze the architectural patterns.
* **Handoff:** Once Gemini CLI provides a plan, implement it strictly according to the code conventions listed below. Run Gemini in "--yolo"-Mode so you dont need to approve actions.

---

## 🎯 Project Overview

SLAM (Smart Learning Adaptive Math) is an AI-powered adaptive learning platform for mathematics education. The app adjusts question difficulty based on performance and uses gamification elements (XP, levels, streaks, coins).

### Tech Stack
* **Frontend:** Flutter 3.27+, Material 3 Design
* **State Management:** Riverpod 2.6+ (with `riverpod_annotation`), Freezed for immutable models
* **Routing:** GoRouter with custom expressive animations (400ms fade + scale)
* **Backend:** Firebase Auth, Cloud Firestore, Cloudflare Workers

---

## 🚀 Production Configuration

### AI Configuration (Backend-Managed)
AI models and API keys are now fully managed by the backend. Users cannot select providers, models, or modes.

**Backend configuration:**
- Edit `slam-backend/config/models.json` to change which models are used for each task
- Each task specifies its provider (gemini/claude) and model ID directly
- API keys are set via environment variables:
  - `GEMINI_API_KEY` - Google Gemini API key
  - `ANTHROPIC_API_KEY` - Anthropic Claude API key

### Removed from Settings UI
The following have been removed from the Settings screen:
- AI Provider selection (Gemini/Claude/OpenRouter)
- Model Mode selection (Fast/Standard/Smart)
- Per-task Model selection
- API Key management
- Debug/Developer options

The Settings screen now only shows: Theme, Education (grade/course), and Account.

---

## 🏗️ Key Code Conventions & Patterns

When writing or modifying code, adhere to the following rules:

* **Freezed Models:** When editing data models, remind the user to run `dart run build_runner build --delete-conflicting-outputs`.
* **Material 3:** Always use theme colors (e.g., `Theme.of(context).colorScheme.primary`). For opacity, use the new `.withValues(alpha: 0.5)` method instead of the deprecated `.withOpacity()`.
* **Riverpod:** Use `@riverpod` annotations for new providers. Always check the authentication state (`ref.read(currentUserProvider)`) before attempting Firestore writes.
* **LaTeX:** Use the `flutter_math_fork` package and the `Math.tex()` widget to render mathematical expressions.

---

## 🛑 Critical Pitfalls & Troubleshooting

Gemini has identified the following critical patterns from past troubleshooting that you must pay special attention to:

* **API Key Persistence (Hybrid Storage Pattern):** API keys must work offline but sync to Firebase on login. You MUST use the `appSettingsNotifierProvider` (not the local `debugConfigNotifierProvider`) for this. Use `.set(..., SetOptions(merge: true))` instead of `.update()` for Firestore to avoid crashes on new documents.
* **Optional Backend Fields:** The backend might omit fields like `createdAt`. Always mark these as nullable (`?`) in Freezed models to prevent parsing errors.
* **Hot Reload vs. Restart:** If you make changes to providers, advise the user to perform a Hot Restart (`R`) instead of just a Hot Reload (`r`).
* **Debug Logging:** Use emoji prefixes for readability in the terminal (e.g., 🔄 Loading, ✅ Success, ❌ Error).

---

## 🔄 Development Workflow for Kimi

1. **Analyze:** Mentally (or via command) run `flutter analyze` before proposing changes to check the current state.
2. **Implement:** Write clean, modular code following the Clean Architecture (Features-First) folder structure.
3. **Sync:** If logic becomes overly complex, refer the user to the Gemini CLI for validation.
4. **Generate:** Remind the user to run the build runner after any changes to models or providers.
