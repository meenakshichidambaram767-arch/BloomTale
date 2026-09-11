import '../../domain/entities/daily_check_in.dart';

class DailyCheckInModel extends DailyCheckIn {
 const DailyCheckInModel({
 required super.id,
 required super.userId,
 required super.date,
 required super.mood,
 required super.symptoms,
 super.notes,
 required super.createdAt,
 });

 factory DailyCheckInModel.fromJson(Map<String, dynamic> json) {
 return DailyCheckInModel(
 id: json['id'] as String,
 userId: json['userId'] as String? ?? 'default_user',
 date: DateTime.parse(json['date'] as String),
 mood: json['mood'] as String? ?? 'Okay',
 symptoms: (json['symptoms'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
 notes: json['notes'] as String?,
 createdAt: DateTime.parse(json['createdAt'] as String),
 );
 }

 Map<String, dynamic> toJson() {
 return {
 'id': id,
 'userId': userId,
 'date': date.toIso8601String(),
 'mood': mood,
 'symptoms': symptoms,
 'notes': notes,
 'createdAt': createdAt.toIso8601String(),
 };
 }

 factory DailyCheckInModel.fromEntity(DailyCheckIn entity) {
 return DailyCheckInModel(
 id: entity.id,
 userId: entity.userId,
 date: entity.date,
 mood: entity.mood,
 symptoms: entity.symptoms,
 notes: entity.notes,
 createdAt: entity.createdAt,
 );
 }
}
