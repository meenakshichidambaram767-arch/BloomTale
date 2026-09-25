import '../models/story.dart';

abstract class StoryService {
  Future<List<Story>> getStories();
  Future<Story?> getStoryById(String id);
  Future<void> markStoryCompleted(String id);
}

class MockStoryService implements StoryService {
  final Set<String> _completedStoryIds = {};

  static const Story curdMythStory = Story(
    id: 'curd_myth',
    title: 'Can I Eat Curd During My Period?',
    category: 'Myths',
    description: 'Should you avoid curd during your period? Discover the science behind period food beliefs.',
    starringCharacterId: 'ananya',
    xpReward: 25,
    scenarioAsset: 'assets/images/stories/curd_story_01_scenario_ananya.png',
    choiceAsset: 'assets/images/stories/curd_story_02_choice_ananya.png',
    consequenceAssets: {
      StoryChoiceKey.a: 'assets/images/stories/curd_story_03_consequence_A_ananya.png',
      StoryChoiceKey.b: 'assets/images/stories/curd_story_04_consequence_B_ananya.png',
      StoryChoiceKey.c: 'assets/images/stories/curd_story_05_consequence_C_ananya.png',
    },
    choiceSemanticLabels: {
      StoryChoiceKey.a: 'Choice A. Eat the curd because it is a normal food.',
      StoryChoiceKey.b: 'Choice B. Avoid the curd because you are afraid it will affect your period.',
      StoryChoiceKey.c: 'Choice C. Ask why you should avoid it before deciding.',
    },
    bloomFactAsset: 'assets/images/stories/curd_story_06_bloom_fact_ananya.png',
  );

  static const Story hairWashingMythStory = Story(
    id: 'hair_washing_myth',
    title: 'Can I Wash My Hair During My Period?',
    category: 'Myths',
    description: 'Discover the truth about hair washing and bathing during your period.',
    starringCharacterId: 'meera',
    xpReward: 25,
    scenarioAsset: 'assets/images/stories/myth_story_01_scenario_ananya.png',
    choiceAsset: 'assets/images/stories/myth_story_02_choice_ananya.png',
    consequenceAssets: {
      StoryChoiceKey.a: 'assets/images/stories/myth_story_03_consequence_A_ananya.png',
      StoryChoiceKey.b: 'assets/images/stories/myth_story_04_consequence_B_ananya.png',
      StoryChoiceKey.c: 'assets/images/stories/myth_story_05_consequence_C_ananya.png',
    },
    choiceSemanticLabels: {
      StoryChoiceKey.a: 'Choice A. Take a warm shower and wash your hair normally.',
      StoryChoiceKey.b: 'Choice B. Wait until your period is over before washing your hair.',
      StoryChoiceKey.c: 'Choice C. Ask Meera why people believe hair washing is harmful.',
    },
    bloomFactAsset: 'assets/images/stories/myth_story_06_bloom_fact_ananya.png',
  );

  static const Story exerciseMythStory = Story(
    id: 'exercise_myth',
    title: 'Should I Avoid Exercise During My Period?',
    category: 'Myths',
    description: 'Learn how gentle physical activity affects period cramps and energy levels.',
    starringCharacterId: 'kiara',
    xpReward: 25,
    scenarioAsset: 'assets/images/stories/curd_story_01_scenario_ananya.png',
    choiceAsset: 'assets/images/stories/curd_story_02_choice_ananya.png',
    consequenceAssets: {
      StoryChoiceKey.a: 'assets/images/stories/curd_story_03_consequence_A_ananya.png',
      StoryChoiceKey.b: 'assets/images/stories/curd_story_04_consequence_B_ananya.png',
      StoryChoiceKey.c: 'assets/images/stories/curd_story_05_consequence_C_ananya.png',
    },
    choiceSemanticLabels: {
      StoryChoiceKey.a: 'Choice A. Go for a light walk or do gentle stretching.',
      StoryChoiceKey.b: 'Choice B. Stay completely still in bed all day.',
      StoryChoiceKey.c: 'Choice C. Ask Kiara what exercises feel best during your cycle.',
    },
    bloomFactAsset: 'assets/images/stories/curd_story_06_bloom_fact_ananya.png',
  );

  static const Story burstingMythsStory = Story(
    id: 'bursting_myths',
    title: 'Bursting Myths',
    category: 'Myths',
    description: 'Challenge a common menstrual myth and discover what the facts really say.',
    starringCharacterId: 'ananya',
    xpReward: 20,
    scenarioAsset: 'assets/images/stories/myth_story_01_scenario_ananya.png',
    choiceAsset: 'assets/images/stories/myth_story_02_choice_ananya.png',
    consequenceAssets: {
      StoryChoiceKey.a: 'assets/images/stories/myth_story_03_consequence_A_ananya.png',
      StoryChoiceKey.b: 'assets/images/stories/myth_story_04_consequence_B_ananya.png',
      StoryChoiceKey.c: 'assets/images/stories/myth_story_05_consequence_C_ananya.png',
    },
    choiceSemanticLabels: {
      StoryChoiceKey.a: 'Choice A. Leave the kitchen immediately.',
      StoryChoiceKey.b: 'Choice B. Continue helping normally.',
      StoryChoiceKey.c: 'Choice C. Ask why menstruation would prevent you from cooking.',
    },
    bloomFactAsset: 'assets/images/stories/myth_story_06_bloom_fact_ananya.png',
  );

  @override
  Future<List<Story>> getStories() async {
    return [
      curdMythStory.copyWith(
        isCompleted: _completedStoryIds.contains('curd_myth'),
      ),
      hairWashingMythStory.copyWith(
        isCompleted: _completedStoryIds.contains('hair_washing_myth'),
      ),
      exerciseMythStory.copyWith(
        isCompleted: _completedStoryIds.contains('exercise_myth'),
      ),
      burstingMythsStory.copyWith(
        isCompleted: _completedStoryIds.contains('bursting_myths'),
      ),
    ];
  }

  @override
  Future<Story?> getStoryById(String id) async {
    final stories = await getStories();
    return stories.firstWhere(
      (s) => s.id == id,
      orElse: () => stories.first,
    );
  }

  @override
  Future<void> markStoryCompleted(String id) async {
    _completedStoryIds.add(id);
  }
}
