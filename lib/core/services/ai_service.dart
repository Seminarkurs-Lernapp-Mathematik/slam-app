import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/api_endpoints.dart';
import '../models/question.dart';
import '../models/user_settings.dart';

part 'ai_service.g.dart';

/// AI Service
///
/// Handles all Cloudflare Workers API calls for:
/// - Question generation
/// - Answer evaluation
/// - AUTO mode updates
/// - Hints
/// - GeoGebra generation
/// - Canvas collaboration
/// - Generative apps
class AIService {
  final Dio _dio;

  AIService(this._dio);

  // ============================================================================
  // QUESTION GENERATION
  // ============================================================================

  /// Generate questions
  ///
  /// POST /api/generate-questions
  Future<QuestionSession> generateQuestions({
    required String apiKey,
    required String userId,
    required int learningPlanItemId,
    required List<TopicData> topics,
    required String selectedModel,
    required UserContext userContext,
    Map<String, dynamic>? autoModeAssessment,
    List<Map<String, dynamic>>? recentMemories,
    Map<String, dynamic>? recentPerformance,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.getFullUrl(ApiEndpoints.generateQuestions),
        data: {
          'apiKey': apiKey,
          'userId': userId,
          'learningPlanItemId': learningPlanItemId,
          'topics': topics.map((t) => t.toJson()).toList(),
          'selectedModel': selectedModel,
          'userContext': userContext.toJson(),
          'autoModeAssessment': autoModeAssessment,
          'recentMemories': recentMemories,
          'recentPerformance': recentPerformance,
        },
      );

      return QuestionSession.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // ============================================================================
  // ANSWER EVALUATION
  // ============================================================================

  /// Evaluate answer
  ///
  /// POST /api/evaluate-answer
  Future<AnswerEvaluation> evaluateAnswer({
    required String questionId,
    required String userAnswer,
    required String correctAnswer,
    required QuestionType questionType,
    required int difficulty,
    required int hintsUsed,
    required int timeSpentSeconds,
    required int correctStreak,
    bool isFirstQuestionToday = false,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.getFullUrl(ApiEndpoints.evaluateAnswer),
        data: {
          'questionId': questionId,
          'userAnswer': userAnswer,
          'correctAnswer': correctAnswer,
          'questionType': questionType.value,
          'difficulty': difficulty,
          'hintsUsed': hintsUsed,
          'timeSpent': timeSpentSeconds,
          'correctStreak': correctStreak,
          'isFirstQuestionToday': isFirstQuestionToday,
        },
      );

      return AnswerEvaluation.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // ============================================================================
  // AUTO MODE
  // ============================================================================

  /// Update AUTO mode parameters
  ///
  /// POST /api/update-auto-mode
  Future<AIModelSettings> updateAutoMode({
    required String userId,
    required AIModelSettings currentSettings,
    required List<Map<String, dynamic>> recentPerformance,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.getFullUrl(ApiEndpoints.updateAutoMode),
        data: {
          'userId': userId,
          'currentSettings': currentSettings.toJson(),
          'recentPerformance': recentPerformance,
        },
      );

      return AIModelSettings.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // ============================================================================
  // HINTS
  // ============================================================================

  /// Get custom hint
  ///
  /// POST /api/custom-hint
  Future<String> getCustomHint({
    required String questionText,
    required String userAnswer,
    required int hintsAlreadyUsed,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.getFullUrl(ApiEndpoints.customHint),
        data: {
          'question': questionText,
          'userAnswer': userAnswer,
          'hintsUsed': hintsAlreadyUsed,
        },
      );

      return response.data['hint'] as String;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // ============================================================================
  // GEOGEBRA
  // ============================================================================

  /// Generate GeoGebra visualization
  ///
  /// POST /api/generate-geogebra
  Future<GeoGebraData> generateGeoGebra({
    required String questionText,
    required String topic,
    String? userPrompt,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.getFullUrl(ApiEndpoints.generateGeogebra),
        data: {
          'question': questionText,
          'topic': topic,
          'userPrompt': userPrompt,
        },
      );

      return GeoGebraData.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // ============================================================================
  // CANVAS COLLABORATION
  // ============================================================================

  /// Collaborative canvas (Lasso → AI)
  ///
  /// POST /api/collaborative-canvas (multipart/form-data)
  Future<CanvasResponse> collaborativeCanvas({
    required List<int> imageBytes,
    required String question,
  }) async {
    try {
      final formData = FormData.fromMap({
        'image': MultipartFile.fromBytes(imageBytes, filename: 'canvas.png'),
        'question': question,
      });

      final response = await _dio.post(
        ApiEndpoints.getFullUrl(ApiEndpoints.collaborativeCanvas),
        data: formData,
      );

      return CanvasResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // ============================================================================
  // GENERATIVE APPS (KI-Labor)
  // ============================================================================

  /// Generate mini app
  ///
  /// POST /api/generate-mini-app
  Future<GeneratedApp> generateMiniApp({
    required String description,
    required String selectedModel,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.getFullUrl(ApiEndpoints.generateMiniApp),
        data: {
          'description': description,
          'model': selectedModel,
        },
      );

      return GeneratedApp.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // ============================================================================
  // IMAGE ANALYSIS
  // ============================================================================

  /// Analyze image (for topic extraction from exam papers)
  ///
  /// POST /api/analyze-image (multipart/form-data)
  Future<ImageAnalysisResult> analyzeImage({
    required List<int> imageBytes,
    required String analysisType, // 'topic-extraction', 'question-generation', etc.
  }) async {
    try {
      final formData = FormData.fromMap({
        'image': MultipartFile.fromBytes(imageBytes, filename: 'image.jpg'),
        'type': analysisType,
      });

      final response = await _dio.post(
        ApiEndpoints.getFullUrl(ApiEndpoints.analyzeImage),
        data: formData,
      );

      return ImageAnalysisResult.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // ============================================================================
  // LEARNING PLAN MANAGEMENT
  // ============================================================================

  /// Manage learning plan
  ///
  /// POST /api/manage-learning-plan
  Future<Map<String, dynamic>> manageLearningPlan({
    required String action, // 'create', 'update', 'prioritize', etc.
    required String userId,
    String? planId,
    Map<String, dynamic>? planData,
    String? apiKey,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.getFullUrl(ApiEndpoints.manageLearningPlan),
        data: {
          'action': action,
          'userId': userId,
          'planId': planId,
          'planData': planData,
          'apiKey': apiKey,
        },
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // ============================================================================
  // MEMORIES & SPACED REPETITION
  // ============================================================================

  /// Manage memories (spaced repetition)
  ///
  /// POST /api/manage-memories
  Future<Map<String, dynamic>> manageMemories({
    required String action, // 'create', 'review', 'get-due', 'get-stats'
    required String userId,
    String? memoryId,
    Map<String, dynamic>? memoryData,
    int? quality, // 0-5 for SM-2 algorithm
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.getFullUrl(ApiEndpoints.manageMemories),
        data: {
          'action': action,
          'userId': userId,
          'memoryId': memoryId,
          'memoryData': memoryData,
          'quality': quality,
        },
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // ============================================================================
  // ERROR HANDLING
  // ============================================================================

  AIException _handleDioException(DioException e) {
    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final data = e.response!.data;

      String message = 'API Error';
      if (data is Map<String, dynamic> && data.containsKey('error')) {
        message = data['error'] as String;
      }

      return AIException(
        statusCode: statusCode,
        message: message,
      );
    } else if (e.type == DioExceptionType.connectionTimeout) {
      return AIException(
        statusCode: 408,
        message: 'Verbindungszeitüberschreitung. Bitte versuche es erneut.',
      );
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return AIException(
        statusCode: 408,
        message: 'Antwort-Zeitüberschreitung. Bitte versuche es erneut.',
      );
    } else {
      return AIException(
        statusCode: 0,
        message: 'Netzwerkfehler: ${e.message}',
      );
    }
  }
}

// ============================================================================
// RESPONSE MODELS
// ============================================================================

/// Answer Evaluation Response
class AnswerEvaluation {
  final bool success;
  final bool isCorrect;
  final String feedback;
  final List<Misconception>? misconceptions;
  final int xpEarned;
  final int coinsEarned;
  final XPBreakdown? xpBreakdown;

  AnswerEvaluation({
    required this.success,
    required this.isCorrect,
    required this.feedback,
    this.misconceptions,
    required this.xpEarned,
    required this.coinsEarned,
    this.xpBreakdown,
  });

  factory AnswerEvaluation.fromJson(Map<String, dynamic> json) {
    return AnswerEvaluation(
      success: json['success'] as bool,
      isCorrect: json['isCorrect'] as bool,
      feedback: json['feedback'] as String,
      misconceptions: (json['misconceptions'] as List?)
          ?.map((m) => Misconception.fromJson(m))
          .toList(),
      xpEarned: json['xpEarned'] as int? ?? 0,
      coinsEarned: json['coinsEarned'] as int? ?? 0,
      xpBreakdown: json['xpBreakdown'] != null
          ? XPBreakdown.fromJson(json['xpBreakdown'])
          : null,
    );
  }
}

/// Misconception
class Misconception {
  final String id;
  final String name;
  final String hint;

  Misconception({
    required this.id,
    required this.name,
    required this.hint,
  });

  factory Misconception.fromJson(Map<String, dynamic> json) {
    return Misconception(
      id: json['id'] as String,
      name: json['name'] as String,
      hint: json['hint'] as String,
    );
  }
}

/// Canvas Response
class CanvasResponse {
  final String textResponse;
  final List<Drawing>? drawings;
  final List<String>? geogebraCommands;

  CanvasResponse({
    required this.textResponse,
    this.drawings,
    this.geogebraCommands,
  });

  factory CanvasResponse.fromJson(Map<String, dynamic> json) {
    return CanvasResponse(
      textResponse: json['text'] as String,
      drawings: (json['drawings'] as List?)
          ?.map((d) => Drawing.fromJson(d))
          .toList(),
      geogebraCommands: (json['geogebraCommands'] as List?)
          ?.map((c) => c as String)
          .toList(),
    );
  }
}

/// Drawing
class Drawing {
  final String type;
  final List<Map<String, dynamic>> points;
  final String color;

  Drawing({
    required this.type,
    required this.points,
    required this.color,
  });

  factory Drawing.fromJson(Map<String, dynamic> json) {
    return Drawing(
      type: json['type'] as String,
      points: (json['points'] as List)
          .map((p) => p as Map<String, dynamic>)
          .toList(),
      color: json['color'] as String,
    );
  }
}

/// Generated App
class GeneratedApp {
  final String html;
  final String? css;
  final String? javascript;

  GeneratedApp({
    required this.html,
    this.css,
    this.javascript,
  });

  factory GeneratedApp.fromJson(Map<String, dynamic> json) {
    return GeneratedApp(
      html: json['html'] as String,
      css: json['css'] as String?,
      javascript: json['javascript'] as String?,
    );
  }
}

/// Image Analysis Result
class ImageAnalysisResult {
  final List<String> topics;
  final String summary;
  final Map<String, dynamic>? additionalData;

  ImageAnalysisResult({
    required this.topics,
    required this.summary,
    this.additionalData,
  });

  factory ImageAnalysisResult.fromJson(Map<String, dynamic> json) {
    return ImageAnalysisResult(
      topics: (json['topics'] as List).map((t) => t as String).toList(),
      summary: json['summary'] as String,
      additionalData: json['additionalData'] as Map<String, dynamic>?,
    );
  }
}

/// AI Exception
class AIException implements Exception {
  final int? statusCode;
  final String message;

  AIException({this.statusCode, required this.message});

  @override
  String toString() => message;
}

// ============================================================================
// PROVIDERS
// ============================================================================

/// AI Service Provider
@riverpod
AIService aiService(AiServiceRef ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  return AIService(dio);
}
