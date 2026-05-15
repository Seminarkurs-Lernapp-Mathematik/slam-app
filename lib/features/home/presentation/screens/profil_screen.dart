import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../gamification/presentation/screens/progress_screen.dart';
import '../../../gamification/presentation/widgets/level_progress_circle.dart';
import '../../../gamification/presentation/widgets/usage_indicator.dart';
import '../../../gamification/presentation/widgets/xp_stats_card.dart';
import '../../../gamification/presentation/widgets/streak_calendar.dart';
import '../../../knowledge_graph/presentation/screens/knowledge_graph_screen.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../../gamification/presentation/screens/progress_screen.dart'
    show userStatsStreamProvider;
import '../../../../app/design_tokens.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../shared/widgets/glass_panel.dart';

/// Profil Screen - Combines progress display with quick actions
class ProfilScreen extends ConsumerWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final settings = ref.watch(appSettingsNotifierProvider);
    final userId = currentUser?.uid ?? '';
    final userStatsAsync = ref.watch(userStatsStreamProvider(userId));

    final name = currentUser?.displayName ?? currentUser?.email ?? 'Benutzer';

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Space for the X button (top-left, 44px tall + 12+12 padding = 68px)
                const SizedBox(height: 68),

                // Compact stats strip — lives in the space "freed" by pushing content down
                userStatsAsync.when(
                  data: (stats) => _CompactStatsStrip(stats: stats),
                  loading: () => const SizedBox(height: 52),
                  error: (_, __) => const SizedBox(height: 52),
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),

          // Profile header + actions
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Column(
                children: [
                  _buildProfileHeader(context, name),
                  const SizedBox(height: 16),
                  userStatsAsync.whenData((stats) {
                        final today =
                            DateTime.now().toIso8601String().substring(0, 10);
                        final atRisk =
                            stats.streak > 0 && stats.isStreakAtRisk(today);
                        return Column(
                          children: [
                            if (atRisk) ...[
                              _StreakRiskBanner(streak: stats.streak),
                              const SizedBox(height: 12),
                            ],
                            if (settings.examDate != null) ...[
                              _ExamCountdownCard(examDate: settings.examDate!),
                              const SizedBox(height: 12),
                            ],
                          ],
                        );
                      }).value ??
                      const SizedBox.shrink(),
                  _buildQuickActions(context),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Progress Content
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: _EmbeddedProgressContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, String name) {
    return GestureDetector(
      onTap: () => _showProfileDialog(context, name),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [SlamTokens.surfaceHi, SlamTokens.surface],
          ),
          borderRadius: BorderRadius.circular(SlamTokens.rCardMd),
          border: Border.all(color: SlamTokens.primary.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: SlamTokens.primary.withValues(alpha: 0.06),
              blurRadius: 24,
              offset: const Offset(0, 8),
            )
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                gradient: SlamTokens.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: SlamTokens.primary.withValues(alpha: 0.4),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                    spreadRadius: -4,
                  )
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                name.substring(0, 1).toUpperCase(),
                style: GoogleFonts.fraunces(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.fraunces(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: SlamTokens.text,
                      letterSpacing: -0.4,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.bar_chart,
                          size: 13, color: SlamTokens.primary),
                      const SizedBox(width: 4),
                      Text(
                        'Statistiken anzeigen',
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          color: SlamTokens.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                color: SlamTokens.textMute, size: 20),
          ],
        ),
      ),
    );
  }

  void _showProfileDialog(BuildContext context, String name) {
    showDialog(
      context: context,
      builder: (context) => _ProfileStatisticsDialog(name: name),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/settings'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: SlamTokens.surface,
          borderRadius: BorderRadius.circular(SlamTokens.rCardMd),
          border: Border.all(color: SlamTokens.line),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: SlamTokens.primarySoft,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Icon(Icons.settings_outlined,
                  size: 18, color: SlamTokens.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Einstellungen',
                    style: GoogleFonts.dmSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: SlamTokens.text),
                  ),
                  Text(
                    'Design, Klassenstufe, Account',
                    style: GoogleFonts.dmSans(
                        fontSize: 12, color: SlamTokens.textDim),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                size: 18, color: SlamTokens.textMute),
          ],
        ),
      ),
    );
  }
}

/// Embedded Progress Content (reuses Progress Screen content)
class _EmbeddedProgressContent extends ConsumerWidget {
  const _EmbeddedProgressContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final userId = currentUser?.uid ?? '';

    // Watch User Stats Stream from progress screen
    final userStatsAsync = ref.watch(userStatsStreamProvider(userId));

    return userStatsAsync.when(
      data: (stats) => _ProgressContent(stats: stats),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Fehler beim Laden: ${error.toString()}'),
      ),
    );
  }
}

/// Profile Statistics Dialog
class _ProfileStatisticsDialog extends ConsumerWidget {
  final String name;

