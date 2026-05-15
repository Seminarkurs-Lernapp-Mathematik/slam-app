import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app/design_tokens.dart';
import '../providers/insight_providers.dart';

/// Daily Insight Card — shown once per day at the top of the Live Feed.
/// Swipe-to-dismiss stores dismissal date in SharedPreferences.
class DailyInsightCard extends ConsumerStatefulWidget {
  final VoidCallback? onTopicTap;

  const DailyInsightCard({super.key, this.onTopicTap});

  @override
  ConsumerState<DailyInsightCard> createState() => _DailyInsightCardState();
}

class _DailyInsightCardState extends ConsumerState<DailyInsightCard> {
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    _checkDismissed();
  }

  Future<void> _checkDismissed() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final dismissedOn = prefs.getString('insight_dismissed_on');
    if (mounted && dismissedOn == today) {
      setState(() => _dismissed = true);
    }
  }

  Future<void> _dismiss() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    await prefs.setString('insight_dismissed_on', today);
    if (mounted) setState(() => _dismissed = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return const SizedBox.shrink();

    final insightAsync = ref.watch(todayInsightProvider);

    return insightAsync.when(
      data: (insight) {
        if (insight == null || insight.text.isEmpty) {
          return const SizedBox.shrink();
        }
        return _CardContent(
          insight: insight,
          onDismiss: _dismiss,
          onTopicTap: widget.onTopicTap,
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _CardContent extends StatelessWidget {
  final DailyInsight insight;
  final VoidCallback onDismiss;
  final VoidCallback? onTopicTap;

  const _CardContent({
    required this.insight,
    required this.onDismiss,
    this.onTopicTap,
  });

  String _shortTopicName(String? topicKey) {
    if (topicKey == null) return '';
    return topicKey.split('|').last;
  }

  @override
  Widget build(BuildContext context) {
    final topicName = _shortTopicName(insight.recommendedTopic);

    return Dismissible(
      key: const ValueKey('daily-insight'),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        color: SlamTokens.bg,
        child: Icon(Icons.check_circle_outline,
            color: SlamTokens.success.withValues(alpha: 0.7), size: 20),
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: SlamTokens.surfaceHi,
          borderRadius: BorderRadius.circular(SlamTokens.rCardMd),
          border: Border.all(
            color: SlamTokens.primary.withValues(alpha: 0.18),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: SlamTokens.primarySoft,
                borderRadius: BorderRadius.circular(9),
              ),
              alignment: Alignment.center,
              child: Icon(Icons.auto_awesome,
                  size: 16, color: SlamTokens.primary),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    insight.text,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: SlamTokens.text,
                      height: 1.45,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (topicName.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: onTopicTap,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Weiter üben: $topicName',
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: SlamTokens.primary,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Icon(Icons.arrow_forward_ios,
                              size: 10, color: SlamTokens.primary),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Dismiss button
            GestureDetector(
              onTap: onDismiss,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Icon(Icons.close,
                    size: 16, color: SlamTokens.textMute),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
