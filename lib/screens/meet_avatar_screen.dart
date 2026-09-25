import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app/theme.dart';
import '../app/providers.dart';

class MeetAvatarScreen extends ConsumerStatefulWidget {
  const MeetAvatarScreen({super.key});

  @override
  ConsumerState<MeetAvatarScreen> createState() => _MeetAvatarScreenState();
}

class _MeetAvatarScreenState extends ConsumerState<MeetAvatarScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  final List<Map<String, dynamic>> _bloomFriends = [
    {
      'id': 'ananya',
      'name': 'ANANYA',
      'displayName': 'Ananya',
      'quote': '“Art speaks where words cannot.”',
      'traits': ['Curious', 'Thoughtful', 'Observant'],
      'image': 'assets/images/avatar/ananya_standing_clean.png',
      'accent': const Color(0xFF4E876A), // Sage Green
      'bgTone': const Color(0xFFFBF2DF), // Exact cream tone of illustration
    },
    {
      'id': 'kiara',
      'name': 'KIARA',
      'displayName': 'Kiara',
      'quote': '“Good people make a better tomorrow.”',
      'traits': ['Confident', 'Energetic', 'Encouraging'],
      'image': 'assets/images/avatar/kiara_standing_clean.png',
      'accent': const Color(0xFF5B7344), // Olive Moss Green
      'bgTone': const Color(0xFFF9EDD7), // Exact cream tone of illustration
    },
    {
      'id': 'lavanya',
      'name': 'LAVANYA',
      'displayName': 'Lavanya',
      'quote': '“Cherishing golden moments and kindness.”',
      'traits': ['Gentle', 'Caring', 'Supportive'],
      'image': 'assets/images/avatar/lavanya_standing_clean.png',
      'accent': const Color(0xFF8B6B9B), // Lavender Lilac
      'bgTone': const Color(0xFFFAF0DD), // Exact cream tone of illustration
    },
    {
      'id': 'meera',
      'name': 'MEERA',
      'displayName': 'Meera',
      'quote': '“Love more, good things take time.”',
      'traits': ['Expressive', 'Playful', 'Resilient'],
      'image': 'assets/images/avatar/meera_standing_clean.png',
      'accent': const Color(0xFFD06450), // Warm Terracotta / Coral
      'bgTone': const Color(0xFFFAF2DF), // Exact cream tone of illustration
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.82,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _selectFriend(String avatarId) async {
    await ref.read(userProvider.notifier).selectAvatar(avatarId);
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentFriend = _bloomFriends[_currentPage];
    final Color currentAccent = currentFriend['accent'] as Color;
    final Color currentBgTone = currentFriend['bgTone'] as Color;
    final List<String> currentTraits = List<String>.from(currentFriend['traits'] as List);

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        color: currentBgTone,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 14),

              // Header Title (Floating with rich typography)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Text(
                      'CHOOSE YOUR BLOOM FRIEND',
                      style: GoogleFonts.fredoka(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: BloomTheme.darkText,
                        letterSpacing: 0.8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Someone to learn, explore & grow with.',
                      style: GoogleFonts.quicksand(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: BloomTheme.subText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Floating Character Carousel (NO BOXES, NO BORDERS)
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  scrollBehavior: const ScrollBehavior().copyWith(
                    scrollbars: false,
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.trackpad,
                      PointerDeviceKind.stylus,
                    },
                  ),
                  onPageChanged: (idx) => setState(() => _currentPage = idx),
                  itemCount: _bloomFriends.length,
                  itemBuilder: (context, index) {
                    final friend = _bloomFriends[index];
                    final isSelected = index == _currentPage;
                    final imagePath = friend['image'] as String;
                    final Color charAccent = friend['accent'] as Color;

                    return AnimatedScale(
                      scale: isSelected ? 1.0 : 0.86,
                      duration: const Duration(milliseconds: 320),
                      curve: Curves.easeOutCubic,
                      child: AnimatedOpacity(
                        opacity: isSelected ? 1.0 : 0.45,
                        duration: const Duration(milliseconds: 300),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Soft ground shadow beneath their feet to anchor the floating figure
                            Positioned(
                              bottom: 16,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: isSelected ? 190 : 130,
                                height: 16,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.elliptical(190, 16),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: charAccent.withValues(alpha: isSelected ? 0.35 : 0.15),
                                      blurRadius: 26,
                                      spreadRadius: 2,
                                    ),
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: isSelected ? 0.12 : 0.05),
                                      blurRadius: 18,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Floating Character Illustration (PURE, NO ENCLOSING BOX)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                              child: Image.asset(
                                imagePath,
                                fit: BoxFit.contain,
                                alignment: Alignment.center,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Icon(
                                      Icons.person_outline_rounded,
                                      size: 80,
                                      color: BloomTheme.subText.withValues(alpha: 0.3),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 6),

              // Character Details & Floating Action Controls (NO BOXES)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Character Name (Floating bold heading)
                    Text(
                      currentFriend['name'] as String,
                      style: GoogleFonts.fredoka(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: BloomTheme.darkText,
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 3),

                    // Character Quote (Floating italic subtitle)
                    Text(
                      currentFriend['quote'] as String,
                      style: GoogleFonts.quicksand(
                        fontSize: 13.5,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        color: BloomTheme.subText,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    // Floating Personality Traits with leaf & flower icons (COMPLETELY BOXLESS)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          currentTraits[0],
                          style: GoogleFonts.quicksand(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: BloomTheme.darkText,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          child: Icon(
                            Icons.local_florist_rounded,
                            size: 13,
                            color: currentAccent,
                          ),
                        ),
                        Text(
                          currentTraits[1],
                          style: GoogleFonts.quicksand(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: BloomTheme.darkText,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          child: Icon(
                            Icons.eco_rounded,
                            size: 13,
                            color: currentAccent,
                          ),
                        ),
                        Text(
                          currentTraits[2],
                          style: GoogleFonts.quicksand(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: BloomTheme.darkText,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Sleek Floating Glassmorphic CTA Button
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _selectFriend(currentFriend['id'] as String),
                        borderRadius: BorderRadius.circular(30),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              width: double.infinity,
                              height: 54,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: LinearGradient(
                                  colors: [
                                    currentAccent.withValues(alpha: 0.92),
                                    currentAccent.withValues(alpha: 0.82),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.35),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: currentAccent.withValues(alpha: 0.38),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Choose ${currentFriend['displayName']}',
                                    style: GoogleFonts.fredoka(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.25),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Page Indicator Dots (Floating)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _bloomFriends.length,
                        (index) => GestureDetector(
                          onTap: () {
                            _pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 8,
                            width: _currentPage == index ? 24 : 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? currentAccent
                                  : BloomTheme.subText.withValues(alpha: 0.28),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