  const _ProfileStatisticsDialog({required this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final userId = currentUser?.uid ?? '';
    final userStatsAsync = ref.watch(userStatsStreamProvider(userId));

    return AlertDialog(
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: SlamTokens.primarySoft,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              name.substring(0, 1).toUpperCase(),
              style: GoogleFonts.fraunces(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: SlamTokens.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: GoogleFonts.fraunces(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: SlamTokens.text,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      content: userStatsAsync.when(
        data: (stats) => SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildStatRow(context, 'Level', stats.calculatedLevel.toString(),
                  Icons.military_tech, SlamTokens.primary),
              const Divider(),
              _buildStatRow(context, 'Gesamt XP', stats.totalXp.toString(),
                  Icons.star, SlamTokens.warn),
              const Divider(),
              _buildStatRow(context, 'Streak', '${stats.streak} Tage',
                  Icons.local_fire_department, SlamTokens.warn),
              const Divider(),
              _buildStatRow(context, 'Level Titel', stats.levelTitle,
                  Icons.emoji_events, SlamTokens.primary),
              const Divider(),
              _buildStatRow(
                  context,
                  'Streak Freezes',
                  stats.streakFreezes.toString(),
                  Icons.ac_unit,
                  SlamTokens.success),
            ],
          ),
        ),
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stack) => Text('Fehler: ${error.toString()}'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Schließen'),
        ),
      ],
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value,
      IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style:
                  GoogleFonts.dmSans(fontSize: 14, color: SlamTokens.textDim),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Progress Content Widget (extracted from ProgressScreen)
class _ProgressContent extends ConsumerWidget {
  final dynamic stats;

  const _ProgressContent({required this.stats});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Level Progress Circle
        LevelProgressCircle(stats: stats),
        const SizedBox(height: 24),

        // XP Stats Card
        XPStatsCard(stats: stats),
        const SizedBox(height: 24),

        // Knowledge Graph
        const SizedBox(height: 24),
        GlassPanel(
          padding: const EdgeInsets.all(20),
          child: const KnowledgeGraphSection(),
        ),
        const SizedBox(height: 24),

        // Streak Section
        GlassPanel(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: SlamTokens.warnSoft,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.local_fire_department,
                      color: SlamTokens.warn,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Streak',
                        style: GoogleFonts.fraunces(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: SlamTokens.text,
                        ),
                      ),
                      Text(
                        '${stats.streak} ${stats.streak == 1 ? "Tag" : "Tage"} in Folge',
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: SlamTokens.warn,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              StreakCalendar(stats: stats),
              const UsageIndicator(),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// COMPACT STATS STRIP — shown at top of profile, below the X button
// ============================================================================

class _CompactStatsStrip extends StatelessWidget {
  const _CompactStatsStrip({required this.stats});
  final dynamic stats;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
              child: _StatTile(
            icon: Icons.military_tech,
            label: 'Level',
            value: '${stats.calculatedLevel}',
            color: SlamTokens.primary,
          )),
          const SizedBox(width: 8),
          Expanded(
              child: _StatTile(
            icon: Icons.local_fire_department,
            label: 'Streak',
            value: '${stats.streak}d',
            color: SlamTokens.warn,
          )),
          const SizedBox(width: 8),
          Expanded(
              child: _StatTile(
            icon: Icons.star,
            label: 'XP',
            value: '${stats.totalXp}',
            color: SlamTokens.warn,
          )),
          const SizedBox(width: 8),
          Expanded(
              child: _StatTile(
            icon: Icons.monetization_on,
            label: 'Coins',
            value: '${stats.coins}',
            color: SlamTokens.warn,
          )),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(SlamTokens.rCardSm),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 4),
          Text(value,
              style: GoogleFonts.fraunces(
                  fontSize: 16, fontWeight: FontWeight.w700, color: color)),
          Text(label,
              style: GoogleFonts.dmSans(
                  fontSize: 10,
                  color: SlamTokens.textDim,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ============================================================================
// STREAK RISK BANNER
// ============================================================================

class _StreakRiskBanner extends StatelessWidget {
  final int streak;

  const _StreakRiskBanner({required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: SlamTokens.warnSoft,
        borderRadius: BorderRadius.circular(SlamTokens.rCardSm),
        border: Border.all(color: SlamTokens.warn.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department,
              color: SlamTokens.warn, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Streak in Gefahr!',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: SlamTokens.warn,
                  ),
                ),
                Text(
                  '$streak-Tage-Streak – beantworte heute noch eine Frage!',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: SlamTokens.textDim,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// EXAM COUNTDOWN CARD
// ============================================================================

class _ExamCountdownCard extends StatelessWidget {
  final DateTime examDate;

  const _ExamCountdownCard({required this.examDate});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final diff = examDate.difference(DateTime(now.year, now.month, now.day));
    final days = diff.inDays;

    if (days < 0) return const SizedBox.shrink(); // Past date

    Color cardColor;
    String urgencyText;
    if (days <= 7) {
      cardColor = SlamTokens.danger;
      urgencyText = 'Letzte Chance zum Üben!';
    } else if (days <= 30) {
      cardColor = SlamTokens.warn;
      urgencyText = 'Jetzt intensiv üben!';
    } else {
      cardColor = SlamTokens.primary;
      urgencyText = 'Bleib dran!';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cardColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(SlamTokens.rCardSm),
        border: Border.all(color: cardColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cardColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.event, color: cardColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  days == 0
                      ? 'Prüfung: Heute!'
                      : days == 1
                          ? 'Prüfung: Morgen!'
                          : 'Noch $days Tage bis zur Prüfung',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: cardColor,
                  ),
                ),
                Text(
                  urgencyText,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: cardColor.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$days',
            style: GoogleFonts.fraunces(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: cardColor,
            ),
          ),
        ],
      ),
    );
  }
}
