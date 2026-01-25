import 'package:flutter/material.dart';

import '../../../../shared/widgets/glass_panel.dart';

/// Smart Learning Mode Toggle Widget
class SmartLearningToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const SmartLearningToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        title: Row(
          children: [
            Icon(
              Icons.psychology,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 12),
            const Text('Smart Learning'),
          ],
        ),
        subtitle: const Padding(
          padding: EdgeInsets.only(top: 4),
          child: Text('KI priorisiert deine schwachen Themen'),
        ),
      ),
    );
  }
}
