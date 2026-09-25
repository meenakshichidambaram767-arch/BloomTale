import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../app/theme.dart';
import '../app/providers.dart';
import '../widgets/bloom_card.dart';
import '../widgets/logo_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _selectedMood = 'Radiant';

  final List<Map<String, String>> _moodOptions = const [
    {
      'label': 'Radiant',
      'response': 'Love that bright energy! Let\'s conquer today with joy.',
    },
    {
      'label': 'Calm',
      'response': 'A peaceful mind brings clarity and harmony.',
    },
    {
      'label': 'Cozy',
      'response': 'Take time for yourself, wrap up warm and relax.',
    },
    {
      'label': 'Energetic',
      'response': 'Channel that high energy into something creative!',
    },
    {
      'label': 'Sensitive',
      'response': 'It\'s completely okay to feel delicate. Be gentle with yourself.',
    },
  ];

  final List<Map<String, dynamic>> _companionList = const [
    {
      'id': 'ananya',
      'name': 'Ananya',
      'role': 'Read. Reflect. Imagine.',
      'fullbody': 'assets/images/avatar/ananya/ananya_standing_clean.png',
      'bgTone': Color(0xFFFBF2DF),
    },
    {
      'id': 'meera',
      'name': 'Meera',
      'role': 'Find your own rhythm.',
      'fullbody': 'assets/images/avatar/meera/meera_standing_clean.png',
      'bgTone': Color(0xFFFAF2DF),
    },
    {
      'id': 'lavanya',
      'name': 'Lavanya',
      'role': 'Comfort is care.',
      'fullbody': 'assets/images/avatar/lavanya/lavanya_standing_clean.png',
      'bgTone': Color(0xFFFAF0DD),
    },
    {
      'id': 'kiara',
      'name': 'Kiara',
      'role': 'Strong in her own way.',
      'fullbody': 'assets/images/avatar/kiara/kiara_standing_clean.png',
      'bgTone': Color(0xFFF9EDD7),
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
            // Seamless Floating Companion Figures (NO BOXES, NO BORDERS)
            SizedBox(
              height: 175,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _companionList.length,
                separatorBuilder: (context, index) => const SizedBox(width: 18),
                itemBuilder: (context, index) {
                  final item = _companionList[index];
                  final compId = item['id']!;
                  final isSelected = avatarId == compId;
                  final fullbodyAsset = item['fullbody']!;

                  return GestureDetector(
                    onTap: () async {
                      await ref.read(userProvider.notifier).selectAvatar(compId);
                      ref.invalidate(selectedAvatarProvider);
                    },
                    child: SizedBox(
                      width: 95,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Floating Character Figure with Ground Shadow (NO ENCLOSING BOX)
                          Expanded(
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                // Soft Ground Oval Shadow beneath feet
                                Positioned(
                                  bottom: 4,
                                  child: Container(
                                    width: isSelected ? 65 : 45,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.elliptical(65, 10),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: isSelected
                                              ? BloomTheme.primaryRose.withValues(alpha: 0.45)
                                              : Colors.black.withValues(alpha: 0.12),
                                          blurRadius: isSelected ? 16 : 8,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Ambient Glow Halo behind active character
                                if (isSelected)
                                  Positioned.fill(
                                    child: Center(
                                      child: Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: BloomTheme.primaryRose.withValues(alpha: 0.28),
                                              blurRadius: 28,
                                              spreadRadius: 8,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                // Seamless Floating Character Figure with Rounded Clip & Matched Background Tone
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(22),
                                    child: Container(
                                      color: item['bgTone'] as Color?,
                                      child: Image.asset(
                                        fullbodyAsset,
                                        fit: BoxFit.contain,
                                        alignment: Alignment.bottomCenter,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Image.asset(
                                            'assets/images/avatar/${compId}.png',
                                            fit: BoxFit.contain,
                                            errorBuilder: (c, e, s) => const Icon(
                                              Icons.person_rounded,
                                              color: BloomTheme.primaryRose,
                                              size: 48,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 6),

                          // Character Name & Role Motto
                          Text(
                            item['name']!,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              fontSize: 13.5,
                              color: isSelected ? BloomTheme.primaryRose : BloomTheme.darkText,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            item['role']!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 9.5,
                              color: isSelected
                                  ? BloomTheme.primaryRose.withValues(alpha: 0.9)
                                  : BloomTheme.subText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
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
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(2),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/avatar/${avatarId}_standing_clean.png',
                            fit: BoxFit.contain,
                            alignment: Alignment.topCenter,
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

            // 4. Prominent 2x2 Quick Actions Navigation Hub
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: BloomTheme.darkText,
                    letterSpacing: 0.3,
                  ),
                ),
                Text(
                  'Easy Navigation',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: BloomTheme.primaryRose.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Prominent 2x2 Navigation Grid with Fluff Mascot
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _ProminentActionCard(
                        title: 'Story Library',
                        badgeText: 'Ananya • Stories',
                        subtitle: 'Interactive health & puberty stories',
                        icon: Icons.auto_stories_rounded,
                        gradientColors: const [Color(0xFFFFD1DC), Color(0xFFFFE4E6)],
                        accentColor: const Color(0xFFE86A92),
                        fluffAsset: 'assets/images/fluff/fluff_reading.png',
                        onTap: () => context.go('/stories'),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _ProminentActionCard(
                        title: 'Ask Bloom AI',
                        badgeText: 'Meera • AI Chat',
                        subtitle: '24/7 safe & warm answers',
                        icon: Icons.forum_rounded,
                        gradientColors: const [Color(0xFFE2ECE9), Color(0xFFD8F3DC)],
                        accentColor: const Color(0xFF4FA075),
                        fluffAsset: 'assets/images/fluff/fluff_music.png',
                        onTap: () => context.go('/bloom-ai'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14, height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _ProminentActionCard(
                        title: 'Cycle Tracker',
                        badgeText: 'Lavanya • Care',
                        subtitle: 'Period, mood & kit prep',
                        icon: Icons.calendar_month_rounded,
                        gradientColors: const [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
                        accentColor: const Color(0xFFD97706),
                        fluffAsset: 'assets/images/fluff/fluff_active.png',
                        onTap: () => context.go('/tracker'),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _ProminentActionCard(
                        title: 'Achievements',
                        badgeText: 'Kiara • Badges',
                        subtitle: 'XP level & unlocked milestones',
                        icon: Icons.emoji_events_rounded,
                        gradientColors: const [Color(0xFFF3E8FF), Color(0xFFE9D5FF)],
                        accentColor: const Color(0xFF9333EA),
                        fluffAsset: 'assets/images/fluff/fluff_cozy.png',
                        onTap: () => context.push('/achievements'),
                      ),
                    ),
                  ],
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
}

class _ProminentActionCard extends StatelessWidget {
  final String title;
  final String badgeText;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;
  final Color accentColor;
  final String fluffAsset;
  final VoidCallback onTap;

  const _ProminentActionCard({
    required this.title,
    required this.badgeText,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
    required this.accentColor,
    required this.fluffAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: accentColor.withValues(alpha: 0.18),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: accentColor.withValues(alpha: 0.35),
              width: 1.2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar (Icon & Truncated Badge)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withValues(alpha: 0.22),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Icon(icon, color: accentColor, size: 20),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        badgeText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Row: Text Details on Left + Prominent Fluff Mascot Badge on Right
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Left Text Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: BloomTheme.darkText,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.5,
                            color: BloomTheme.darkText.withValues(alpha: 0.8),
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Explore',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: accentColor,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 12,
                              color: accentColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Fluff Mascot Circular Avatar Figure (Fluff Only)
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withValues(alpha: 0.28),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(
                        color: accentColor.withValues(alpha: 0.4),
                        width: 1.6,
                      ),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: ClipOval(
                      child: Image(
                        image: AssetImage(fluffAsset),
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
