import 'package:flutter_test/flutter_test.dart';
import 'package:bloomtale/features/stories/data/story_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Story Engine Unit Tests', () {
    final storyRepo = MockStoryRepository();

    test('should fetch sample story list containing My First Period', () async {
      final stories = await storyRepo.getStories();
      expect(stories, isNotEmpty);
      expect(stories.first.id, equals('first_period'));
      expect(stories.first.category, equals('Menstruation'));
    });

    test('should retrieve story by ID and verify scene branching choices', () async {
      final story = await storyRepo.getStoryById('first_period');
      expect(story, isNotNull);
      expect(story!.scenes, isNotEmpty);

      final scene1 = story.scenes.first;
      expect(scene1.choices, isNotEmpty);
      expect(scene1.choices.first.nextSceneId, isNotEmpty);
    });
  });
}
