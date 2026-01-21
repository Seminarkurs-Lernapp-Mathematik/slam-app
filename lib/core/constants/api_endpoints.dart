/// Cloudflare Workers API Endpoints
///
/// Diese Konstanten definieren die API-Endpoints für die Cloudflare Workers.
/// Kompatibel mit der bestehenden React-App Backend-Infrastruktur.
class ApiEndpoints {
  ApiEndpoints._(); // Private constructor

  // Base URL (wird in Produktion durch echte URL ersetzt)
  // TODO: Replace with actual Cloudflare Workers URL
  static const String baseUrl = 'https://your-cloudflare-worker.workers.dev';

  // Question Generation & Evaluation
  static const String generateQuestions = '/api/generate-questions';
  static const String evaluateAnswer = '/api/evaluate-answer';
  static const String updateAutoMode = '/api/update-auto-mode';

  // Hint System
  static const String customHint = '/api/custom-hint';

  // GeoGebra
  static const String generateGeogebra = '/api/generate-geogebra';

  // Canvas & Collaboration
  static const String collaborativeCanvas = '/api/collaborative-canvas';

  // Generative Apps (KI-Labor)
  static const String generateMiniApp = '/api/generate-mini-app';

  // Image Analysis
  static const String analyzeImage = '/api/analyze-image';

  // Helper method to get full URL
  static String getFullUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }
}

/// AI Model IDs (Claude & Gemini)
class AIModels {
  AIModels._(); // Private constructor

  // Claude Models
  static const String claudeSonnet = 'claude-sonnet-4-5-20250929';
  static const String claudeHaiku = 'claude-haiku-4-5-20251001';

  // Gemini Models
  static const String geminiPro = 'gemini-3-pro-preview';
  static const String geminiFlash = 'gemini-3-flash-preview';

  // Model Tiers
  static const Map<String, Map<String, String>> modelTiers = {
    'claude': {
      'light': claudeHaiku,
      'standard': claudeSonnet,
      'heavy': claudeSonnet,
    },
    'gemini': {
      'light': geminiFlash,
      'standard': geminiFlash,
      'heavy': geminiPro,
    },
  };
}
