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
              const SizedBox(height: 20),

              // Featured Storybook Banner (Bursting Myths Book)
              GestureDetector(
                onTap: () => context.push('/books/bursting_myths'),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAF4EB), // Storybook paper background
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFD8C3A5), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: BloomTheme.primaryRose.withValues(alpha: 0.15),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: BloomTheme.primaryRose.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'FEATURED STORYBOOK 📖',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                  color: BloomTheme.primaryRose,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Bursting Myths',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: BloomTheme.darkText,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Interactive storybook with page-turning stories on period myths & body facts.',
                              style: TextStyle(
                                fontSize: 12,
                                color: BloomTheme.subText,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Row(
                              children: [
                                Text(
                                  'OPEN BOOK 🌸',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: BloomTheme.primaryRose,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(Icons.arrow_forward_rounded, size: 14, color: BloomTheme.primaryRose),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      const FloatingMascotWidget(
                        assetPath: 'assets/images/fluff_reading.png',
                        width: 78,
                        height: 78,
                      ),
                    ],
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.auto_awesome_rounded, size: 18, color: BloomTheme.primaryRose),
                          SizedBox(width: 6),
                          Text(
                            'Bursting Myths',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: BloomTheme.darkText,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${filteredStories.length} ${filteredStories.length == 1 ? "Story" : "Stories"} addressing period & body myths',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: BloomTheme.subText,
                        ),
                      ),
                    ],
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
              const SizedBox(height: 14),

              // Story List with Mascot Overlay Cards
              ...filteredStories.map((story) {
                final isCompleted = story.isCompleted;
                final isMeera = story.starringCharacterId.toLowerCase() == 'meera';
                final characterName = isMeera ? 'Meera' : 'Ananya';
                final mascotAsset = isMeera ? 'assets/images/fluff_music.png' : 'assets/images/fluff_reading.png';

                // Mascot ambient glow colors
                final gradientColors = isMeera
                    ? [const Color(0xFFF3E8FF), const Color(0xFFFAFAFF), Colors.white] // Lavender / Soft Violet for Meera
                    : [const Color(0xFFFFF0F3), const Color(0xFFFFF8F9), Colors.white]; // Soft Petal Pink for Ananya

                final badgeColor = isMeera ? const Color(0xFF7C3AED) : BloomTheme.primaryRose;
                final badgeBg = isMeera
                    ? const Color(0xFFDDD6FE).withValues(alpha: 0.5)
                    : BloomTheme.secondaryPeach.withValues(alpha: 0.4);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 22, top: 8),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Card Body
                      BloomCard(
                        onTap: () => context.push('/stories/${story.id}'),
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: gradientColors,
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Tags Row (leaving space on the right for mascot overlay)
                              Padding(
                                padding: const EdgeInsets.only(right: 70),
                                child: Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: BloomTheme.accentLavender.withValues(alpha: 0.4),
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
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: badgeBg,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            isMeera ? Icons.music_note_rounded : Icons.menu_book_rounded,
                                            size: 12,
                                            color: badgeColor,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Starring $characterName',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: badgeColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isCompleted)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Title
                              Text(
                                story.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: BloomTheme.darkText,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Description
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
                                      color: BloomTheme.sandBeige.withValues(alpha: 0.5),
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

                              // Action Button
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
                      ),

                      // Pure Floating Mascot Overlay Image (Top-Right, No Box!)
                      Positioned(
                        top: -24,
                        right: 10,
                        child: IgnorePointer(
                          child: FloatingMascotWidget(
                            assetPath: mascotAsset,
                            width: 92,
                            height: 92,
                          ),
                        ),
                      ),
                    ],
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

class FloatingMascotWidget extends StatefulWidget {
  final String assetPath;
  final double width;
  final double height;

  const FloatingMascotWidget({
    super.key,
    required this.assetPath,
    this.width = 92,
    this.height = 92,
  });

  @override
  State<FloatingMascotWidget> createState() => _FloatingMascotWidgetState();
}

class _FloatingMascotWidgetState extends State<FloatingMascotWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: -7).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: child,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          widget.assetPath,
          width: widget.width,
          height: widget.height,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}


