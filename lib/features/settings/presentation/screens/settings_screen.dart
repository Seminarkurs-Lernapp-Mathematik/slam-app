import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/design_tokens.dart';
import '../../../../core/services/auth_service.dart';
import '../../../live_feed/presentation/providers/live_feed_providers.dart';
import '../providers/settings_providers.dart';
import '../widgets/theme_selector.dart';
import '../widgets/memories_settings_section.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SlamTokens.bg,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                      SlamTokens.gutter, 8, SlamTokens.gutter, 32),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildSection(
                        icon: Icons.palette_outlined,
                        title: 'Erscheinungsbild',
                        color: SlamTokens.primary,
                        child: const ThemeSelector(),
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        icon: Icons.school_outlined,
                        title: 'Bildung',
                        color: SlamTokens.stochastik,
                        child: const _EducationSettings(),
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        icon: Icons.psychology_outlined,
                        title: 'KI-Erinnerungen',
                        color: SlamTokens.geometrie,
                        child: const MemoriesSettingsSection(),
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        icon: Icons.storage_outlined,
                        title: 'Daten',
                        color: SlamTokens.textDim,
                        child: const _DataSettings(),
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        icon: Icons.account_circle_outlined,
                        title: 'Account',
                        color: SlamTokens.danger,
                        child: const _AccountActions(),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 4, SlamTokens.gutter, 0),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: SlamTokens.text),
              onPressed: () => context.pop(),
            ),
            const SizedBox(width: 4),
            Text(
              'Einstellungen',
              style: GoogleFonts.fraunces(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: SlamTokens.text,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required Color color,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: SlamTokens.textDim,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: SlamTokens.surface,
            borderRadius: BorderRadius.circular(SlamTokens.rCardMd),
            border: Border.all(color: SlamTokens.line),
          ),
          child: child,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Row helpers
// ─────────────────────────────────────────────────────────────────────────────

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.label,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor = SlamTokens.textDim,
    this.isDestructive = false,
    this.showDivider = true,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color iconColor;
  final bool isDestructive;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final labelColor = isDestructive ? SlamTokens.danger : SlamTokens.text;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(SlamTokens.rCardMd),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, size: 20, color: isDestructive ? SlamTokens.danger : iconColor),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: GoogleFonts.dmSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: labelColor)),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(subtitle!,
                            style: GoogleFonts.dmSans(
                                fontSize: 12, color: SlamTokens.textDim)),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) trailing!
                else if (onTap != null)
                  const Icon(Icons.chevron_right, size: 18, color: SlamTokens.textMute),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(height: 1, indent: 50, color: SlamTokens.line),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Education Settings
// ─────────────────────────────────────────────────────────────────────────────

class _EducationSettings extends ConsumerWidget {
  const _EducationSettings();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsNotifierProvider);
    final showCourseType = !['Klasse_5', 'Klasse_6', 'Klasse_7',
        'Klasse_8', 'Klasse_9', 'Klasse_10'].contains(settings.gradeLevel);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
          child: Row(
            children: [
              const Icon(Icons.grade_outlined, size: 20, color: SlamTokens.textDim),
              const SizedBox(width: 14),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: settings.gradeLevel,
                  decoration: InputDecoration(
                    labelText: 'Klassenstufe',
                    labelStyle: GoogleFonts.dmSans(
                        fontSize: 12, color: SlamTokens.textDim),
                    border: InputBorder.none,
                  ),
                  dropdownColor: SlamTokens.bgElev,
                  style: GoogleFonts.dmSans(
                      fontSize: 15, fontWeight: FontWeight.w600, color: SlamTokens.text),
                  items: ['Klasse_5', 'Klasse_6', 'Klasse_7', 'Klasse_8',
                    'Klasse_9', 'Klasse_10', 'Klasse_11', 'Klasse_12', 'Klasse_13']
                      .map((g) => DropdownMenuItem(
                          value: g,
                          child: Text(g.replaceFirst('_', ' '))))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(appSettingsNotifierProvider.notifier)
                          .setGradeLevel(value);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        if (showCourseType) ...[
          Divider(height: 1, indent: 50, color: SlamTokens.line),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
            child: Row(
              children: [
                const Icon(Icons.menu_book_outlined, size: 20, color: SlamTokens.textDim),
                const SizedBox(width: 14),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: ['Grundkurs', 'Leistungskurs']
                            .contains(settings.courseType)
                        ? settings.courseType
                        : 'Leistungskurs',
                    decoration: InputDecoration(
                      labelText: 'Kursart',
                      labelStyle: GoogleFonts.dmSans(
                          fontSize: 12, color: SlamTokens.textDim),
                      border: InputBorder.none,
                    ),
                    dropdownColor: SlamTokens.bgElev,
                    style: GoogleFonts.dmSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: SlamTokens.text),
                    items: ['Grundkurs', 'Leistungskurs']
                        .map((c) =>
                            DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        ref
                            .read(appSettingsNotifierProvider.notifier)
                            .setCourseType(value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data Settings
// ─────────────────────────────────────────────────────────────────────────────

class _DataSettings extends ConsumerWidget {
  const _DataSettings();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _SettingsRow(
      icon: Icons.delete_sweep_outlined,
      label: 'Fragen-Cache leeren',
      subtitle: 'Löscht alle zwischengespeicherten Fragen',
      showDivider: false,
      onTap: () {
        ref.read(liveFeedQueueProvider.notifier).clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cache geleert',
                style: GoogleFonts.dmSans(color: SlamTokens.text)),
            backgroundColor: SlamTokens.surface,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Account Actions
// ─────────────────────────────────────────────────────────────────────────────

class _AccountActions extends ConsumerWidget {
  const _AccountActions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _SettingsRow(
          icon: Icons.logout,
          label: 'Abmelden',
          subtitle: 'Von deinem Account abmelden',
          onTap: () => ref.read(authServiceProvider).signOut(),
        ),
        _SettingsRow(
          icon: Icons.delete_forever_outlined,
          label: 'Account löschen',
          subtitle: 'Kann nicht rückgängig gemacht werden',
          isDestructive: true,
          showDivider: false,
          onTap: () => _showDeleteDialog(context, ref),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: SlamTokens.bgElev,
        title: Text('Account löschen?',
            style: GoogleFonts.fraunces(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: SlamTokens.text)),
        content: Text(
          'Diese Aktion kann nicht rückgängig gemacht werden. Alle deine Daten werden permanent gelöscht.',
          style: GoogleFonts.dmSans(fontSize: 14, color: SlamTokens.textDim),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Abbrechen',
                style: GoogleFonts.dmSans(color: SlamTokens.textDim)),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                await ref.read(authServiceProvider).deleteAccount();
              } catch (e) {
                scaffoldMessenger.showSnackBar(
                  SnackBar(content: Text('Fehler: $e')),
                );
              }
            },
            style: FilledButton.styleFrom(backgroundColor: SlamTokens.danger),
            child: Text('Löschen',
                style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w700, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
