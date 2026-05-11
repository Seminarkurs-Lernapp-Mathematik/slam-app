import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_providers.dart';
import '../../../../shared/widgets/glass_panel.dart';

/// Education Settings - Grade Level, Course Type, Exam Date
class EducationSettings extends ConsumerWidget {
  const EducationSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(educationConfigNotifierProvider);
    final settings = ref.watch(appSettingsNotifierProvider);

    return GlassPanel(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.school, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Bildungsstufe',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Grade Level Dropdown
            DropdownButtonFormField<String>(
              initialValue: config.gradeLevel,
              decoration: InputDecoration(
                labelText: 'Klassenstufe',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(value: '5', child: Text('Klasse 5')),
                DropdownMenuItem(value: '6', child: Text('Klasse 6')),
                DropdownMenuItem(value: '7', child: Text('Klasse 7')),
                DropdownMenuItem(value: '8', child: Text('Klasse 8')),
                DropdownMenuItem(value: '9', child: Text('Klasse 9')),
                DropdownMenuItem(value: '10', child: Text('Klasse 10')),
                DropdownMenuItem(value: '11', child: Text('Klasse 11')),
                DropdownMenuItem(value: '12', child: Text('Klasse 12')),
              ],
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(educationConfigNotifierProvider.notifier)
                      .setGradeLevel(value);
                  if (value != '11' && value != '12') {
                    ref
                        .read(educationConfigNotifierProvider.notifier)
                        .setCourseType(CourseType.grundkurs);
                  }
                }
              },
            ),

            // Course Type Dropdown - only shown for Klasse 11 and 12
            if (config.gradeLevel == '11' || config.gradeLevel == '12') ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<CourseType>(
                initialValue: config.courseType,
                decoration: InputDecoration(
                  labelText: 'Kursart',
                  prefixIcon: const Icon(Icons.menu_book),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: CourseType.grundkurs,
                    child: Text('Grundkurs'),
                  ),
                  DropdownMenuItem(
                    value: CourseType.leistungskurs,
                    child: Text('Leistungskurs'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    ref
                        .read(educationConfigNotifierProvider.notifier)
                        .setCourseType(value);
                  }
                },
              ),
            ],

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),

            // Exam Date
            Row(
              children: [
                const Icon(Icons.event, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Prüfungsdatum',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Wird als Countdown auf deinem Profil angezeigt',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: settings.examDate ??
                            DateTime.now().add(const Duration(days: 30)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 730)),
                        helpText: 'Prüfungsdatum wählen',
                        confirmText: 'Auswählen',
                        cancelText: 'Abbrechen',
                      );
                      if (picked != null) {
                        ref
                            .read(appSettingsNotifierProvider.notifier)
                            .setExamDate(picked);
                      }
                    },
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: Text(
                      settings.examDate != null
                          ? _formatDate(settings.examDate!)
                          : 'Datum wählen',
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 44),
                    ),
                  ),
                ),
                if (settings.examDate != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: 'Datum entfernen',
                    onPressed: () {
                      ref
                          .read(appSettingsNotifierProvider.notifier)
                          .setExamDate(null);
                    },
                  ),
                ],
              ],
            ),
            if (settings.examDate != null) ...[
              const SizedBox(height: 8),
              Builder(builder: (context) {
                final days = settings.examDate!
                    .difference(DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                    ))
                    .inDays;
                final color = days <= 7
                    ? Colors.red
                    : days <= 30
                        ? Colors.orange
                        : Theme.of(context).colorScheme.primary;
                return Text(
                  days < 0
                      ? 'Prüfung bereits vorbei'
                      : days == 0
                          ? '🎯 Prüfung ist HEUTE!'
                          : 'Noch $days Tage',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
