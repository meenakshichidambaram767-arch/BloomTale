import 'package:equatable/equatable.dart';

class DailyCheckIn extends Equatable {
 final String id;
 final String userId;
 final DateTime date;
 final String mood;
 final List<String> symptoms;
 final String? notes;
 final DateTime createdAt;

 const DailyCheckIn({
 required this.id,
 required this.userId,
 required this.date,
 required this.mood,
 required this.symptoms,
 this.notes,
 required this.createdAt,
 });

 @override
 List<Object?> get props => [id, userId, date, mood, symptoms, notes, createdAt];
}
