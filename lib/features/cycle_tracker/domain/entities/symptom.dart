import 'package:equatable/equatable.dart';

class SymptomEntry extends Equatable {
 final String id;
 final String userId;
 final DateTime date;
 final List<String> symptoms; // Cramps, Headache, Bloating, Backache, Fatigue, Acne, Breast tenderness, Mood changes, Other
 final String? notes;
 final DateTime createdAt;

 const SymptomEntry({
 required this.id,
 required this.userId,
 required this.date,
 required this.symptoms,
 this.notes,
 required this.createdAt,
 });

 @override
 List<Object?> get props => [id, userId, date, symptoms, notes, createdAt];
}
