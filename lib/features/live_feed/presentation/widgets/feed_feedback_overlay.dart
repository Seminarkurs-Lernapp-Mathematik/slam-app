import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

/// Feed Feedback Overlay - Shows correct/incorrect feedback
class FeedFeedbackOverlay extends StatelessWidget {
  final bool isCorrect;
  final String feedback;
  final int xpEarned;
  final String correctAnswer;
  final String explanation;

  const FeedFeedbackOverlay({
    super.key,
    required this.isCorrect,
    required this.feedback,
    required this.xpEarned,
    required this.correctAnswer,
    required this.explanation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isCorrect
            ? const Color(0xFF10b981).withValues(alpha: 0.95)
            : const Color(0xFFef4444).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Icon(
              isCorrect ? Icons.check_circle : Icons.cancel,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              isCorrect ? 'Richtig!' : 'Nicht ganz richtig',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            // XP Earned (only if correct)
            if (isCorrect)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '+$xpEarned XP',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),

            // Feedback
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                feedback,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),

            // Correct Answer (only if incorrect)
            if (!isCorrect) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Korrekte Antwort:',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildLatexText(
                      correctAnswer,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Explanation
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.school, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Erklärung:',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildLatexText(
                    explanation,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Auto-advance indicator
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Nächste Frage in 3 Sekunden...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLatexText(String text, {required TextStyle style}) {
    try {
      // Split text by newlines and render each line
      final lines = text.split(r'\n');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lines.map((line) {
          if (line.trim().isEmpty) {
            return const SizedBox(height: 8);
          }

          // Check if line contains LaTeX (starts with $ or contains math symbols)
          if (line.contains(r'$')) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Math.tex(
                line.replaceAll(r'$', ''),
                textStyle: style,
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(line, style: style),
          );
        }).toList(),
      );
    } catch (e) {
      // Fallback to plain text
      return Text(text, style: style);
    }
  }
}
