import 'entities/bloom_enums.dart';

class BloomAiMessage {
 final String id;
 final String text;
 final String? detailedText;
 final bool isUser;
 final DateTime timestamp;
 final BloomExpression expression;
 final bool isSaved;
 final ExplanationLevel explanationLevel;
 final String? relatedStoryId;
 final List<String> suggestedFollowUps;
 final SafetyCategory safetyCategory;

 const BloomAiMessage({
 required this.id,
 required this.text,
 this.detailedText,
 required this.isUser,
 required this.timestamp,
 this.expression = BloomExpression.happy,
 this.isSaved = false,
 this.explanationLevel = ExplanationLevel.simple,
 this.relatedStoryId,
 this.suggestedFollowUps = const [],
 this.safetyCategory = SafetyCategory.safe,
 });

 String get activeText =>
 (explanationLevel == ExplanationLevel.detail && detailedText != null)
 ? detailedText!
 : text;

 BloomAiMessage copyWith({
 String? id,
 String? text,
 String? detailedText,
 bool? isUser,
 DateTime? timestamp,
 BloomExpression? expression,
 bool? isSaved,
 ExplanationLevel? explanationLevel,
 String? relatedStoryId,
 List<String>? suggestedFollowUps,
 SafetyCategory? safetyCategory,
 }) {
 return BloomAiMessage(
 id: id ?? this.id,
 text: text ?? this.text,
 detailedText: detailedText ?? this.detailedText,
 isUser: isUser ?? this.isUser,
 timestamp: timestamp ?? this.timestamp,
 expression: expression ?? this.expression,
 isSaved: isSaved ?? this.isSaved,
 explanationLevel: explanationLevel ?? this.explanationLevel,
 relatedStoryId: relatedStoryId ?? this.relatedStoryId,
 suggestedFollowUps: suggestedFollowUps ?? this.suggestedFollowUps,
 safetyCategory: safetyCategory ?? this.safetyCategory,
 );
 }
}
