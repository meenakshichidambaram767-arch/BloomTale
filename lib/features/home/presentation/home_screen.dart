import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/bloom_card.dart';
import '../../../core/widgets/logo_widget.dart';
import '../../../core/widgets/progress_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _selectedMood = 'Radiant';

  final List<Map<String, String>> _moodOptions = [
    {'label': 'Radiant', 'moodKey': 'radiant', 'response': 'Love that bright energy! Let\'s conquer today with joy.'},
    {'label': 'Calm', 'moodKey': 'calm', 'response': 'Peaceful mind, peaceful heart. Take deep breaths and bloom naturally.'},
    {'label': 'Cozy', 'moodKey': 'cozy', 'response': 'Grab a warm drink and get comfortable. You deserve gentle care.'},
    {'label': 'Energetic', 'moodKey': 'energetic', 'response': 'Full speed ahead! Channel that momentum into your passion.'},
    {'label': 'Sensitive', 'moodKey': 'sensitive', 'response': 'It\'s completely okay to feel tender today. I\'m right here with you.'},
  ];

  final List<Map<String, String>> _companionList = [
    {
      'id': 'ananya',
      'name': 'Ananya',
      'role': 'Story & Learning',
      'portrait': 'assets/images/avatar/ananya_portrait.png',
    },
    {
      'id': 'meera',
      'name': 'Meera',
      'role': 'Music & AI Chat',
      'portrait': 'assets/images/avatar/meera_portrait.png',
    },
    {
      'id': 'lavanya',
      'name': 'Lavanya',
      'role': 'Cycle & Self-Care',
      'portrait': 'assets/images/avatar/lavanya_portrait.png',
    },
    {
      'id': 'kiara',
      'name': 'Kiara',
      'role': 'Sports & Fitness',
      'portrait': 'assets/images/avatar/kiara_portrait.png',
    },
  ];

  String _getTimeOfDayGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Good Morning';
    if (hour >= 12 && hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    final progress = ref.watch(progressProvider);
    final selectedAvatarAsync = ref.watch(selectedAvatarProvider);
    final userName = userState.asData?.value?.name ?? 'Maya';
    final companionAvatar = selectedAvatarAsync.asData?.value;
    final companionName = companionAvatar?.name ?? 'Bloomie';
    final avatarId = companionAvatar?.id.toLowerCase() ?? 'ananya';
    final activeMoodData = _moodOptions.firstWhere(
      (m) => m['label'] == _selectedMood,
      orElse: () => _moodOptions[0],
    );

    return Scaffold(
      backgroundColor: BloomTheme.softCream,
      appBar: AppBar(
        title: Row(
          children: [
            const BloomLogo(size: 32),
            const SizedBox(width: 10),
            Text('BloomTale', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.stars_rounded, color: BloomTheme.primaryRose),
            onPressed: () => context.push('/progress'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Time-of-Day Floating Header Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    BloomTheme.primaryRose.withValues(alpha: 0.85),
                    BloomTheme.sageGreen.withValues(alpha: 0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: BloomTheme.primaryRose.withValues(alpha: 0.25),
                    blurRadius: 15,
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
                        Text(
                          _getTimeOfDayGreeting(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Welcome back, $userName!',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '$companionName is ready to companion you today.',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const BloomLogo(size: 60, isHero: true),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. Borderless Floating Companion Switcher (Circular Watercolor Portraits)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Switch Active Companion',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: BloomTheme.darkText,
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/meet-avatar'),
                  child: const Text('All Avatars'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _companionList.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final item = _companionList[index];
                  final compId = item['id']!;
                  final isSelected = avatarId == compId;

                  return GestureDetector(
                    onTap: () async {
                      await ref.read(userProvider.notifier).selectAvatar(compId);
                      ref.invalidate(selectedAvatarProvider);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 76,
                          height: 76,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: isSelected
                                ? const LinearGradient(
                                    colors: [BloomTheme.primaryRose, BloomTheme.sageGreen],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            color: isSelected ? null : Colors.transparent,
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: BloomTheme.primaryRose.withValues(alpha: 0.35),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 4),
                                    )
                                  ]
                                : [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.06),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                item['portrait']!,
                                fit: BoxFit.cover,
                                width: 70,
                                height: 70,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: BloomTheme.sandBeige,
                                    child: const Icon(Icons.person, color: BloomTheme.primaryRose),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['name']!,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            fontSize: 13,
                            color: isSelected ? BloomTheme.primaryRose : BloomTheme.darkText,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // 3. Floating Daily Mood & Energy Check-in Widget
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.face_retouching_natural_rounded, color: BloomTheme.primaryRose, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'How are you feeling right now?',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: BloomTheme.darkText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _moodOptions.map((mood) {
                      final isSelected = _selectedMood == mood['label'];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(mood['label']!),
                          selected: isSelected,
                          selectedColor: BloomTheme.primaryRose,
                          backgroundColor: Colors.white,
                          elevation: isSelected ? 2 : 0,
                          shadowColor: BloomTheme.primaryRose.withValues(alpha: 0.2),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : BloomTheme.darkText,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedMood = mood['label']!;
                              });
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 14),

                // Companion Floating Advice Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: BloomTheme.warmSun.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: BloomTheme.sandBeige.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/avatar/${avatarId}_portrait.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: BloomTheme.sandBeige,
                                child: const Icon(Icons.person, color: BloomTheme.primaryRose),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$companionName\'s Note',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: BloomTheme.primaryRose,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              activeMoodData['response']!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: BloomTheme.darkText,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // 4. Companion Activity Story Scenes
            const Text(
              'Companion Story Scenes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: BloomTheme.darkText,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Explore real stories & activities with your friends',
              style: TextStyle(
                fontSize: 12,
                color: BloomTheme.subText,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 190,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildStorySceneCard(
                    context,
                    title: 'Quiet Reading',
                    companionName: 'Ananya',
                    category: 'Story & Facts',
                    imagePath: 'assets/images/avatar/ananya/reading.png',
                    route: '/stories',
                  ),
                  const SizedBox(width: 12),
                  _buildStorySceneCard(
                    context,
                    title: 'Journaling',
                    companionName: 'Ananya',
                    category: 'Bloom AI Reflections',
                    imagePath: 'assets/images/avatar/ananya/journaling.png',
                    route: '/bloom-ai',
                  ),
                  const SizedBox(width: 12),
                  _buildStorySceneCard(
                    context,
                    title: 'Calm Music',
                    companionName: 'Meera',
                    category: 'Relaxation Beats',
                    imagePath: 'assets/images/avatar/meera/music.png',
                    route: '/bloom-ai',
                  ),
                  const SizedBox(width: 12),
                  _buildStorySceneCard(
                    context,
                    title: 'Comfort Tea',
                    companionName: 'Lavanya',
                    category: 'Self-Care & Warmth',
                    imagePath: 'assets/images/avatar/lavanya/tea.png',
                    route: '/tracker/recommendations',
                  ),
                  const SizedBox(width: 12),
                  _buildStorySceneCard(
                    context,
                    title: 'Period Care Kit',
                    companionName: 'Lavanya',
                    category: 'Readiness & Hygiene',
                    imagePath: 'assets/images/avatar/lavanya/packing.png',
                    route: '/tracker/recommendations',
                  ),
                  const SizedBox(width: 12),
                  _buildStorySceneCard(
                    context,
                    title: 'Active Sports',
                    companionName: 'Kiara',
                    category: 'Fitness & Joy',
                    imagePath: 'assets/images/avatar/kiara/sports.png',
                    route: '/tracker',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 5. Streak & Level Progress Bar
            BloomCard(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.local_fire_department_rounded,
                              color: BloomTheme.warningOrange),
                          const SizedBox(width: 6),
                          Text(
                            '${progress.streakDays} Day Streak!',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: BloomTheme.darkText,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${progress.currentXp} XP (Level ${progress.currentLevel})',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: BloomTheme.primaryRose,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  BloomProgressBar(
                    progress: progress.levelProgress,
                    label: 'Next level progress',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 6. Quick Actions Grid
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _QuickActionCard(
                    title: 'Learn',
                    subtitle: 'Story Library',
                    icon: Icons.auto_stories_rounded,
                    color: BloomTheme.secondaryPeach,
                    onTap: () => context.go('/stories'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickActionCard(
                    title: 'Ask Bloom',
                    subtitle: 'AI Companion',
                    icon: Icons.chat_bubble_rounded,
                    color: BloomTheme.sageGreen,
                    onTap: () => context.go('/bloom-ai'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickActionCard(
                    title: 'Track',
                    subtitle: 'Period & Mood',
                    icon: Icons.calendar_today_rounded,
                    color: BloomTheme.sandBeige,
                    onTap: () => context.go('/tracker'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // 7. Achievements Highlight Card
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Progress & Badges',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () => context.push('/achievements'),
                  child: const Text('See All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            BloomCard(
              onTap: () => context.push('/achievements'),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: BloomTheme.warmSun,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.emoji_events_rounded,
                      color: BloomTheme.warningOrange,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Period Pro Badge Unlocked!',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'You completed your menstruation learning module.',
                          style: TextStyle(
                            fontSize: 12,
                            color: BloomTheme.subText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStorySceneCard(
    BuildContext context, {
    required String title,
    required String companionName,
    required String category,
    required String imagePath,
    required String route,
  }) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Container(
        width: 155,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: BloomTheme.borderSoft, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: BloomTheme.primaryRose.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.asset(
                imagePath,
                height: 110,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 110,
                    color: BloomTheme.sandBeige,
                    child: const Icon(Icons.image, color: BloomTheme.primaryRose),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: BloomTheme.darkText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        companionName,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: BloomTheme.primaryRose,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '•',
                        style: TextStyle(fontSize: 10, color: BloomTheme.subText),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                            color: BloomTheme.subText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: BloomTheme.darkText),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: BloomTheme.subText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
