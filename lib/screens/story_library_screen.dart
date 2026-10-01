import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../app/providers.dart';
import '../app/theme.dart';
import '../models/story.dart';
import '../widgets/logo_widget.dart';

class StoryLibraryScreen extends ConsumerStatefulWidget {
  const StoryLibraryScreen({super.key});

  @override
  ConsumerState<StoryLibraryScreen> createState() => _StoryLibraryScreenState();
}

class _StoryLibraryScreenState extends ConsumerState<StoryLibraryScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = _reduceMotion(context);
    if (reduceMotion) {
      _entranceController.value = 1;
      _floatController.stop();
    } else {
      if (!_entranceController.isCompleted) _entranceController.forward();
      if (!_floatController.isAnimating) _floatController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  bool _reduceMotion(BuildContext context) {
    final media = MediaQuery.of(context);
    return media.disableAnimations || media.accessibleNavigation;
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  void _surpriseMe(List<Story> stories) {
    if (stories.isEmpty) return;
    final unread = stories.where((story) => !story.isCompleted).toList();
    final choices = unread.isEmpty ? stories : unread;
    final selected = choices[math.Random().nextInt(choices.length)];
    context.push('/stories/${selected.id}');
  }

  Widget _entrance({required int index, required Widget child}) {
    final start = (index * .12).clamp(0.0, .72);
    final animation = CurvedAnimation(
      parent: _entranceController,
      curve: Interval(start, math.min(start + .28, 1), curve: Curves.easeOut),
    );
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, .045),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final storiesAsync = ref.watch(storyListProvider);
    final user = ref.watch(userProvider).asData?.value;
    final avatarId =
        ref.watch(selectedAvatarProvider).asData?.value.id ?? 'ananya';
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width < 360 ? 14.0 : 20.0;

    return Scaffold(
      backgroundColor: BloomTheme.softCream,
      body: Stack(
        children: [
          const Positioned.fill(child: _PaperGrain()),
          SafeArea(
            child: storiesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => _LibraryError(
                onRetry: () => ref.invalidate(storyListProvider),
              ),
              data: (stories) {
                final completed = stories
                    .where((story) => story.isCompleted)
                    .length;
                final featured = stories.firstWhere(
                  (story) => !story.isCompleted,
                  orElse: () => stories.first,
                );
                final grouped = <String, List<Story>>{
                  for (final category in const [
                    'First Period',
                    'Food & Energy',
                    'Period Products',
                  ])
                    category: stories
                        .where((story) => story.category == category)
                        .toList(),
                };

                return RefreshIndicator(
                  color: BloomTheme.primaryRose,
                  onRefresh: () async {
                    ref.invalidate(storyListProvider);
                    await ref.read(storyListProvider.future);
                  },
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          14,
                          horizontalPadding,
                          0,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: _entrance(
                            index: 0,
                            child: _LibraryHeader(
                              greeting: _greeting(),
                              userName: user?.name,
                              avatarId: avatarId,
                              completed: completed,
                              total: stories.length,
                              onProgressTap: () => context.push('/progress'),
                            ),
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          22,
                          horizontalPadding,
                          0,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: _entrance(
                            index: 1,
                            child: _FeaturedBook(
                              story: featured,
                              animation: _floatController,
                              reduceMotion: _reduceMotion(context),
                              onTap: () =>
                                  context.push('/stories/${featured.id}'),
                            ),
                          ),
                        ),
                      ),
                      ...grouped.entries.indexed.expand((entry) {
                        final index = entry.$1;
                        final shelf = entry.$2;
                        if (shelf.value.isEmpty) return <Widget>[];
                        return [
                          SliverPadding(
                            padding: EdgeInsets.only(top: index == 0 ? 26 : 12),
                            sliver: SliverToBoxAdapter(
                              child: _entrance(
                                index: index + 2,
                                child: _StoryShelf(
                                  title: shelf.key,
                                  stories: shelf.value,
                                  horizontalPadding: horizontalPadding,
                                  onStoryTap: (story) =>
                                      context.push('/stories/${story.id}'),
                                ),
                              ),
                            ),
                          ),
                        ];
                      }),
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          14,
                          horizontalPadding,
                          110,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: _entrance(
                            index: 5,
                            child: _LibraryActions(
                              onSurprise: () => _surpriseMe(stories),
                              onAskBloom: () => context.go('/bloom-ai'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LibraryHeader extends StatelessWidget {
  final String greeting;
  final String? userName;
  final String avatarId;
  final int completed;
  final int total;
  final VoidCallback onProgressTap;

  const _LibraryHeader({
    required this.greeting,
    required this.userName,
    required this.avatarId,
    required this.completed,
    required this.total,
    required this.onProgressTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = (userName == null || userName!.trim().isEmpty)
        ? ''
        : ', ${userName!.trim()}';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: BloomLogo(size: 48),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting$displayName',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 3),
              Text(
                'Which story is calling you today?',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Semantics(
          button: true,
          label:
              'Story progress. $completed of $total stories explored. Open progress.',
          child: InkWell(
            onTap: onProgressTap,
            borderRadius: BorderRadius.circular(28),
            child: SizedBox(
              width: 66,
              height: 66,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _ProgressFlower(completed: completed, total: total),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: BloomTheme.darkText,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$completed/$total',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgressFlower extends StatelessWidget {
  final int completed;
  final int total;

  const _ProgressFlower({required this.completed, required this.total});

  @override
  Widget build(BuildContext context) {
    final petalCount = math.max(total, 1);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.82, end: 1),
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 420),
      curve: Curves.easeOutBack,
      builder: (context, scale, _) => Transform.scale(
        scale: scale,
        child: Stack(
          alignment: Alignment.center,
          children: [
            for (var index = 0; index < petalCount; index++)
              Transform.rotate(
                angle: (math.pi * 2 / petalCount) * index,
                child: Transform.translate(
                  offset: const Offset(0, -18),
                  child: AnimatedContainer(
                    duration: MediaQuery.disableAnimationsOf(context)
                        ? Duration.zero
                        : Duration(milliseconds: 250 + (index * 40)),
                    width: 15,
                    height: 23,
                    decoration: BoxDecoration(
                      color: index < completed
                          ? BloomTheme.primaryRose
                          : BloomTheme.secondaryPeach.withValues(alpha: .38),
                      borderRadius: const BorderRadius.all(
                        Radius.elliptical(14, 20),
                      ),
                      border: Border.all(
                        color: BloomTheme.primaryRose.withValues(alpha: .35),
                      ),
                    ),
                  ),
                ),
              ),
            Container(
              width: 19,
              height: 19,
              decoration: BoxDecoration(
                color: const Color(0xFFE7B862),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedBook extends StatelessWidget {
  final Story story;
  final Animation<double> animation;
  final bool reduceMotion;
  final VoidCallback onTap;

  const _FeaturedBook({
    required this.story,
    required this.animation,
    required this.reduceMotion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label:
          'Featured book, ${story.title}. ${story.isCompleted ? 'Story explored. Read again.' : 'Not started. Begin this story.'}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: Container(
            height: 270,
            decoration: BoxDecoration(
              color: const Color(0xFFF7DDE2),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFFD9A7AF)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x26785B50),
                  blurRadius: 22,
                  offset: Offset(0, 11),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Stack(
                children: [
                  const Positioned.fill(child: _BookBackdrop()),
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 18,
                      decoration: const BoxDecoration(
                        color: Color(0xFFC98794),
                        border: Border(
                          right: BorderSide(color: Color(0x66FFFFFF)),
                        ),
                      ),
                    ),
                  ),
                  AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      final value = reduceMotion ? 0.5 : animation.value;
                      return Positioned(
                        right: 15,
                        top: 16 + (value * 4),
                        child: Transform.rotate(
                          angle: -.15 + (value * .04),
                          child: const Icon(
                            Icons.eco_outlined,
                            color: Color(0x9982A37D),
                            size: 32,
                          ),
                        ),
                      );
                    },
                  ),
                  AnimatedBuilder(
                    animation: animation,
                    child: _FloatingMascot(
                      avatarId: story.starringCharacterId,
                      width: 150,
                      height: 198,
                    ),
                    builder: (context, child) {
                      final offset = reduceMotion
                          ? 0.0
                          : (animation.value - .5) * 8;
                      return Positioned(
                        right: 8,
                        bottom: 18 + offset,
                        child: child!,
                      );
                    },
                  ),
                  Positioned(
                    left: 38,
                    top: 25,
                    right: 130,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .72),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            story.category.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              letterSpacing: .7,
                              fontWeight: FontWeight.w800,
                              color: BloomTheme.darkText,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          story.title,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                height: 1.05,
                                color: const Color(0xFF473B42),
                              ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 38,
                    right: 26,
                    bottom: 24,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            constraints: const BoxConstraints(minHeight: 48),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: BloomTheme.darkText,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.auto_stories_rounded,
                                  color: Colors.white,
                                  size: 19,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    story.isCompleted
                                        ? 'Read again'
                                        : 'Begin this story',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 82),
                      ],
                    ),
                  ),
                  if (story.isCompleted)
                    const Positioned(
                      top: 0,
                      right: 48,
                      child: _CompletedRibbon(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BookBackdrop extends StatelessWidget {
  const _BookBackdrop();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BotanicalPainter(),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF3F0), Color(0xFFF1D5DE)],
          ),
        ),
      ),
    );
  }
}

class _CompletedRibbon extends StatelessWidget {
  const _CompletedRibbon();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Story explored',
      child: Container(
        width: 34,
        height: 62,
        decoration: const BoxDecoration(
          color: Color(0xFF82A37D),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
          boxShadow: [BoxShadow(color: Color(0x20785B50), blurRadius: 5)],
        ),
        child: const Icon(
          Icons.local_florist_rounded,
          color: Colors.white,
          size: 19,
        ),
      ),
    );
  }
}

class _StoryShelf extends StatelessWidget {
  final String title;
  final List<Story> stories;
  final double horizontalPadding;
  final ValueChanged<Story> onStoryTap;

  const _StoryShelf({
    required this.title,
    required this.stories,
    required this.horizontalPadding,
    required this.onStoryTap,
  });

  IconData get _icon => switch (title) {
    'First Period' => Icons.local_florist_outlined,
    'Food & Energy' => Icons.eco_outlined,
    _ => Icons.medical_information_outlined,
  };

  Color get _accent => switch (title) {
    'First Period' => const Color(0xFFE8A7B2),
    'Food & Energy' => const Color(0xFFE9C96A),
    _ => const Color(0xFF8CBED1),
  };

  String get _subtitle => switch (title) {
    'First Period' => 'Gentle stories for new beginnings',
    'Food & Energy' => 'Curious about food? Start here.',
    _ => 'Find what feels comfortable for you',
  };

  @override
  Widget build(BuildContext context) {
    final cardWidth = (MediaQuery.sizeOf(context).width * .66).clamp(
      215.0,
      270.0,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: _accent.withValues(alpha: .2),
                  shape: BoxShape.circle,
                ),
                child: Icon(_icon, color: BloomTheme.darkText, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    Text(
                      _subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 244,
          child: ListView.separated(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              12,
              horizontalPadding + 48,
              12,
            ),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: stories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (context, index) => _TactileStoryCard(
              story: stories[index],
              accent: _accent,
              width: cardWidth,
              rotation: index.isEven ? -.012 : .012,
              onTap: () => onStoryTap(stories[index]),
            ),
          ),
        ),
        Container(
          height: 9,
          margin: EdgeInsets.symmetric(horizontal: horizontalPadding - 2),
          decoration: BoxDecoration(
            color: const Color(0xFFD7BE99).withValues(alpha: .58),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0x18785B50),
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TactileStoryCard extends StatefulWidget {
  final Story story;
  final Color accent;
  final double width;
  final double rotation;
  final VoidCallback onTap;

  const _TactileStoryCard({
    required this.story,
    required this.accent,
    required this.width,
    required this.rotation,
    required this.onTap,
  });

  @override
  State<_TactileStoryCard> createState() => _TactileStoryCardState();
}

class _TactileStoryCardState extends State<_TactileStoryCard> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return Semantics(
      button: true,
      label:
          '${widget.story.title}. ${widget.story.isCompleted ? 'Story explored. Read again.' : 'Not started. Begin this story.'}',
      child: GestureDetector(
        onTapDown: (_) => _setPressed(true),
        onTapCancel: () => _setPressed(false),
        onTapUp: (_) {
          _setPressed(false);
          widget.onTap();
        },
        child: AnimatedScale(
          scale: reduceMotion ? 1 : (_pressed ? 1.018 : 1),
          duration: const Duration(milliseconds: 130),
          curve: Curves.easeOut,
          child: AnimatedSlide(
            offset: reduceMotion
                ? Offset.zero
                : (_pressed ? const Offset(0, -.012) : Offset.zero),
            duration: const Duration(milliseconds: 130),
            child: Transform.rotate(
              angle: reduceMotion ? 0 : widget.rotation,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 130),
                width: widget.width,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFCF6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: widget.accent.withValues(alpha: .4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(
                        0xFF785B50,
                      ).withValues(alpha: _pressed ? .17 : .1),
                      blurRadius: _pressed ? 15 : 9,
                      offset: Offset(0, _pressed ? 8 : 5),
                    ),
                  ],
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Icon(
                        Icons.eco,
                        color: widget.accent.withValues(alpha: .5),
                        size: 24,
                      ),
                    ),
                    Positioned(
                      top: -18,
                      left: 8,
                      child: _FloatingMascot(
                        avatarId: widget.story.starringCharacterId,
                        width: 92,
                        height: 112,
                      ),
                    ),
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 82, 16, 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.story.title,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontSize: 18, height: 1.08),
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  widget.story.isCompleted
                                      ? Icons.local_florist_rounded
                                      : Icons.circle_outlined,
                                  size: 15,
                                  color: widget.story.isCompleted
                                      ? BloomTheme.sageGreen
                                      : BloomTheme.subText,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    widget.story.isCompleted
                                        ? 'Story explored'
                                        : 'Not started',
                                    style: const TextStyle(
                                      color: BloomTheme.darkText,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 18,
                                  color: BloomTheme.darkText,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LibraryActions extends StatelessWidget {
  final VoidCallback onSurprise;
  final VoidCallback onAskBloom;

  const _LibraryActions({required this.onSurprise, required this.onAskBloom});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onSurprise,
            icon: const Icon(Icons.casino_outlined, size: 20),
            label: const Text('Surprise me'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 50),
              foregroundColor: BloomTheme.darkText,
              side: const BorderSide(color: BloomTheme.borderSoft),
              backgroundColor: Colors.white.withValues(alpha: .75),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Semantics(
          button: true,
          label: 'Ask Bloom. Open the Bloom AI companion.',
          child: FilledButton.icon(
            onPressed: onAskBloom,
            icon: const Icon(Icons.auto_awesome_rounded, size: 18),
            label: const Text('Ask Bloom'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, 50),
              backgroundColor: BloomTheme.sageGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FloatingMascot extends StatelessWidget {
  final String avatarId;
  final double width;
  final double height;

  const _FloatingMascot({
    required this.avatarId,
    required this.width,
    required this.height,
  });

  String get _asset {
    final id = avatarId.toLowerCase();
    final safeId = const {'ananya', 'meera', 'lavanya', 'kiara'}.contains(id)
        ? id
        : 'ananya';
    return 'assets/images/avatar/mascots/${safeId}_mascot.png';
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: '${avatarId[0].toUpperCase()}${avatarId.substring(1)} mascot',
      child: SizedBox(
        width: width,
        height: height,
        child: Image.asset(
          _asset,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          errorBuilder: (_, _, _) => const Center(
            child: Icon(
              Icons.local_florist_rounded,
              color: BloomTheme.primaryRose,
              size: 42,
            ),
          ),
        ),
      ),
    );
  }
}

class _PaperGrain extends StatelessWidget {
  const _PaperGrain();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(child: CustomPaint(painter: _PaperGrainPainter()));
  }
}

class _PaperGrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0x0A705A4D);
    const spacing = 19.0;
    for (double y = 7; y < size.height; y += spacing) {
      for (double x = 5; x < size.width; x += spacing) {
        final offset = ((y / spacing).round().isEven) ? 0.0 : 8.0;
        canvas.drawCircle(Offset(x + offset, y), .55, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BotanicalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x3782A37D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final path = Path()
      ..moveTo(size.width * .58, size.height)
      ..quadraticBezierTo(
        size.width * .72,
        size.height * .48,
        size.width,
        size.height * .38,
      );
    canvas.drawPath(path, paint);
    for (final point in [
      Offset(size.width * .72, size.height * .66),
      Offset(size.width * .82, size.height * .5),
      Offset(size.width * .91, size.height * .42),
    ]) {
      canvas.drawOval(
        Rect.fromCenter(center: point, width: 22, height: 10),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LibraryError extends StatelessWidget {
  final VoidCallback onRetry;

  const _LibraryError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.menu_book_outlined,
              size: 48,
              color: BloomTheme.primaryRose,
            ),
            const SizedBox(height: 12),
            Text(
              'The story shelf needs a moment.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onRetry,
              child: const Text('Try the shelf again'),
            ),
          ],
        ),
      ),
    );
  }
}
