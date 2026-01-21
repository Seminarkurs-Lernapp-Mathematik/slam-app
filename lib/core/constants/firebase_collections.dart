/// Firebase Firestore Collection Names
///
/// Diese Konstanten definieren die Collection- und Subcollection-Namen
/// die mit der React-App kompatibel sind.
class FirebaseCollections {
  FirebaseCollections._(); // Private constructor

  // Main Collections
  static const String users = 'users';
  static const String challenges = 'challenges';
  static const String sharedSessions = 'shared_sessions';

  // User Subcollections
  static const String generatedQuestions = 'generatedQuestions';
  static const String questionProgress = 'questionProgress';
  static const String learningSessions = 'learningSessions';
  static const String topicProgress = 'topicProgress';
  static const String reviewQueue = 'reviewQueue';
  static const String autoModeAssessments = 'autoModeAssessments';
  static const String inventory = 'inventory';
  static const String sentChallenges = 'sentChallenges';
  static const String receivedChallenges = 'receivedChallenges';
  static const String friends = 'friends';

  // Document IDs
  static const String itemsDoc = 'items'; // For inventory/items

  // User Document Fields
  static const String profile = 'profile';
  static const String stats = 'stats';
  static const String settings = 'settings';
  static const String learningPlan = 'learningPlan';
  static const String memories = 'memories';
  static const String taskHistory = 'taskHistory';
}

/// Firestore Field Names
class FirebaseFields {
  FirebaseFields._(); // Private constructor

  // Profile Fields
  static const String displayName = 'displayName';
  static const String email = 'email';
  static const String createdAt = 'createdAt';
  static const String lastLogin = 'lastLogin';

  // Stats Fields
  static const String level = 'level';
  static const String xp = 'xp';
  static const String xpToNextLevel = 'xpToNextLevel';
  static const String streak = 'streak';
  static const String totalXp = 'totalXp';
  static const String lastActiveDate = 'lastActiveDate';

  // Settings Fields
  static const String theme = 'theme';
  static const String aiModel = 'aiModel';
  static const String gradeLevel = 'gradeLevel';
  static const String courseType = 'courseType';

  // Question Fields
  static const String sessionId = 'sessionId';
  static const String questions = 'questions';
  static const String topics = 'topics';
  static const String difficulty = 'difficulty';
  static const String isCorrect = 'isCorrect';
  static const String hintsUsed = 'hintsUsed';
  static const String timeSpent = 'timeSpent';
  static const String xpEarned = 'xpEarned';

  // Timestamps
  static const String timestamp = 'timestamp';
  static const String updatedAt = 'updatedAt';
}
