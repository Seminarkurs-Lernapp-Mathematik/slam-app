import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'question_session_providers.g.dart';

/// Current Question Index Provider
@riverpod
class CurrentQuestionIndex extends _$CurrentQuestionIndex {
  @override
  int build() {
    return 0;
  }

  void increment() {
    state++;
  }

  void decrement() {
    if (state > 0) state--;
  }

  void reset() {
    state = 0;
  }
}

/// Current Answer Provider
@riverpod
class CurrentAnswer extends _$CurrentAnswer {
  @override
  String build() {
    return '';
  }
}

/// Hints Used Provider
@riverpod
class HintsUsed extends _$HintsUsed {
  @override
  int build() {
    return 0;
  }
}

/// Show Feedback Provider
@riverpod
class ShowFeedback extends _$ShowFeedback {
  @override
  bool build() {
    return false;
  }
}

/// Last XP Earned Provider
@riverpod
class LastXPEarned extends _$LastXPEarned {
  @override
  int build() {
    return 0;
  }
}

/// Skipped Questions Provider
@riverpod
class SkippedQuestions extends _$SkippedQuestions {
  @override
  Set<int> build() {
    return {};
  }

  void addSkipped(int index) {
    state = {...state, index};
  }

  void removeSkipped(int index) {
    state = {...state}..remove(index);
  }
}

/// Demo Questions Provider - Sample questions with LaTeX
@riverpod
List<Map<String, dynamic>> demoQuestions(DemoQuestionsRef ref) {
  return [
    {
      'text': 'Löse die quadratische Gleichung:',
      'latex': r'x^2 - 5x + 6 = 0',
      'expectedAnswer': 'x=2 oder x=3',
      'hints': [
        'Verwende die Faktorisierungsmethode',
        'Suche nach zwei Zahlen, deren Produkt 6 und deren Summe -5 ergibt',
        'Die Gleichung lässt sich schreiben als (x-2)(x-3) = 0',
      ],
      'feedback': 'Richtig! Die Lösungen sind x=2 und x=3. Die Gleichung lässt sich faktorisieren zu (x-2)(x-3) = 0.',
    },
    {
      'text': 'Berechne die Ableitung der Funktion:',
      'latex': r'f(x) = 3x^2 + 2x - 5',
      'expectedAnswer': '6x+2',
      'hints': [
        'Verwende die Potenzregel: (x^n)\' = n·x^(n-1)',
        'Die Ableitung einer Summe ist die Summe der Ableitungen',
        'Konstanten fallen beim Ableiten weg',
      ],
      'feedback': 'Richtig! Die Ableitung ist f\'(x) = 6x + 2',
    },
    {
      'text': 'Vereinfache den Term:',
      'latex': r'(a + b)^2',
      'expectedAnswer': 'a^2+2ab+b^2',
      'hints': [
        'Verwende die binomische Formel',
        'Erste binomische Formel: (a+b)² = a² + 2ab + b²',
        'Multipliziere (a+b) mit sich selbst aus',
      ],
      'feedback': 'Richtig! Die Lösung ist a² + 2ab + b²',
    },
    {
      'text': 'Berechne den Wert von:',
      'latex': r'\int_0^2 x \, dx',
      'expectedAnswer': '2',
      'hints': [
        'Bestimme zunächst die Stammfunktion',
        'Die Stammfunktion von x ist x²/2',
        'Setze die Grenzen in die Stammfunktion ein: [x²/2]₀²',
      ],
      'feedback': 'Richtig! Das Integral ist 2',
    },
    {
      'text': 'Löse nach x auf:',
      'latex': r'2^x = 16',
      'expectedAnswer': '4',
      'hints': [
        'Schreibe 16 als Potenz von 2',
        '16 = 2⁴',
        'Wenn 2^x = 2⁴, dann muss x = 4 sein',
      ],
      'feedback': 'Richtig! x = 4, denn 2⁴ = 16',
    },
  ];
}
