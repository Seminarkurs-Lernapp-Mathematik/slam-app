import 'package:flutter/material.dart';

import '../../../../core/models/user_stats.dart';

/// Streak Calendar Widget
///
/// Shows last 7 days with streak indicators
class StreakCalendar extends StatelessWidget {
  final UserStats stats;

  const StreakCalendar({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final lastActiveDate = stats.lastActiveDate != null
        ? DateTime.parse(stats.lastActiveDate!)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Letzte 7 Tage',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            final date = now.subtract(Duration(days: 6 - index));
            final isActive = _isDateActive(date, lastActiveDate, stats.streak);
            final isToday = _isSameDay(date, now);

            return _buildDayIndicator(
              context,
              date: date,
              isActive: isActive,
              isToday: isToday,
              theme: theme,
            );
          }),
        ),
      ],
    );
  }

  /// Build Single Day Indicator
  Widget _buildDayIndicator(
    BuildContext context, {
    required DateTime date,
    required bool isActive,
    required bool isToday,
    required ThemeData theme,
  }) {
    final weekday = _getWeekdayShort(date.weekday);

    return Column(
      children: [
        Text(
          weekday,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 6),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
            border: isToday
                ? Border.all(
                    color: theme.colorScheme.primary,
                    width: 2,
                  )
                : null,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: isActive
                ? Icon(
                    Icons.local_fire_department,
                    color: Colors.white,
                    size: 18,
                  )
                : Text(
                    date.day.toString(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.4),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  /// Check if date is active (within streak)
  bool _isDateActive(
    DateTime date,
    DateTime? lastActiveDate,
    int streak,
  ) {
    if (lastActiveDate == null || streak == 0) return false;

    final daysDifference =
        DateTime(date.year, date.month, date.day).difference(
      DateTime(
        lastActiveDate.year,
        lastActiveDate.month,
        lastActiveDate.day,
      ),
    ).inDays;

    // If date is within streak range
    return daysDifference <= 0 && daysDifference > -streak;
  }

  /// Check if two dates are the same day
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Get weekday short name (German)
  String _getWeekdayShort(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mo';
      case 2:
        return 'Di';
      case 3:
        return 'Mi';
      case 4:
        return 'Do';
      case 5:
        return 'Fr';
      case 6:
        return 'Sa';
      case 7:
        return 'So';
      default:
        return '';
    }
  }
}
