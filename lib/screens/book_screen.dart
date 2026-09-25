import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../app/theme.dart';
import '../app/providers.dart';
import '../models/book.dart';
import '../models/story.dart';
import '../widgets/bloom_button.dart';

final bookPageIndexProvider = StateProvider.family<int, String>((ref, bookId) => 0);
final isBookOpenedProvider = StateProvider.family<bool, String>((ref, bookId) => false);

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
  late PageController _pageController;
  late AnimationController _floatingController;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialPageIndex);

    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 2400),
      vsync: this,
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(begin: 0, end: -8).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  Book _getBook() {
    // In future, fetch by widget.bookId from a repository.
    return burstingMythsBook;
  }

  @override
  Widget build(BuildContext context) {
    final book = _getBook();
    final isOpened = ref.watch(isBookOpenedProvider(widget.bookId));
    final currentPageIndex = ref.watch(bookPageIndexProvider(widget.bookId));
    final storiesAsync = ref.watch(storyListProvider);

    return Scaffold(
      backgroundColor: BloomTheme.softCream,
      appBar: AppBar(
        backgroundColor: BloomTheme.softCream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: BloomTheme.darkText),
          onPressed: () {
            if (isOpened) {
              ref.read(isBookOpenedProvider(widget.bookId).notifier).state = false;
            } else {
              context.pop();
            }
          },
        ),
        title: Text(
          book.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: BloomTheme.darkText,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
          child: !isOpened
              ? _buildBookCoverScreen(context, book)
              : _buildBookPagesScreen(context, book, currentPageIndex, storiesAsync),
        ),
      ),
    );
  }

  // Stage 1: Physical Book Cover Opening Screen
  Widget _buildBookCoverScreen(BuildContext context, Book book) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustrated Storybook Cover Container
            GestureDetector(
              onTap: () => ref.read(isBookOpenedProvider(widget.bookId).notifier).state = true,
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 340, maxHeight: 440),
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF4EB), // Warm paper tone
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFFD8C3A5), width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 24,
                      offset: const Offset(4, 12),
                    ),
                    BoxShadow(
                      color: BloomTheme.primaryRose.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(-4, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Book Icon Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF0E5D8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.menu_book_rounded,
                        size: 48,
                        color: BloomTheme.primaryRose,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title
                    Text(
                      book.title.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: BloomTheme.darkText,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Subtitle
                    Text(
                      '"${book.subtitle}"',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: BloomTheme.subText,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Floral Ornament Divider
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_florist_rounded, size: 16, color: BloomTheme.primaryRose),
                        SizedBox(width: 8),
                        Text('🌸  🌸  🌸', style: TextStyle(fontSize: 12)),
                        SizedBox(width: 8),
                        Icon(Icons.local_florist_rounded, size: 16, color: BloomTheme.primaryRose),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Open Book Button
                    BloomButton(
                      text: '📖 OPEN BOOK',
                      style: BloomButtonStyle.primary,
                      onPressed: () => ref.read(isBookOpenedProvider(widget.bookId).notifier).state = true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Stage 2: Page-Turning System Screen
  Widget _buildBookPagesScreen(
    BuildContext context,
    Book book,
    int currentPageIndex,
    AsyncValue<List<Story>> storiesAsync,
  ) {
    final totalPages = book.pages.length + 1; // +1 for Book-End closing page

    return Column(
      children: [
        // Top Page Indicator & Progress Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currentPageIndex < book.pages.length
                    ? '${book.title.toUpperCase()} • PAGE ${currentPageIndex + 1} OF ${book.pages.length}'
                    : '${book.title.toUpperCase()} • THE END',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: BloomTheme.subText,
                ),
              ),
              // Dots Indicator
              Row(
                children: List.generate(totalPages, (index) {
                  final isActive = index == currentPageIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: isActive ? 16 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: isActive ? BloomTheme.primaryRose : BloomTheme.borderSoft,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Horizontal PageView (Storybook Pages)
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: totalPages,
            onPageChanged: (index) {
              ref.read(bookPageIndexProvider(widget.bookId).notifier).state = index;
            },
            itemBuilder: (context, index) {
              if (index < book.pages.length) {
                final pageData = book.pages[index];
                final storyList = storiesAsync.asData?.value ?? [];
                final story = storyList.firstWhere(
                  (s) => s.id == pageData.storyId,
                  orElse: () => Story(
                    id: pageData.storyId,
                    title: pageData.title,
                    description: pageData.tagline,
                    category: 'Myths',
                    scenarioAsset: '',
                    choiceAsset: '',
                    consequenceAssets: const {},
                    bloomFactAsset: '',
                  ),
                );

                return _buildStoryPage(context, pageData, story, index, book.pages.length);
              } else {
                // Book-End Closing Page
                return _buildBookEndPage(context, book);
              }
            },
          ),
        ),
      ],
    );
  }

  // Single Storybook Page Widget
  Widget _buildStoryPage(
    BuildContext context,
    BookStoryPage page,
    Story story,
    int pageIndex,
    int totalStoryPages,
  ) {
    final characterName = page.characterId[0].toUpperCase() + page.characterId.substring(1);
    final isCompleted = story.isCompleted;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFCF8F2), // Real paper background
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE8DBCA), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(2, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Page Header Tags
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
                    page.theme.toUpperCase(),
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
                          'Completed',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: BloomTheme.darkText),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const Spacer(),

            // Floating Mascot Illustration
            AnimatedBuilder(
              animation: _floatingAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _floatingAnimation.value),
                  child: child,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  page.mascotAsset,
                  width: 140,
                  height: 140,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.auto_awesome_rounded,
                    size: 80,
                    color: BloomTheme.primaryRose,
                  ),
                ),
              ),
            ),
            const Spacer(),

            // Story Title
            Text(
              page.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: BloomTheme.darkText,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 10),

            // Tagline Quote
            Text(
              '"${page.tagline}"',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: BloomTheme.subText,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),

            // Character Badge
            Text(
              '— Starring $characterName',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: BloomTheme.primaryRose,
              ),
            ),
            const Spacer(),

            // Primary Action: OPEN STORY
            BloomButton(
              text: isCompleted ? 'REPLAY STORY 🌸' : 'OPEN STORY 🌸',
              style: BloomButtonStyle.primary,
              onPressed: () {
                // Navigate to interactive story
                context.push('/stories/${page.storyId}');
              },
            ),
            const SizedBox(height: 12),

            // Page Navigation Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (pageIndex > 0)
                  TextButton.icon(
                    icon: const Icon(Icons.arrow_back_rounded, size: 16),
                    label: const Text('← PREVIOUS PAGE'),
                    style: TextButton.styleFrom(foregroundColor: BloomTheme.subText),
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    },
                  )
                else
                  const SizedBox.shrink(),

                TextButton.icon(
                  label: const Text('NEXT PAGE →'),
                  icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                  style: TextButton.styleFrom(foregroundColor: BloomTheme.primaryRose),
                  onPressed: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Book-End Closing Page Widget
  Widget _buildBookEndPage(BuildContext context, Book book) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFAF3E6), // End page vintage paper
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFDCC8B0), width: 2.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(2, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.auto_awesome_rounded,
              size: 56,
              color: BloomTheme.primaryRose,
            ),
            const SizedBox(height: 20),

            const Text(
              '🌸 YOU\'VE EXPLORED\nBURSTING MYTHS',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                color: BloomTheme.darkText,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              '"Keep questioning.\nKeep learning.\nKeep growing."',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: BloomTheme.subText,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 36),

            BloomButton(
              text: 'BACK TO LIBRARY',
              style: BloomButtonStyle.primary,
              onPressed: () {
                context.pop();
              },
            ),
            const SizedBox(height: 16),

            TextButton.icon(
              icon: const Icon(Icons.replay_rounded, size: 16),
              label: const Text('REREAD FROM PAGE 1'),
              style: TextButton.styleFrom(foregroundColor: BloomTheme.primaryRose),
              onPressed: () {
                _pageController.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
