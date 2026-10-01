import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../app/providers.dart';
import '../app/theme.dart';
import '../models/story.dart';
import '../widgets/bloom_avatar.dart';
import '../widgets/bloom_button.dart';
import '../widgets/bloom_card.dart';

class StorySceneScreen extends ConsumerStatefulWidget {
  final String storyId;

  const StorySceneScreen({super.key, required this.storyId});

  @override
  ConsumerState<StorySceneScreen> createState() => _StorySceneScreenState();
}

class _StorySceneScreenState extends ConsumerState<StorySceneScreen> {
  late Future<Story?> _storyFuture;
  String? _currentSceneId;
  final List<String> _history = [];
  bool _completing = false;

  @override
  void initState() {
    super.initState();
    _storyFuture = ref
        .read(storyRepositoryProvider)
        .getStoryById(widget.storyId);
  }

  void _goTo(Story story, String sceneId) {
    if (story.sceneById(sceneId) == null) return;
    final current = _currentSceneId ?? story.firstScene?.id;
    if (current != null) _history.add(current);
    setState(() => _currentSceneId = sceneId);
  }

  void _goBack(Story story) {
    if (_history.isEmpty) {
      context.pop();
      return;
    }
    setState(() => _currentSceneId = _history.removeLast());
  }

  Future<void> _complete(Story story) async {
    if (_completing) return;
    setState(() => _completing = true);
    await ref.read(storyRepositoryProvider).markStoryCompleted(story.id);
    ref.read(userProvider.notifier).addXp(story.xpReward);
    ref.invalidate(storyListProvider);
    if (mounted) context.go('/stories/${story.id}/completion');
  }

  Color _sceneColor(StorySceneType type) {
    switch (type) {
      case StorySceneType.decision:
        return BloomTheme.accentLavender;
      case StorySceneType.consequence:
        return BloomTheme.secondaryPeach.withValues(alpha: 0.55);
      case StorySceneType.reflection:
        return BloomTheme.mintFresh.withValues(alpha: 0.55);
      case StorySceneType.bloomFact:
        return BloomTheme.primaryRose.withValues(alpha: 0.12);
      case StorySceneType.narrative:
        return Colors.white;
    }
  }

  String _sceneLabel(StorySceneType type) {
    switch (type) {
      case StorySceneType.decision:
        return 'YOUR CHOICE';
      case StorySceneType.consequence:
        return 'WHAT HAPPENS NEXT';
      case StorySceneType.reflection:
        return 'PAUSE & REFLECT';
      case StorySceneType.bloomFact:
        return 'BLOOM FACT';
      case StorySceneType.narrative:
        return 'STORY';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Story?>(
      future: _storyFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: BloomTheme.softCream,
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final story = snapshot.data;
        if (story == null || story.firstScene == null) {
          return Scaffold(
            backgroundColor: BloomTheme.softCream,
            appBar: AppBar(title: const Text('Story unavailable')),
            body: const Center(child: Text('This story could not be loaded.')),
          );
        }

        final scene =
            story.sceneById(_currentSceneId ?? story.firstScene!.id) ??
            story.firstScene!;
        final progress = ((_history.length + 1) / 8)
            .clamp(0.08, 1.0)
            .toDouble();

        return Scaffold(
          backgroundColor: BloomTheme.softCream,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => _goBack(story),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              story.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 7),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: scene.isEnding ? 1 : progress,
                                minHeight: 7,
                                backgroundColor: BloomTheme.primaryRose
                                    .withValues(alpha: .1),
                                color: BloomTheme.primaryRose,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: SingleChildScrollView(
                      key: ValueKey(scene.id),
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _sceneColor(scene.type),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _sceneLabel(scene.type),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                                color: BloomTheme.darkText,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          BloomAvatar(
                            avatarId: scene.characterId,
                            activity: scene.type == StorySceneType.decision
                                ? 'reading'
                                : 'cozy',
                            size: 132,
                            showBadge: scene.isEnding,
                          ),
                          const SizedBox(height: 18),
                          Text(
                            scene.title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: BloomTheme.darkText,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 14),
                          BloomCard(
                            backgroundColor: _sceneColor(scene.type),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  scene.narration,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    height: 1.45,
                                    color: BloomTheme.darkText,
                                  ),
                                ),
                                if (scene.dialogue.isNotEmpty) ...[
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: .72,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      scene.dialogue,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        height: 1.4,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                                if (scene.isEnding) ...[
                                  const SizedBox(height: 18),
                                  _FactTile(
                                    icon: Icons.local_florist_rounded,
                                    title: 'Bloom Fact',
                                    text: scene.bloomFact ?? '',
                                    color: BloomTheme.mintFresh,
                                  ),
                                  const SizedBox(height: 10),
                                  _FactTile(
                                    icon: Icons.close_rounded,
                                    title: 'Myth',
                                    text: scene.myth ?? '',
                                    color: BloomTheme.secondaryPeach,
                                  ),
                                  const SizedBox(height: 10),
                                  _FactTile(
                                    icon: Icons.check_rounded,
                                    title: 'Fact',
                                    text: scene.fact ?? '',
                                    color: BloomTheme.accentLavender,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    scene.completionMessage ?? '',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (scene.isDecision) ...[
                            const SizedBox(height: 18),
                            ...scene.choices.asMap().entries.map(
                              (entry) => Padding(
                                padding: const EdgeInsets.only(bottom: 11),
                                child: Semantics(
                                  button: true,
                                  label:
                                      'Choice ${entry.key + 1}: ${entry.value.text}',
                                  child: OutlinedButton(
                                    onPressed: () =>
                                        _goTo(story, entry.value.nextSceneId),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 16,
                                      ),
                                      alignment: Alignment.centerLeft,
                                      backgroundColor: Colors.white,
                                      side: BorderSide(
                                        color: BloomTheme.primaryRose
                                            .withValues(alpha: .35),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(17),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 14,
                                          backgroundColor:
                                              BloomTheme.primaryRose,
                                          child: Text(
                                            String.fromCharCode(65 + entry.key),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            entry.value.text,
                                            style: const TextStyle(
                                              color: BloomTheme.darkText,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ] else ...[
                            const SizedBox(height: 20),
                            BloomButton(
                              text: scene.isEnding
                                  ? (_completing
                                        ? 'Completing…'
                                        : 'Complete Story')
                                  : 'Continue',
                              icon: scene.isEnding
                                  ? Icons.check_circle_rounded
                                  : Icons.arrow_forward_rounded,
                              onPressed: _completing
                                  ? null
                                  : () {
                                      if (scene.isEnding) {
                                        _complete(story);
                                      } else if (scene.nextSceneId != null) {
                                        _goTo(story, scene.nextSceneId!);
                                      }
                                    },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FactTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  final Color color;

  const _FactTile({
    required this.icon,
    required this.title,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .65),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: BloomTheme.darkText),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  TextSpan(text: text),
                ],
              ),
              style: const TextStyle(color: BloomTheme.darkText, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
