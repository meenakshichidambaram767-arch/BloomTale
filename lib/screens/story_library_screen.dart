import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../app/theme.dart';
import '../app/providers.dart';
import '../widgets/bloom_card.dart';
import '../widgets/bloom_button.dart';
import '../widgets/bloom_avatar.dart';

class StoryLibraryScreen extends ConsumerWidget {
  const StoryLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesAsync = ref.watch(storyListProvider);
    final selectedAvatarAsync = ref.watch(selectedAvatarProvider);
    final avatar = selectedAvatarAsync.asData?.value;
    final avatarId = avatar?.id ?? 'ananya';
    final avatarName = avatar?.name ?? 'Bloom';

    return Scaffold(
      backgroundColor: BloomTheme.softCream,
      appBar: AppBar(
        title: const Text('Story Library'),
      ),
      body: storiesAsync.when(
        data: (stories) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Banner
            BloomIllustrationCard(
              avatarId: avatarId,
              activity: 'reading',
              height: 190,
              badgeText: 'Story Library',
              title: 'Explore Stories with $avatarName',
              subtitle: 'Interactive visual stories addressing myths, facts, and body confidence.',
            ),
            const SizedBox(height: 20),
            const Text(
              'Featured Interactive Stories',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: BloomTheme.darkText,
              ),
            ),
            const SizedBox(height: 12),
            ...stories.map((story) {
              final isCompleted = story.isCompleted;

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: BloomCard(
                  onTap: () => context.push('/stories/${story.id}'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          BloomAvatar(
                            avatarId: story.starringCharacterId,
                            activity: 'reading',
                            size: 64,
                            showBadge: true,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: BloomTheme.accentLavender.withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    story.category.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: BloomTheme.darkText,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  story.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: BloomTheme.darkText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        story.description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: BloomTheme.subText,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: BloomButton(
                              text: isCompleted ? 'Replay Story' : 'Start Story',
                              icon: isCompleted ? Icons.replay_rounded : Icons.play_arrow_rounded,
                              style: isCompleted ? BloomButtonStyle.outline : BloomButtonStyle.primary,
                              onPressed: () => context.push('/stories/${story.id}'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error loading stories: $err')),
      ),
    );
  }
}
