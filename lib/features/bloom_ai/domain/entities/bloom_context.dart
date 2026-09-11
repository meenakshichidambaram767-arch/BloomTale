import 'bloom_enums.dart';

class BloomContext {
 final String? source; // tracker, calendar, story, journal, direct
 final String? topic;
 final String? initialQuestion;
 final String? symptomContext;
 final String? moodContext;
 final String? upcomingEvent;
 final String? storyId;
 final ExplanationLevel preferredExplanationLevel;

 const BloomContext({
 this.source,
 this.topic,
 this.initialQuestion,
 this.symptomContext,
 this.moodContext,
 this.upcomingEvent,
 this.storyId,
 this.preferredExplanationLevel = ExplanationLevel.simple,
 });

 bool get hasContext =>
 source != null ||
 topic != null ||
 symptomContext != null ||
 upcomingEvent != null ||
 storyId != null;

 BloomContext copyWith({
 String? source,
 String? topic,
 String? initialQuestion,
 String? symptomContext,
 String? moodContext,
 String? upcomingEvent,
 String? storyId,
 ExplanationLevel? preferredExplanationLevel,
 }) {
 return BloomContext(
 source: source ?? this.source,
 topic: topic ?? this.topic,
 initialQuestion: initialQuestion ?? this.initialQuestion,
 symptomContext: symptomContext ?? this.symptomContext,
 moodContext: moodContext ?? this.moodContext,
 upcomingEvent: upcomingEvent ?? this.upcomingEvent,
 storyId: storyId ?? this.storyId,
 preferredExplanationLevel: preferredExplanationLevel ?? this.preferredExplanationLevel,
 );
 }
}
