enum StoryStage {
  scenario,
  choice,
  consequence,
  bloomFact,
  completed,
}

enum StoryChoiceKey {
  a,
  b,
  c,
}

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
    required this.learningScore,
    this.educationalNote,
  });

  factory StoryChoice.fromJson(Map<String, dynamic> json) {
    return StoryChoice(
      id: json['id'] as String,
      text: json['text'] as String,
      nextSceneId: json['nextSceneId'] as String,
      learningScore: (json['learningScore'] as int?) ?? 10,
      educationalNote: json['educationalNote'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'nextSceneId': nextSceneId,
      'learningScore': learningScore,
      'educationalNote': educationalNote,
    };
  }
}

class StoryScene {
  final String id;
  final String backgroundImage;
  final String characterImage;
  final String characterId;
  final String characterExpression;
  final String dialogue;
  final List<StoryChoice> choices;

  const StoryScene({
    required this.id,
    required this.backgroundImage,
    required this.characterImage,
    this.characterId = 'ananya',
    this.characterExpression = 'happy',
    required this.dialogue,
    required this.choices,
  });

  factory StoryScene.fromJson(Map<String, dynamic> json) {
    return StoryScene(
      id: json['id'] as String,
      backgroundImage: json['backgroundImage'] as String,
      characterImage: json['characterImage'] as String,
      characterId: (json['characterId'] as String?) ?? 'ananya',
      characterExpression: (json['characterExpression'] as String?) ?? 'happy',
      dialogue: json['dialogue'] as String,
      choices: (json['choices'] as List)
          .map((c) => StoryChoice.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'backgroundImage': backgroundImage,
      'characterImage': characterImage,
      'characterId': characterId,
      'characterExpression': characterExpression,
      'dialogue': dialogue,
      'choices': choices.map((c) => c.toJson()).toList(),
    };
  }
}

class Story {
  final String id;
  final String title;
  final String description;
  final String category;
  final String starringCharacterId;
  final int xpReward;
  final String scenarioAsset;
  final String choiceAsset;
  final Map<StoryChoiceKey, String> consequenceAssets;
  final Map<StoryChoiceKey, String> choiceSemanticLabels;
  final String bloomFactAsset;
  final List<StoryScene> scenes;
  final bool isCompleted;

  const Story({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.starringCharacterId = 'ananya',
    this.xpReward = 20,
    required this.scenarioAsset,
    required this.choiceAsset,
    required this.consequenceAssets,
    this.choiceSemanticLabels = const {
      StoryChoiceKey.a: 'Choice A. Leave the kitchen immediately.',
      StoryChoiceKey.b: 'Choice B. Continue helping normally.',
      StoryChoiceKey.c: 'Choice C. Ask why menstruation would prevent you from cooking.',
    },
    required this.bloomFactAsset,
    this.scenes = const [],
    this.isCompleted = false,
  });

  String get coverImage => scenarioAsset;

  Story copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? starringCharacterId,
    int? xpReward,
    String? scenarioAsset,
    String? choiceAsset,
    Map<StoryChoiceKey, String>? consequenceAssets,
    Map<StoryChoiceKey, String>? choiceSemanticLabels,
    String? bloomFactAsset,
    List<StoryScene>? scenes,
    bool? isCompleted,
  }) {
    return Story(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      starringCharacterId: starringCharacterId ?? this.starringCharacterId,
      xpReward: xpReward ?? this.xpReward,
      scenarioAsset: scenarioAsset ?? this.scenarioAsset,
      choiceAsset: choiceAsset ?? this.choiceAsset,
      consequenceAssets: consequenceAssets ?? this.consequenceAssets,
      choiceSemanticLabels: choiceSemanticLabels ?? this.choiceSemanticLabels,
      bloomFactAsset: bloomFactAsset ?? this.bloomFactAsset,
      scenes: scenes ?? this.scenes,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
