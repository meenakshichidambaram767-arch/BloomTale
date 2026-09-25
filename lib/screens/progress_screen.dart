import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../app/theme.dart';
import '../app/providers.dart';
import '../widgets/bloom_button.dart';
import '../widgets/bloom_card.dart';
import '../widgets/progress_bar.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);

    return Scaffold(
      backgroundColor: BloomTheme.softCream,
      appBar: AppBar(
        title: const Text('Your Growth & XP '),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Level & XP Hero Card
            BloomCard(
              backgroundColor: BloomTheme.warmSun,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    'Level',
                    style: TextStyle(fontSize: 14, color: BloomTheme.subText),
                  ),
                  Text(
                    '${progress.currentLevel}',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: BloomTheme.primaryRose,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total XP: ${progress.currentXp}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  BloomProgressBar(
                    progress: progress.levelProgress,
                    label: 'Progress to Level ${progress.currentLevel + 1}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Statistics Grid
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Learning Streak',
                    value: '${progress.streakDays} Days',
                    icon: Icons.local_fire_department_rounded,
                    iconColor: BloomTheme.warningOrange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: 'Stories Completed',
                    value: '${progress.storiesCompleted}',
                    icon: Icons.auto_stories_rounded,
                    iconColor: BloomTheme.primaryRose,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            BloomButton(
              text: 'View Achievements & Badges ',
              onPressed: () => context.push('/achievements'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return BloomCard(
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: BloomTheme.subText,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
