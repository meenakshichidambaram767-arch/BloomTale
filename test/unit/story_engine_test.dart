import 'package:bloomtale/models/story.dart';
import 'package:bloomtale/services/story_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BloomTale branching story engine', () {
    final repository = MockStoryService();

    test('provides exactly six complete stories', () async {
      final stories = await repository.getStories();

      expect(stories, hasLength(6));
      expect(stories.map((story) => story.id).toSet(), hasLength(6));
      expect(stories.every((story) => story.scenes.isNotEmpty), isTrue);
      expect(
        stories.every(
          (story) => story.scenes.last.type == StorySceneType.bloomFact,
        ),
        isTrue,
      );
    });

    test('every choice has a valid, choice-specific consequence', () async {
      final stories = await repository.getStories();

      for (final story in stories) {
        final decisions = story.scenes
            .where((scene) => scene.isDecision)
            .toList();
        expect(decisions.length, greaterThanOrEqualTo(2), reason: story.title);

        for (final decision in decisions) {
          expect(decision.choices.length, inInclusiveRange(2, 3));
          final destinations = decision.choices
              .map((choice) => choice.nextSceneId)
              .toSet();
          expect(destinations, hasLength(decision.choices.length));

          for (final destination in destinations) {
            final consequence = story.sceneById(destination);
            expect(
              consequence,
              isNotNull,
              reason: '${story.title}: missing $destination',
            );
            expect(consequence!.type, StorySceneType.consequence);
          }
        }
      }
    });

    test('all scene links resolve inside their story', () async {
      final stories = await repository.getStories();

      for (final story in stories) {
        for (final scene in story.scenes) {
          if (scene.nextSceneId != null) {
            expect(
              story.sceneById(scene.nextSceneId!),
              isNotNull,
              reason: '${story.title}: ${scene.id}',
            );
          }
        }
      }
    });

    test('unknown story IDs do not open a different story', () async {
      expect(await repository.getStoryById('not-a-story'), isNull);
    });
  });
}
