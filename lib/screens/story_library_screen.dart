import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../app/theme.dart';
import '../app/providers.dart';
import '../models/story.dart';
import '../widgets/bloom_card.dart';
import '../widgets/bloom_button.dart';
import '../widgets/bloom_avatar.dart';
import '../widgets/logo_widget.dart';

final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

class StoryLibraryScreen extends ConsumerWidget {
  const StoryLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesAsync = ref.watch(storyListProvider);
    final selectedAvatarAsync = ref.watch(selectedAvatarProvider);
    final avatar = selectedAvatarAsync.asData?.value;
    final avatarId = avatar?.id ?? 'ananya';
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      backgroundColor: BloomTheme.softCream,
      appBar: AppBar(
        title: const Text('Story Library'),
      ),
      body: storiesAsync.when(
        data: (stories) {
          // Extract unique categories
          final categories = ['All', ...{for (var s in stories) s.category}];

          // Filter stories
          final filteredStories = selectedCategory == 'All'
              ? stories
              : stories.where((s) => s.category.toLowerCase() == selectedCategory.toLowerCase()).toList();

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Hero Banner with App Logo
              BloomIllustrationCard(
                avatarId: avatarId,
                activity: 'reading',
                height: 195,
                badgeText: 'BloomTale Stories',
                title: 'Explore Bloom Stories',
                subtitle: 'Interactive journeys on puberty, hygiene & confidence',
                customRightWidget: const Padding(
                  padding: EdgeInsets.only(right: 6),
                  child: BloomLogo(
                    size: 82,
                    isHero: true,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Category Filter Chips
              const Text(
                'Explore Topics',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: BloomTheme.darkText,
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((cat) {
                    final isSelected = selectedCategory.toLowerCase() == cat.toLowerCase();
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(
                          cat.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: isSelected ? Colors.white : BloomTheme.darkText,
                          ),
                        ),
                        backgroundColor: Colors.white,
                        selectedColor: BloomTheme.primaryRose,
                        checkmarkColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected ? BloomTheme.primaryRose : BloomTheme.borderSoft,
                            width: 1.5,
                          ),
                        ),
                        onSelected: (_) {
                          ref.read(selectedCategoryProvider.notifier).state = cat;
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${filteredStories.length} ${filteredStories.length == 1 ? "Story" : "Stories"} Available',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: BloomTheme.subText,
                    ),
                  ),
                  if (selectedCategory != 'All')
                    GestureDetector(
                      onTap: () => ref.read(selectedCategoryProvider.notifier).state = 'All',
                      child: const Text(
                        'Clear Filter',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: BloomTheme.primaryRose,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Story List
              ...filteredStories.map((story) {
                final isCompleted = story.isCompleted;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: BloomCard(
                    onTap: () => context.push('/stories/${story.id}'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BloomAvatar(
                              avatarId: story.starringCharacterId,
                              activity: 'reading',
                              size: 64,
                              showBadge: true,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
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
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: BloomTheme.darkText,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                      if (isCompleted) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: BloomTheme.mintFresh.withValues(alpha: 0.3),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.check_circle_rounded, size: 12, color: BloomTheme.sageGreen),
                                              SizedBox(width: 3),
                                              Text(
                                                'Completed',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: BloomTheme.darkText,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    story.title,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: BloomTheme.darkText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          story.description,
                          style: const TextStyle(
                            fontSize: 13,
                            color: BloomTheme.subText,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Badges: Estimated Read Time & Reward Points
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: BloomTheme.sandBeige.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.access_time_rounded, size: 13, color: BloomTheme.subText),
                                  const SizedBox(width: 4),
                                  Text(
                                    '3 min read',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: BloomTheme.subText.withValues(alpha: 0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: BloomTheme.warmSun.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star_rounded, size: 13, color: Color(0xFFD97706)),
                                  const SizedBox(width: 4),
                                  Text(
                                    '+${story.xpReward} XP',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF92400E),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

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
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error loading stories: $err')),
      ),
    );
  }
}

