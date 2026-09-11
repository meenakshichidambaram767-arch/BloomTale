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
 final String coverImage;
 final String category;
 final String starringCharacterId;
 final int xpReward;
 final List<StoryScene> scenes;

 const Story({
 required this.id,
 required this.title,
 required this.description,
 required this.coverImage,
 required this.category,
 this.starringCharacterId = 'ananya',
 this.xpReward = 20,
 required this.scenes,
 });

 factory Story.fromJson(Map<String, dynamic> json) {
 return Story(
 id: json['id'] as String,
 title: json['title'] as String,
 description: json['description'] as String,
 coverImage: json['coverImage'] as String,
 category: json['category'] as String,
 starringCharacterId: (json['starringCharacterId'] as String?) ?? 'ananya',
 xpReward: (json['xpReward'] as int?) ?? 20,
 scenes: (json['scenes'] as List)
 .map((s) => StoryScene.fromJson(s as Map<String, dynamic>))
 .toList(),
 );
 }

 Map<String, dynamic> toJson() {
 return {
 'id': id,
 'title': title,
 'description': description,
 'coverImage': coverImage,
 'category': category,
 'starringCharacterId': starringCharacterId,
 'xpReward': xpReward,
 'scenes': scenes.map((s) => s.toJson()).toList(),
 };
 }
}

