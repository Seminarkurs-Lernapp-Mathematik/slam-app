import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/api_endpoints.dart';
import '../models/question.dart';

part 'ai_service.g.dart';

/// Model information from backend
class ModelInfo {
  final String id;
  final String name;
  final String description;
  final String tier;
  final int contextWindow;

  ModelInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.tier,
    required this.contextWindow,
  });

  factory ModelInfo.fromJson(Map<String, dynamic> json) {
    return ModelInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      tier: json['tier'] as String,
      contextWindow: json['contextWindow'] as int,
    );
  }
}

/// AI Service
class AIService {
  final Dio _dio;

  AIService(this._dio);

  // ============================================================================
  // QUESTION GENERATION
  // ============================================================================

  Future<QuestionSession> generateQuestions({
    required String userId,
    required int learningPlanItemId,
    required List<TopicData> topics,
    required UserContext userContext,
    int questionCount = 20,
    Map<String, dynamic>? autoModeAssessment,
    List<Map<String, dynamic>>? recentMemories,
    Map<String, dynamic>? recentPerformance,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.getFullUrl(ApiEndpoints.generateQuestions),
        data: {
          'userId': userId,
          'learningPlanItemId': learningPlanItemId,
          'topics': topics.map((t) => t.toJson()).toList(),
          'userContext': userContext.toJson(),
          'questionCount': questionCount,
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
  // AUTO MODE
  // ============================================================================

  Future<Map<String, dynamic>> updateAutoMode({
    required String userId,
    required List<Map<String, dynamic>> recentPerformance,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.getFullUrl(ApiEndpoints.updateAutoMode),
        data: {
          'userId': userId,
          'recentPerformance': recentPerformance,
        },
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // ============================================================================
  // HINTS
  // ============================================================================

  /// Get a single hint (legacy, used by hint panel)
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

  /// Get a chat-style hint with full conversation history.
  ///
  /// Used by the "Wo h\u00e4ngts?" chat popover to support multi-turn dialogue.
  Future<String> getChatHint({
    required String questionText,
    required String userMessage,
    required List<Map<String, dynamic>> chatHistory,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.getFullUrl(ApiEndpoints.customHint),
        data: {
          'question': questionText,
          'userAnswer': userMessage,
          'hintsUsed': chatHistory.length,
          'chatHistory': chatHistory,
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

  Future<GeneratedApp> generateMiniApp({
    required String description,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.getFullUrl(ApiEndpoints.generateMiniApp),
        data: {'description': description},
      );
      return GeneratedApp.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // ============================================================================
  // IMAGE ANALYSIS
  // ============================================================================

  Future<ImageAnalysisResult> analyzeImage({
    required List<int> imageBytes,
    required String analysisType,
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

  Future<Map<String, dynamic>> manageLearningPlan({
    required String action,
    required String userId,
    String? planId,
    Map<String, dynamic>? planData,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.getFullUrl(ApiEndpoints.manageLearningPlan),
        data: {
          'action': action,
          'userId': userId,
          'planId': planId,
          'planData': planData,
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

  Future<Map<String, dynamic>> manageMemories({
    required String action,
    required String userId,
    String? memoryId,
    Map<String, dynamic>? memoryData,
    int? quality,
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
  // PURCHASE
  // ============================================================================

  Future<Map<String, dynamic>> purchaseItem({
    required String userId,
    required String itemType,
    required String itemId,
    required int cost,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.getFullUrl(ApiEndpoints.purchase),
        data: {
          'userId': userId,
          'itemType': itemType,
          'itemId': itemId,
          'cost': cost,
        },
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // ============================================================================
  // MODEL SELECTION
  // ============================================================================

  Future<List<ModelInfo>> getAvailableModels() async {
    try {
      final response = await _dio.get(
        ApiEndpoints.getFullUrl('/api/get-models'),
      );
      final List<dynamic> models = response.data['models'] as List<dynamic>;
      return models.map((m) => ModelInfo.fromJson(m as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to fetch models: $e');
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
      if (data is Map<String, dynamic>) {
        final errorField = data['error'];
        final messageField = data['message'];
        if (errorField is String && errorField.isNotEmpty) {
          message = errorField;
          if (messageField is String && messageField.isNotEmpty && messageField != errorField) {
            message = '$errorField\n$messageField';
          }
        } else if (messageField is String && messageField.isNotEmpty) {
          message = messageField;
        }
      }
      return AIException(statusCode: statusCode, message: message);
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

class CanvasResponse {
  final String textResponse;
  final List<Drawing>? drawings;
  final List<String>? geogebraCommands;

  CanvasResponse({required this.textResponse, this.drawings, this.geogebraCommands});

  factory CanvasResponse.fromJson(Map<String, dynamic> json) {
    return CanvasResponse(
      textResponse: json['text'] as String,
      drawings: (json['drawings'] as List?)?.map((d) => Drawing.fromJson(d)).toList(),
      geogebraCommands: (json['geogebraCommands'] as List?)?.map((c) => c as String).toList(),
    );
  }
}

class Drawing {
  final String type;
  final List<Map<String, dynamic>> points;
  final String color;

  Drawing({required this.type, required this.points, required this.color});

  factory Drawing.fromJson(Map<String, dynamic> json) {
    return Drawing(
      type: json['type'] as String,
      points: (json['points'] as List).map((p) => p as Map<String, dynamic>).toList(),
      color: json['color'] as String,
    );
  }
}

class GeneratedApp {
  final String html;
  final String? css;
  final String? javascript;
  final String title;

  GeneratedApp({
    required this.html,
    this.css,
    this.javascript,
    this.title = 'KI-Labor App',
  });

  factory GeneratedApp.fromJson(Map<String, dynamic> json) {
    return GeneratedApp(
      html: json['html'] as String,
      css: json['css'] as String?,
      javascript: json['javascript'] as String?,
      title: (json['title'] as String?) ?? 'KI-Labor App',
    );
  }
}

class ImageAnalysisResult {
  final List<String> topics;
  final String summary;
  final Map<String, dynamic>? additionalData;

  ImageAnalysisResult({required this.topics, required this.summary, this.additionalData});

  factory ImageAnalysisResult.fromJson(Map<String, dynamic> json) {
    return ImageAnalysisResult(
      topics: (json['topics'] as List).map((t) => t as String).toList(),
      summary: json['summary'] as String,
      additionalData: json['additionalData'] as Map<String, dynamic>?,
    );
  }
}

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

@riverpod
AIService aiService(AiServiceRef ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
      headers: {'Content-Type': 'application/json'},
    ),
  );
  return AIService(dio);
}
