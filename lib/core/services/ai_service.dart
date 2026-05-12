import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/design_tokens.dart';
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
    int questionCount = 10,
    String afbLevel = 'II',
    Map<String, dynamic>? autoModeAssessment,
    List<Map<String, dynamic>>? recentMemories,
    Map<String, dynamic>? recentPerformance,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.getFullUrl(ApiEndpoints.generateQuestions),
        options: Options(receiveTimeout: const Duration(seconds: 120)),
        data: {
          'userId': userId,
          'learningPlanItemId': learningPlanItemId,
          'topics': topics.map((t) => t.toJson()).toList(),
          'userContext': userContext.toJson(),
          'questionCount': questionCount,
          'afbLevel': afbLevel,
          'autoModeAssessment': autoModeAssessment,
          'recentMemories': recentMemories,
          'recentPerformance': recentPerformance,
          'useCache': false,
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
        data: {
          'description': description,
          'themeColors': _currentThemeColors(),
        },
      );
      return GeneratedApp.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Submit async mini-app generation. Returns jobId immediately (HTTP 202).
  Future<String> generateMiniAppAsync({
    required String description,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.getFullUrl(ApiEndpoints.generateMiniAppAsync),
        data: {
          'description': description,
          'themeColors': _currentThemeColors(),
        },
      );
      final jobId = response.data['jobId'] as String?;
      if (jobId == null)
        throw AIException(message: 'No jobId in response', statusCode: 500);
      return jobId;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Poll a background job. Returns the raw job document.
  Future<Map<String, dynamic>> getJob(String jobId) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.getFullUrl('${ApiEndpoints.jobs}/$jobId'),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Submit async generation, then poll until done or error. Returns GeneratedApp.
  Future<GeneratedApp> generateMiniAppWithPolling({
    required String description,
    void Function(String status)? onStatusUpdate,
    Duration pollInterval = const Duration(seconds: 3),
    Duration timeout = const Duration(seconds: 300),
  }) async {
    final jobId = await generateMiniAppAsync(description: description);
    final deadline = DateTime.now().add(timeout);

    while (DateTime.now().isBefore(deadline)) {
      await Future.delayed(pollInterval);
      final job = await getJob(jobId);
      final status = job['status'] as String? ?? 'pending';
      onStatusUpdate?.call(status);

      if (status == 'done') {
        final result = job['result'] as Map<String, dynamic>?;
        if (result == null)
          throw AIException(
              message: 'Job fertig, aber kein Ergebnis', statusCode: 500);
        return GeneratedApp.fromJson(result);
      }

      if (status == 'error') {
        final errMsg = job['error'] as String? ?? 'Unbekannter Fehler';
        throw AIException(message: errMsg, statusCode: 500);
      }
      // pending / running — keep polling
    }
    throw AIException(
        message: 'Zeitüberschreitung beim Warten auf das Ergebnis',
        statusCode: 408);
  }

  /// Serialize the active SlamTokens palette to hex strings for the backend.
  Map<String, String> _currentThemeColors() {
    final p = SlamTokens.primary;
    final pDark = Color.fromARGB(
      255,
      (p.r * 255 - 30).clamp(0, 255).round(),
      (p.g * 255 - 30).clamp(0, 255).round(),
      (p.b * 255 - 30).clamp(0, 255).round(),
    );
    return {
      'primary': _colorToHex(p),
      'primaryDark': _colorToHex(pDark),
      'bg': _colorToHex(SlamTokens.bg),
      'surface': _colorToHex(SlamTokens.surface),
      'text': _colorToHex(SlamTokens.text),
    };
  }

  String _colorToHex(Color c) =>
      '#${(c.r * 255).round().toRadixString(16).padLeft(2, '0')}'
      '${(c.g * 255).round().toRadixString(16).padLeft(2, '0')}'
      '${(c.b * 255).round().toRadixString(16).padLeft(2, '0')}';

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
      return models
          .map((m) => ModelInfo.fromJson(m as Map<String, dynamic>))
          .toList();
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
          if (messageField is String &&
              messageField.isNotEmpty &&
              messageField != errorField) {
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

  CanvasResponse(
      {required this.textResponse, this.drawings, this.geogebraCommands});

  factory CanvasResponse.fromJson(Map<String, dynamic> json) {
    return CanvasResponse(
      textResponse: json['text'] as String,
      drawings:
          (json['drawings'] as List?)?.map((d) => Drawing.fromJson(d)).toList(),
      geogebraCommands:
          (json['geogebraCommands'] as List?)?.map((c) => c as String).toList(),
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
      points: (json['points'] as List)
          .map((p) => p as Map<String, dynamic>)
          .toList(),
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

  ImageAnalysisResult(
      {required this.topics, required this.summary, this.additionalData});

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
