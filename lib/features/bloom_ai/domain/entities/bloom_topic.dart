class BloomTopic {
 final String id;
 final String title;
 final String description;
 final String iconName;
 final int colorHex;
 final List<String> suggestedQuestions;
 final String? relatedStoryId;

 const BloomTopic({
 required this.id,
 required this.title,
 required this.description,
 required this.iconName,
 required this.colorHex,
 required this.suggestedQuestions,
 this.relatedStoryId,
 });
}
