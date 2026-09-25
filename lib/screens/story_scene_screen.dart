import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../app/theme.dart';
import '../app/providers.dart';
import '../models/story.dart';
import '../services/story_service.dart';

class StorySceneScreen extends ConsumerStatefulWidget {
  final String storyId;
  const StorySceneScreen({super.key, required this.storyId});

  @override
  ConsumerState<StorySceneScreen> createState() => _StorySceneScreenState();
}

class _StorySceneScreenState extends ConsumerState<StorySceneScreen> {
  StoryStage _currentStage = StoryStage.scenario;
  StoryChoiceKey? _selectedChoice;

  void _onChoiceSelected(StoryChoiceKey choiceKey) {
    setState(() {
      _selectedChoice = choiceKey;
      _currentStage = StoryStage.consequence;
    });
  }

  void _nextStage() {
    setState(() {
      switch (_currentStage) {
        case StoryStage.scenario:
          _currentStage = StoryStage.choice;
          break;
        case StoryStage.choice:
          // Must select a choice on choice screen before progressing
          break;
        case StoryStage.consequence:
          _currentStage = StoryStage.bloomFact;
          break;
        case StoryStage.bloomFact:
          _completeStory();
          break;
        case StoryStage.completed:
          break;
      }
    });
  }

  void _previousStage() {
    setState(() {
      switch (_currentStage) {
        case StoryStage.scenario:
          context.pop();
          break;
        case StoryStage.choice:
          _currentStage = StoryStage.scenario;
          break;
        case StoryStage.consequence:
          _currentStage = StoryStage.choice;
          break;
        case StoryStage.bloomFact:
          _currentStage = StoryStage.consequence;
          break;
        case StoryStage.completed:
          _currentStage = StoryStage.bloomFact;
          break;
      }
    });
  }

  Future<void> _completeStory() async {
    final storyRepo = ref.read(storyRepositoryProvider);
    await storyRepo.markStoryCompleted(widget.storyId);
    ref.read(userProvider.notifier).addXp(20);

    if (mounted) {
      context.go('/stories/${widget.storyId}/completion');
    }
  }

  String _getActiveAsset(Story story) {
    switch (_currentStage) {
      case StoryStage.scenario:
        return story.scenarioAsset;
      case StoryStage.choice:
        return story.choiceAsset;
      case StoryStage.consequence:
        if (_selectedChoice == null) return story.scenarioAsset;
        return story.consequenceAssets[_selectedChoice!] ?? story.scenarioAsset;
      case StoryStage.bloomFact:
      case StoryStage.completed:
        return story.bloomFactAsset;
    }
  }

