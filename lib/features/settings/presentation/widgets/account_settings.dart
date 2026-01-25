import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../shared/widgets/glass_panel.dart';

/// Account Settings - Display Name, Email, Logout, Delete Account
class AccountSettings extends ConsumerStatefulWidget {
  const AccountSettings({super.key});

  @override
  ConsumerState<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends ConsumerState<AccountSettings> {
  final _displayNameController = TextEditingController();
  bool _isEditingName = false;

  @override
  void initState() {
    super.initState();
    // Initialize with current user display name
    final user = ref.read(authServiceProvider).currentUser;
    _displayNameController.text = user?.displayName ?? user?.email?.split('@').first ?? '';
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = ref.watch(authServiceProvider);
    final user = authService.currentUser;

    if (user == null) {
      return const SizedBox.shrink();
    }

    return GlassPanel(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.account_circle, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Account-Informationen',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Display Name
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _displayNameController,
                    enabled: _isEditingName,
                    decoration: InputDecoration(
                      labelText: 'Anzeigename',
                      prefixIcon: const Icon(Icons.badge),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    _isEditingName ? Icons.check_circle : Icons.edit,
                  ),
                  onPressed: () async {
                    if (_isEditingName) {
                      // Save the new display name
                      await _saveDisplayName();
                    }
                    setState(() {
                      _isEditingName = !_isEditingName;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Email (read-only)
            TextField(
              controller: TextEditingController(text: user.email),
              enabled: false,
              decoration: InputDecoration(
                labelText: 'E-Mail',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _handleLogout(context),
                icon: const Icon(Icons.logout),
                label: const Text('Abmelden'),
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Delete Account Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _handleDeleteAccount(context),
                icon: const Icon(Icons.delete),
                label: const Text('Account löschen'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveDisplayName() async {
    try {
      final newName = _displayNameController.text.trim();
      if (newName.isEmpty) return;

      final authService = ref.read(authServiceProvider);
      await authService.updateDisplayName(newName);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Anzeigename aktualisiert')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Abmelden'),
        content: const Text('Möchtest du dich wirklich abmelden?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Abmelden'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(authServiceProvider).signOut();
      if (mounted) {
        context.go('/login');
      }
    }
  }

  Future<void> _handleDeleteAccount(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Account löschen'),
        content: const Text(
          'Möchtest du deinen Account wirklich dauerhaft löschen? '
          'Diese Aktion kann nicht rückgängig gemacht werden.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(authServiceProvider).deleteAccount();
        if (mounted) {
          context.go('/login');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Fehler beim Löschen: ${e.toString()}'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }
}
