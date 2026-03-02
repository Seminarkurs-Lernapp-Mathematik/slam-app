import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/user_stats.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firestore_service.dart';

/// Developer tool to directly edit user XP, Level, and Coins in Firestore.
class DevStatsEditor extends ConsumerStatefulWidget {
  const DevStatsEditor({super.key});

  @override
  ConsumerState<DevStatsEditor> createState() => _DevStatsEditorState();
}

class _DevStatsEditorState extends ConsumerState<DevStatsEditor> {
  final _xpController = TextEditingController();
  final _coinsController = TextEditingController();
  final _streakController = TextEditingController();
  bool _loading = false;
  UserStats? _currentStats;

  @override
  void initState() {
    super.initState();
    _loadCurrentStats();
  }

  @override
  void dispose() {
    _xpController.dispose();
    _coinsController.dispose();
    _streakController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentStats() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    final stats = await ref.read(firestoreServiceProvider).getUserStats(user.uid);
    if (mounted && stats != null) {
      setState(() {
        _currentStats = stats;
        _xpController.text = stats.totalXp.toString();
        _coinsController.text = stats.coins.toString();
        _streakController.text = stats.streak.toString();
      });
    }
  }

  Future<void> _applyChanges() async {
    final user = ref.read(currentUserProvider);
    if (user == null || _currentStats == null) return;

    final newTotalXp = int.tryParse(_xpController.text) ?? _currentStats!.totalXp;
    final newCoins = int.tryParse(_coinsController.text) ?? _currentStats!.coins;
    final newStreak = int.tryParse(_streakController.text) ?? _currentStats!.streak;

    setState(() => _loading = true);
    try {
      // Recalculate level from totalXp
      final newStats = _currentStats!.addXp(newTotalXp - _currentStats!.totalXp).copyWith(
        totalXp: newTotalXp,
        coins: newCoins,
        streak: newStreak,
      );
      await ref.read(firestoreServiceProvider).updateUserStats(user.uid, newStats);
      setState(() => _currentStats = newStats);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Stats aktualisiert'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Fehler: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text('Nicht eingeloggt – Stats-Editor nicht verfügbar'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_currentStats != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatDisplay('Level', _currentStats!.calculatedLevel.toString(), Icons.military_tech, Colors.amber),
                _StatDisplay('Total XP', _currentStats!.totalXp.toString(), Icons.star, Colors.orange),
                _StatDisplay('Coins', _currentStats!.coins.toString(), Icons.monetization_on, Colors.yellow.shade700),
                _StatDisplay('Streak', '${_currentStats!.streak}d', Icons.local_fire_department, Colors.deepOrange),
              ],
            ),
          ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatField(
                controller: _xpController,
                label: 'Total XP',
                icon: Icons.star,
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _StatField(
                controller: _coinsController,
                label: 'Coins',
                icon: Icons.monetization_on,
                color: Colors.amber,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _StatField(
                controller: _streakController,
                label: 'Streak',
                icon: Icons.local_fire_department,
                color: Colors.deepOrange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: _loading ? null : _applyChanges,
                icon: _loading
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.save, size: 18),
                label: const Text('Speichern'),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: _loading ? null : _loadCurrentStats,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Neu laden'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Quick preset buttons
        Wrap(
          spacing: 8,
          children: [
            _PresetChip(
              label: '+100 XP',
              onTap: () {
                final cur = int.tryParse(_xpController.text) ?? 0;
                _xpController.text = (cur + 100).toString();
              },
            ),
            _PresetChip(
              label: '+500 XP',
              onTap: () {
                final cur = int.tryParse(_xpController.text) ?? 0;
                _xpController.text = (cur + 500).toString();
              },
            ),
            _PresetChip(
              label: '+100 Coins',
              onTap: () {
                final cur = int.tryParse(_coinsController.text) ?? 0;
                _coinsController.text = (cur + 100).toString();
              },
            ),
            _PresetChip(
              label: 'Reset',
              color: Colors.red,
              onTap: () {
                _xpController.text = '0';
                _coinsController.text = '0';
                _streakController.text = '0';
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _StatDisplay extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatDisplay(this.label, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Text(label, style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ],
    );
  }
}

class _StatField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final Color color;

  const _StatField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: color, size: 18),
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
    );
  }
}

class _PresetChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _PresetChip({required this.label, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label, style: TextStyle(fontSize: 11, color: color)),
      onPressed: onTap,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}
