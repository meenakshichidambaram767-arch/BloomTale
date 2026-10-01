enum StorySceneType { narrative, decision, consequence, reflection, bloomFact }

class StoryChoice {
  final String id;
  final String text;
  final String nextSceneId;
  final int learningScore;
  final String? educationalNote;

  const StoryChoice({
    required this.id,
    required this.text,
    required this.nextSceneId,
    this.learningScore = 10,
    this.educationalNote,
  });

  factory StoryChoice.fromJson(Map<String, dynamic> json) => StoryChoice(
    id: json['id'] as String,
    text: json['text'] as String,
    nextSceneId: json['nextSceneId'] as String,
    learningScore: (json['learningScore'] as int?) ?? 10,
    educationalNote: json['educationalNote'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'nextSceneId': nextSceneId,
    'learningScore': learningScore,
    'educationalNote': educationalNote,
  };
}

class StoryScene {
  final String id;
  final StorySceneType type;
  final String title;
  final String narration;
  final String dialogue;
  final String characterId;
  final String characterExpression;
  final String visualDirection;
  final String animationDirection;
  final String? nextSceneId;
  final List<StoryChoice> choices;
  final String? bloomFact;
  final String? myth;
  final String? fact;
  final String? completionMessage;

  const StoryScene({
    required this.id,
    this.type = StorySceneType.narrative,
    this.title = '',
    this.narration = '',
    this.dialogue = '',
    this.characterId = 'ananya',
    this.characterExpression = 'happy',
    this.visualDirection = '',
    this.animationDirection = '',
    this.nextSceneId,
    this.choices = const [],
    this.bloomFact,
    this.myth,
    this.fact,
    this.completionMessage,
  });

  bool get isDecision => type == StorySceneType.decision;
  bool get isEnding => type == StorySceneType.bloomFact;

  factory StoryScene.fromJson(Map<String, dynamic> json) => StoryScene(
    id: json['id'] as String,
    type: StorySceneType.values.firstWhere(
      (value) => value.name == json['type'],
      orElse: () => StorySceneType.narrative,
    ),
    title: (json['title'] as String?) ?? '',
    narration: (json['narration'] as String?) ?? '',
    dialogue: (json['dialogue'] as String?) ?? '',
    characterId: (json['characterId'] as String?) ?? 'ananya',
    characterExpression: (json['characterExpression'] as String?) ?? 'happy',
    visualDirection: (json['visualDirection'] as String?) ?? '',
    animationDirection: (json['animationDirection'] as String?) ?? '',
    nextSceneId: json['nextSceneId'] as String?,
    choices: ((json['choices'] as List?) ?? const [])
        .map((choice) => StoryChoice.fromJson(choice as Map<String, dynamic>))
        .toList(),
    bloomFact: json['bloomFact'] as String?,
    myth: json['myth'] as String?,
    fact: json['fact'] as String?,
    completionMessage: json['completionMessage'] as String?,
  );
}

class Story {
  final String id;
  final String title;
  final String description;
  final String category;
  final String starringCharacterId;
  final List<String> supportingCharacterIds;
  final int xpReward;
  final List<String> learningObjectives;
  final List<StoryScene> scenes;
  final bool isCompleted;

  // Compatibility fields for the existing book and cover widgets.
  final String scenarioAsset;
  final String choiceAsset;
  final Map<Object, String> consequenceAssets;
  final String bloomFactAsset;

  const Story({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.starringCharacterId = 'ananya',
    this.supportingCharacterIds = const [],
    this.xpReward = 20,
    this.learningObjectives = const [],
    this.scenes = const [],
    this.isCompleted = false,
    this.scenarioAsset = '',
    this.choiceAsset = '',
    this.consequenceAssets = const {},
    this.bloomFactAsset = '',
  });

  String get coverImage => scenarioAsset;
  StoryScene? get firstScene => scenes.isEmpty ? null : scenes.first;

  StoryScene? sceneById(String id) {
    for (final scene in scenes) {
      if (scene.id == id) return scene;
    }
    return null;
  }

  Story copyWith({bool? isCompleted}) => Story(
    id: id,
    title: title,
    description: description,
    category: category,
    starringCharacterId: starringCharacterId,
    supportingCharacterIds: supportingCharacterIds,
    xpReward: xpReward,
    learningObjectives: learningObjectives,
    scenes: scenes,
    isCompleted: isCompleted ?? this.isCompleted,
    scenarioAsset: scenarioAsset,
    choiceAsset: choiceAsset,
    consequenceAssets: consequenceAssets,
    bloomFactAsset: bloomFactAsset,
  );
}