  int _getStepNumber() {
    switch (_currentStage) {
      case StoryStage.scenario:
        return 1;
      case StoryStage.choice:
        return 2;
      case StoryStage.consequence:
        return 3;
      case StoryStage.bloomFact:
      case StoryStage.completed:
        return 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    final storyRepo = ref.watch(storyRepositoryProvider);

    return FutureBuilder<Story?>(
      future: storyRepo.getStoryById(widget.storyId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: BloomTheme.softCream,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final story = snapshot.data;
        if (story == null) {
          return Scaffold(
            backgroundColor: BloomTheme.softCream,
            appBar: AppBar(title: const Text('Story')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Story illustration unavailable.'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: const Text('Try Again'),
                  )
                ],
              ),
            ),
          );
        }

        final activeAsset = _getActiveAsset(story);
        final currentStep = _getStepNumber();

        return Scaffold(
          backgroundColor: BloomTheme.softCream,
          body: SafeArea(
            child: Column(
              children: [
                // Top Navigation Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: BloomTheme.darkText),
                        onPressed: _previousStage,
                      ),
                      const SizedBox(width: 8),
                      // Progress dots
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(4, (index) {
                            final stepIndex = index + 1;
                            final isActive = stepIndex == currentStep;
                            final isCompleted = stepIndex < currentStep;

                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: isActive ? 24 : 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? BloomTheme.primaryRose
                                    : isCompleted
                                        ? BloomTheme.primaryRose.withValues(alpha: 0.5)
                                        : BloomTheme.subText.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            );
                          }),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: BloomTheme.darkText),
                        onPressed: () => context.pop(),
                      ),
                    ],
                  ),
                ),

                // Main Story Display Container
                Expanded(
                  child: GestureDetector(
                    onHorizontalDragEnd: (details) {
                      if (details.primaryVelocity != null) {
                        if (details.primaryVelocity! < -200) {
                          // Swipe left (forward)
                          if (_currentStage != StoryStage.choice) {
                            _nextStage();
                          }
                        } else if (details.primaryVelocity! > 200) {
                          // Swipe right (backward)
                          _previousStage();
                        }
                      }
                    },
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 1365 / 2048,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Stack(
                              children: [
                                // Full Story Screen Image
                                Positioned.fill(
                                  child: Image.asset(
                                    activeAsset,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: Text('Story illustration unavailable.'),
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                // Interactive Choice Overlays (Only on Choice Stage)
                                if (_currentStage == StoryStage.choice) ...[
                                  // Choice A Hit Target
                                  Positioned(
                                    top: constraints.maxHeight * 0.26,
                                    height: constraints.maxHeight * 0.17,
                                    left: constraints.maxWidth * 0.33,
                                    right: constraints.maxWidth * 0.05,
                                    child: Semantics(
                                      button: true,
                                      label: story.choiceSemanticLabels[StoryChoiceKey.a] ??
                                          'Choice A. Leave the kitchen immediately.',
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(16),
                                          splashColor: BloomTheme.primaryRose.withValues(alpha: 0.15),
                                          highlightColor: BloomTheme.primaryRose.withValues(alpha: 0.1),
                                          onTap: () => _onChoiceSelected(StoryChoiceKey.a),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Choice B Hit Target
                                  Positioned(
                                    top: constraints.maxHeight * 0.46,
                                    height: constraints.maxHeight * 0.17,
                                    left: constraints.maxWidth * 0.33,
                                    right: constraints.maxWidth * 0.05,
                                    child: Semantics(
                                      button: true,
                                      label: story.choiceSemanticLabels[StoryChoiceKey.b] ??
                                          'Choice B. Continue helping normally.',
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(16),
                                          splashColor: BloomTheme.mintFresh.withValues(alpha: 0.2),
                                          highlightColor: BloomTheme.mintFresh.withValues(alpha: 0.1),
                                          onTap: () => _onChoiceSelected(StoryChoiceKey.b),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Choice C Hit Target
                                  Positioned(
                                    top: constraints.maxHeight * 0.66,
                                    height: constraints.maxHeight * 0.20,
                                    left: constraints.maxWidth * 0.33,
                                    right: constraints.maxWidth * 0.05,
                                    child: Semantics(
                                      button: true,
                                      label: story.choiceSemanticLabels[StoryChoiceKey.c] ??
                                          'Choice C. Ask why menstruation would prevent you from cooking.',
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(16),
                                          splashColor: BloomTheme.accentLavender.withValues(alpha: 0.25),
                                          highlightColor: BloomTheme.accentLavender.withValues(alpha: 0.1),
                                          onTap: () => _onChoiceSelected(StoryChoiceKey.c),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                // Bottom Action Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      if (_currentStage != StoryStage.choice) ...[
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: BloomTheme.primaryRose,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            onPressed: _nextStage,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _currentStage == StoryStage.bloomFact
                                      ? 'Complete Story'
                                      : 'Continue',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  _currentStage == StoryStage.bloomFact
                                      ? Icons.check_circle_rounded
                                      : Icons.arrow_forward_rounded,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ] else ...[
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: const Text(
                              'Tap Choice A, B, or C above to continue',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: BloomTheme.subText,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
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
