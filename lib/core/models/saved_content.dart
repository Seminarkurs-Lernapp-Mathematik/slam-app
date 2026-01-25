import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'saved_content.freezed.dart';
part 'saved_content.g.dart';

/// Saved Content Model
///
/// Represents user-generated content saved from KI-Labor or GeoGebra
/// Firestore: users/{userId}/savedContent/{contentId}
@freezed
class SavedContent with _$SavedContent {
  const SavedContent._();

  const factory SavedContent({
    required String id,
    required String userId,
    required String title,
    required ContentType type,
    required String htmlContent,
    String? cssContent,
    String? javascriptContent,
    String? description,
    required DateTime createdAt,
    DateTime? updatedAt,
    @Default([]) List<String> tags,
  }) = _SavedContent;

  factory SavedContent.fromJson(Map<String, dynamic> json) =>
      _$SavedContentFromJson(json);

  /// Create from Firestore document
  factory SavedContent.fromFirestore(
    String docId,
    Map<String, dynamic> data,
  ) {
    return SavedContent(
      id: docId,
      userId: data['userId'] as String,
      title: data['title'] as String,
      type: ContentType.fromString(data['type'] as String),
      htmlContent: data['htmlContent'] as String,
      cssContent: data['cssContent'] as String?,
      javascriptContent: data['javascriptContent'] as String?,
      description: data['description'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
      tags: (data['tags'] as List<dynamic>?)?.map((t) => t as String).toList() ??
          [],
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'type': type.value,
      'htmlContent': htmlContent,
      if (cssContent != null) 'cssContent': cssContent,
      if (javascriptContent != null) 'javascriptContent': javascriptContent,
      if (description != null) 'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
      if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
      'tags': tags,
    };
  }
}

/// Content Type Enum
@JsonEnum(valueField: 'value')
enum ContentType {
  miniApp('mini-app'),
  geogebra('geogebra'),
  simulation('simulation');

  const ContentType(this.value);
  final String value;

  static ContentType fromString(String value) {
    switch (value) {
      case 'mini-app':
        return ContentType.miniApp;
      case 'geogebra':
        return ContentType.geogebra;
      case 'simulation':
        return ContentType.simulation;
      default:
        return ContentType.miniApp;
    }
  }

  String get displayName {
    switch (this) {
      case ContentType.miniApp:
        return 'Mini-App';
      case ContentType.geogebra:
        return 'GeoGebra';
      case ContentType.simulation:
        return 'Simulation';
    }
  }
}
