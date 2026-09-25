import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app/theme.dart';
import '../widgets/bloom_button.dart';
import '../widgets/logo_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = const [
    {
      'badge': ' Welcome to BloomTale',
      'title': 'Growing Up with Confidence & Friends',
      'description': 'A warm, supportive space created just for you to explore puberty, feelings, menstruation, and body positivity safely.',
      'quote': ' "You are never alone in your journey — we bloom together!"',
      'image': 'assets/images/splash/splash_group_all_avatars.jpg',
      'fallback_image': 'assets/images/avatar/ananya.png',
      'accent': Color(0xFFE86A92),
    },
    {
      'badge': ' Story Library',
      'title': 'Interactive Stories with Ananya',
      'description': 'Explore decisions and real situations in puberty, hygiene, and emotions with zero judgment.',
      'quote': ' "Curious, that\'s all. Always learning and dreaming big!"',
      'image': 'assets/images/splash/splash_ananya.jpg',
      'fallback_image': 'assets/images/avatar/ananya/reading.png',
      'accent': Color(0xFF4FA075),
    },
    {
      'badge': ' Safe AI Companion',
      'title': 'Ask Bloom Anything with Meera',
      'description': 'Bloom is your 24/7 safe AI companion ready to answer awkward or curious questions warmly and privately.',
      'quote': ' "Same sky, bigger dreams — music and creativity heal the heart!"',
      'image': 'assets/images/splash/splash_meera.jpg',
      'fallback_image': 'assets/images/avatar/meera/music.png',
      'accent': Color(0xFF8A79E4),
    },
    {
      'badge': ' Body Rhythm & Care',
      'title': 'Cycle & Serenity with Lavanya',
      'description': 'Understand your body rhythm, track mood patterns, and get personalized period kit recommendations.',
      'quote': ' "Not perfect, just growing. Patience and self-kindness first!"',
      'image': 'assets/images/splash/splash_lavanya.jpg',
      'fallback_image': 'assets/images/avatar/lavanya/tea.png',
      'accent': Color(0xFFD98A6C),
    },
    {
      'badge': ' Active Movement & Joy',
      'title': 'Sports & Body Vitality with Kiara',
      'description': 'Embrace active sports, fitness, yoga, and vibrant energy with Kiara’s bold and supportive mindset.',
      'quote': ' "Bold, kind, and a little like sunshine — chase your dreams!"',
      'image': 'assets/images/avatar/kiara/sports.png',
      'fallback_image': 'assets/images/avatar/kiara.png',
      'accent': Color(0xFF389B80),
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPageData = _pages[_currentPage];
    final Color currentAccent = currentPageData['accent'] as Color;

    return Scaffold(
      backgroundColor: BloomTheme.softCream,
      body: Stack(
        children: [
          PageView.builder(
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
            itemCount: _pages.length,
            itemBuilder: (context, idx) {
              final item = _pages[idx];
              final imagePath = item['image'] as String;
              final fallbackPath = item['fallback_image'] as String;

              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    alignment: const Alignment(0, -0.3),
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: BloomTheme.softCream,
                        child: Center(
                          child: Image.asset(
                            fallbackPath,
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.4),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.8),
                        ],
                        stops: const [0.0, 0.45, 0.85],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          if (_currentPage > 0)
            Positioned(
              left: 12,
              top: 0,
              bottom: 0,
              child: Center(
                child: IconButton(
                  onPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white38),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ),
          if (_currentPage < _pages.length - 1)
            Positioned(
              right: 12,
              top: 0,
              bottom: 0,
              child: Center(
                child: IconButton(
                  onPressed: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white38),
                    ),
                    child: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const BloomLogo(
                        size: 32,
                        showText: true,
                        isRow: true,
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          shadows: [
                            Shadow(color: Colors.black54, blurRadius: 4),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${_currentPage + 1}/${_pages.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => context.go('/profile-setup'),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.85),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    ),
                    child: const Text(
                      'Skip to App',
                      style: TextStyle(
                        color: BloomTheme.darkText,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: currentAccent,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Text(
                        currentPageData['badge'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      currentPageData['title'] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(blurRadius: 10, color: Colors.black87, offset: Offset(0, 2)),
                          Shadow(blurRadius: 20, color: Colors.black54, offset: Offset(0, 4)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentPageData['description'] as String,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.5,
                        color: Colors.white.withValues(alpha: 0.92),
                        height: 1.4,
                        shadows: const [
                          Shadow(blurRadius: 8, color: Colors.black87, offset: Offset(0, 1)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      currentPageData['quote'] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFFEAA7),
                        shadows: [
                          Shadow(blurRadius: 8, color: Colors.black87, offset: Offset(0, 1)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: _currentPage == index ? 24 : 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: const [
                              BoxShadow(blurRadius: 4, color: Colors.black45)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                BloomButton(
                  text: _currentPage == _pages.length - 1 ? 'Meet Your Companions' : 'Next Page',
                  style: BloomButtonStyle.primary,
                  onPressed: () {
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      context.go('/profile-setup');
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
