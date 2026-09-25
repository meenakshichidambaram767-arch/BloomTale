import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app/theme.dart';
import '../app/providers.dart';
import '../widgets/bloom_card.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  IconData _parseIcon(String name) {
    switch (name) {
      case 'flag_rounded':
        return Icons.flag_rounded;
      case 'auto_stories_rounded':
        return Icons.auto_stories_rounded;
      case 'water_drop_rounded':
        return Icons.water_drop_rounded;
      case 'psychology_rounded':
        return Icons.psychology_rounded;
      case 'local_fire_department_rounded':
        return Icons.local_fire_department_rounded;
      default:
        return Icons.emoji_events_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievementsAsync = ref.watch(achievementsProvider);

    return Scaffold(
      backgroundColor: BloomTheme.softCream,
      appBar: AppBar(
        title: const Text('Achievements & Badges '),
      ),
      body: achievementsAsync.when(
        data: (achievements) => ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            final ach = achievements[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: BloomCard(
                backgroundColor: ach.isUnlocked ? Colors.white : BloomTheme.borderSoft.withValues(alpha: 0.3),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: ach.isUnlocked ? BloomTheme.warmSun : Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _parseIcon(ach.iconName),
                        color: ach.isUnlocked ? BloomTheme.warningOrange : Colors.grey,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ach.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ach.isUnlocked ? BloomTheme.darkText : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            ach.description,
                            style: TextStyle(
                              fontSize: 13,
                              color: ach.isUnlocked ? BloomTheme.subText : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (ach.isUnlocked)
                      const Icon(Icons.check_circle_rounded, color: BloomTheme.successGreen)
                    else
                      const Icon(Icons.lock_outline_rounded, color: Colors.grey),
                  ],
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
