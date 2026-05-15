import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firebase_collections.dart';
import '../../../core/models/topic.dart';

/// Projects TopicProgress state at an arbitrary point in time.
/// Reads questionHistory once, caches it, and recomputes on demand.
class TopicProgressProjector {
  final String _userId;

  List<_HistoryEvent>? _events;

  TopicProgressProjector(this._userId);

  Future<void> loadHistory({int limit = 300}) async {
    if (_events != null) return; // already loaded

    final snapshot = await FirebaseFirestore.instance
        .collection(FirebaseCollections.users)
        .doc(_userId)
        .collection(FirebaseCollections.questionHistory)
        .orderBy('timestamp', descending: false)
        .limitToLast(limit)
        .get();

    _events = snapshot.docs
        .map((doc) => _HistoryEvent.fromMap(doc.data()))
        .whereType<_HistoryEvent>()
        .toList();
  }

  /// Returns reconstructed TopicProgress map at time [at].
  /// Aggregates all events with timestamp <= at.
  Map<String, TopicProgress> at(DateTime at) {
    if (_events == null) return {};

    final cutoff = at.millisecondsSinceEpoch;
    final counts = <String, List<bool>>{};

    for (final e in _events!) {
      if (e.timestamp > cutoff) break;
      final key = e.topicKey;
      counts.putIfAbsent(key, () => []).add(e.isCorrect);
    }

    return counts.map((key, answers) {
      double mastery = 0.0;
      for (final correct in answers) {
        mastery = 0.8 * mastery + 0.2 * (correct ? 1.0 : 0.0);
      }
      return MapEntry(
        key,
        TopicProgress(
          topicKey: key,
          questionsCompleted: answers.length,
          totalQuestions: answers.length,
          mastery: mastery.clamp(0.0, 1.0),
        ),
      );
    });
  }

  /// Returns all days (as midnight DateTime) that have at least one event.
  List<DateTime> get activeDays {
    if (_events == null) return [];
    final days = <String, DateTime>{};
    for (final e in _events!) {
      final d = DateTime.fromMillisecondsSinceEpoch(e.timestamp);
      final dayKey = '${d.year}-${d.month}-${d.day}';
      days.putIfAbsent(dayKey, () => DateTime(d.year, d.month, d.day));
    }
    return days.values.toList()..sort();
  }

  DateTime? get firstEventTime {
    if (_events == null || _events!.isEmpty) return null;
    return DateTime.fromMillisecondsSinceEpoch(_events!.first.timestamp);
  }
}

class _HistoryEvent {
  final int timestamp; // ms since epoch
  final String topicKey;
  final bool isCorrect;

  const _HistoryEvent({
    required this.timestamp,
    required this.topicKey,
    required this.isCorrect,
  });

  static _HistoryEvent? fromMap(Map<String, dynamic> map) {
    try {
      final leitidee = map['leitidee'] as String? ?? '';
      final thema = map['thema'] as String? ?? '';
      final unterthema = map['unterthema'] as String? ?? '';
      final isCorrect = map['isCorrect'] as bool? ?? false;
      final ts = map['timestamp'];

      int millis;
      if (ts is Timestamp) {
        millis = ts.millisecondsSinceEpoch;
      } else if (ts is int) {
        millis = ts;
      } else {
        return null;
      }

      final parts = [leitidee, if (thema.isNotEmpty) thema, if (unterthema.isNotEmpty) unterthema];
      if (parts.isEmpty) return null;

      return _HistoryEvent(
        timestamp: millis,
        topicKey: parts.join('|'),
        isCorrect: isCorrect,
      );
    } catch (_) {
      return null;
    }
  }
}
