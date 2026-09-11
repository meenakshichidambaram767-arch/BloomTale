import 'package:equatable/equatable.dart';

class MoodEntry extends Equatable {
 final String id;
 final String userId;
 final DateTime date;
 final String mood; // Happy, Calm, Okay, Sad, Irritated, Anxious, Tired
 final DateTime createdAt;

 const MoodEntry({
 required this.id,
 required this.userId,
 required this.date,
 required this.mood,
 required this.createdAt,
 });

 @override
 List<Object?> get props => [id, userId, date, mood, createdAt];
}
