import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:book_page_flip/book_page_flip.dart';

import '../app/theme.dart';
import '../app/providers.dart';
import '../models/book.dart';
import '../models/story.dart';
import '../widgets/bloom_button.dart';
import '../widgets/logo_widget.dart';

final bookCurrentSpreadProvider = StateProvider.family<int, String>((ref, bookId) => 0);

class BookScreen extends ConsumerStatefulWidget {
  final String bookId;
  final int initialPageIndex;

  const BookScreen({
    super.key,
    required this.bookId,
    this.initialPageIndex = 0,
  });

  @override
  ConsumerState<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends ConsumerState<BookScreen> with SingleTickerProviderStateMixin {
  late BookFlipController _bookFlipController;
  late AnimationController _floatingController;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();
    final initialSpread = widget.initialPageIndex ~/ 2;
    _bookFlipController = BookFlipController(initialSpread: initialSpread);

    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(begin: 0, end: -7).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bookFlipController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  Book _getBook() {
    return burstingMythsBook;
  }

  @override
  Widget build(BuildContext context) {
    final book = _getBook();
    final storiesAsync = ref.watch(storyListProvider);
    final currentSpread = ref.watch(bookCurrentSpreadProvider(widget.bookId));

    return Scaffold(
      backgroundColor: BloomTheme.softCream,
      appBar: AppBar(
        backgroundColor: BloomTheme.softCream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: BloomTheme.darkText),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/stories');
            }
          },
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BloomLogo(size: 26),
            const SizedBox(width: 8),
            Text(
              book.title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: BloomTheme.darkText,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Page Indicator Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'STORYBOOK • SPREAD ${currentSpread + 1}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: BloomTheme.subText,
                    ),
                  ),
                  const Row(
                    children: [
                      Icon(Icons.touch_app_rounded, size: 14, color: BloomTheme.primaryRose),
                      SizedBox(width: 4),
                      Text(
                        'SWIPE TO FLIP PAGES 📖',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: BloomTheme.primaryRose,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),

            // BookFlip Interactive 3D Page Flip View
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final pageSize = Size(
                    constraints.maxWidth.clamp(280.0, 480.0),
                    constraints.maxHeight.clamp(400.0, 750.0),
                  );

                  // Create Widget Pages: Cover, Story 1, Story 2, Story 3, Closing Page, Back Cover
                  final pages = _buildPageWidgets(context, book, storiesAsync);

                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: BookFlip.widgets(
                        controller: _bookFlipController,
                        pageSize: pageSize,
                        pages: pages,
                        material: BookFlipMaterial.paper,
                        physics: const BookFlipPhysics(
                          springStiffness: 110,
                          commitThreshold: 0.35,
                        ),
                        onSpreadChanged: (spread) {
                          ref.read(bookCurrentSpreadProvider(widget.bookId).notifier).state = spread;
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            // Subtle Programmatic Navigation Bar at bottom
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.arrow_back_rounded, size: 16),
                    label: const Text('PREVIOUS'),
                    style: TextButton.styleFrom(
                      foregroundColor: BloomTheme.darkText,
                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      if (_bookFlipController.currentSpread > 0) {
                        _bookFlipController.goToSpread(_bookFlipController.currentSpread - 1);
                      }
                    },
                  ),
                  TextButton.icon(
                    label: const Text('NEXT'),
                    icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                    style: TextButton.styleFrom(
                      foregroundColor: BloomTheme.primaryRose,
                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      if (_bookFlipController.currentSpread < _bookFlipController.totalSpreads - 1) {
                        _bookFlipController.goToSpread(_bookFlipController.currentSpread + 1);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPageWidgets(
    BuildContext context,
    Book book,
    AsyncValue<List<Story>> storiesAsync,
  ) {
    final storyList = storiesAsync.asData?.value ?? [];

    return [
      // Page 0: Cover Page
      _buildCoverPage(context, book),

      // Page 1: Story 1 (Curd Myth - Ananya)
      _buildStoryPageWidget(
        context,
        book.pages[0],
        _findStory(storyList, book.pages[0].storyId),
        1,
      ),

      // Page 2: Story 2 (Hair Washing Myth - Meera)
      _buildStoryPageWidget(
        context,
        book.pages[1],
        _findStory(storyList, book.pages[1].storyId),
        2,
      ),

      // Page 3: Story 3 (Exercise Myth - Kiara)
      _buildStoryPageWidget(
        context,
        book.pages[2],
        _findStory(storyList, book.pages[2].storyId),
        3,
      ),

      // Page 4: Closing Book-End Celebration Page
      _buildBookEndPage(context, book),

      // Page 5: Back Cover Page
      _buildBackCoverPage(context, book),
    ];
  }

  Story _findStory(List<Story> stories, String id) {
    return stories.firstWhere(
      (s) => s.id == id,
      orElse: () => Story(
        id: id,
        title: 'Myth Story',
        description: 'Discover facts about period myths.',
        category: 'Myths',
        scenarioAsset: '',
        choiceAsset: '',
        consequenceAssets: const {},
        bloomFactAsset: '',
      ),
    );
  }

  // Page 0: Illustrated Book Cover
  Widget _buildCoverPage(BuildContext context, Book book) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAF3E6), // Paper tone
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFDCC8B0), width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(4, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const BloomLogo(size: 64, isHero: true),
          const SizedBox(height: 20),

          Text(
            book.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: BloomTheme.darkText,
            ),
          ),
          const SizedBox(height: 12),

          Text(
            book.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: BloomTheme.subText,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 28),

          const Text(
            '🌸  🌸  🌸',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 28),

          const Text(
            'SWIPE LEFT TO TURN PAGE →',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              color: BloomTheme.primaryRose,
            ),
          ),
        ],
      ),
    );
  }

  // Storybook Story Page Widget
  Widget _buildStoryPageWidget(
    BuildContext context,
    BookStoryPage pageData,
    Story story,
    int pageNum,
  ) {
    final isCompleted = story.isCompleted;
    final characterName = pageData.characterId[0].toUpperCase() + pageData.characterId.substring(1);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFCF8F2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8DBCA), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 15,
            offset: const Offset(2, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        children: [
          // Page Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: BloomTheme.accentLavender.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  pageData.theme.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: BloomTheme.darkText,
                  ),
                ),
              ),
              if (isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: BloomTheme.mintFresh.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_rounded, size: 13, color: BloomTheme.sageGreen),
                      SizedBox(width: 4),
                      Text(
                        '✓ Explored',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: BloomTheme.darkText),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const Spacer(),

          // Pure Floating Mascot Illustration (No Box Container!)
          AnimatedBuilder(
            animation: _floatingAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatingAnimation.value),
                child: child,
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                pageData.mascotAsset,
                width: 125,
                height: 125,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.auto_awesome_rounded,
                  size: 70,
                  color: BloomTheme.primaryRose,
                ),
              ),
            ),
          ),
          const Spacer(),

          // Title
          Text(
            pageData.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: BloomTheme.darkText,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),

          // Tagline Quote
          Text(
            '"${pageData.tagline}"',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: BloomTheme.subText,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 6),

          // Character Tag
          Text(
            '— Starring $characterName',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: BloomTheme.primaryRose,
            ),
          ),
          const Spacer(),

          // READ STORY Button
          BloomButton(
            text: isCompleted ? 'READ AGAIN 🌸' : 'READ STORY 🌸',
            style: BloomButtonStyle.primary,
            onPressed: () {
              // Save current page index in query parameters so returning restores exact page!
              context.push('/stories/${pageData.storyId}?fromBook=bursting_myths&pageIndex=$pageNum');
            },
          ),
        ],
      ),
    );
  }

  // Page 4: Closing Book-End Celebration Page
  Widget _buildBookEndPage(BuildContext context, Book book) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAF3E6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFDCC8B0), width: 2.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(2, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(26),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            size: 52,
            color: BloomTheme.primaryRose,
          ),
          const SizedBox(height: 16),

          const Text(
            '🌸 YOU\'VE EXPLORED\nBURSTING MYTHS',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              color: BloomTheme.darkText,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 14),

          const Text(
            '"Keep questioning.\nKeep learning.\nKeep growing."',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: BloomTheme.subText,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),

          BloomButton(
            text: 'RETURN TO LIBRARY',
            style: BloomButtonStyle.primary,
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/stories');
              }
            },
          ),
        ],
      ),
    );
  }

  // Page 5: Back Cover
  Widget _buildBackCoverPage(BuildContext context, Book book) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7ECE1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFD0BAA2), width: 3),
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const BloomLogo(size: 54),
          const SizedBox(height: 16),
          const Text(
            'BloomTale',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: BloomTheme.darkText,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Learn • Explore • Grow',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: BloomTheme.primaryRose,
            ),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () => _bookFlipController.goToSpread(0),
            child: const Text('← REOPEN FROM COVER'),
          ),
        ],
      ),
    );
  }
}
