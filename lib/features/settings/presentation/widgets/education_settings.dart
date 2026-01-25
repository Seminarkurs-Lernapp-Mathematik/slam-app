import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_providers.dart';
import '../../../../shared/widgets/glass_panel.dart';

/// Education Settings - Grade Level, Course Type
class EducationSettings extends ConsumerWidget {
  const EducationSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(educationConfigNotifierProvider);

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
              value: config.gradeLevel,
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
                DropdownMenuItem(value: '13', child: Text('Klasse 13')),
                DropdownMenuItem(value: 'studium', child: Text('Studium')),
              ],
              onChanged: (value) {
                if (value != null) {
                  ref.read(educationConfigNotifierProvider.notifier).setGradeLevel(value);
                }
              },
            ),

            const SizedBox(height: 16),

            // Course Type Dropdown
            DropdownButtonFormField<CourseType>(
              value: config.courseType,
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
                DropdownMenuItem(
                  value: CourseType.standard,
                  child: Text('Standard'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  ref.read(educationConfigNotifierProvider.notifier).setCourseType(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
