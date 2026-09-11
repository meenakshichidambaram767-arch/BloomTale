import '../../domain/entities/period_log.dart';

class PeriodLogModel extends PeriodLog {
 const PeriodLogModel({
 required super.id,
 required super.userId,
 required super.startDate,
 super.endDate,
 required super.flow,
 super.notes,
 required super.createdAt,
 });

 factory PeriodLogModel.fromJson(Map<String, dynamic> json) {
 return PeriodLogModel(
 id: json['id'] as String,
 userId: json['userId'] as String? ?? 'default_user',
 startDate: DateTime.parse(json['startDate'] as String),
 endDate: json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null,
 flow: json['flow'] as String? ?? 'Medium',
 notes: json['notes'] as String?,
 createdAt: DateTime.parse(json['createdAt'] as String),
 );
 }

 Map<String, dynamic> toJson() {
 return {
 'id': id,
 'userId': userId,
 'startDate': startDate.toIso8601String(),
 'endDate': endDate?.toIso8601String(),
 'flow': flow,
 'notes': notes,
 'createdAt': createdAt.toIso8601String(),
 };
 }

 factory PeriodLogModel.fromEntity(PeriodLog entity) {
 return PeriodLogModel(
 id: entity.id,
 userId: entity.userId,
 startDate: entity.startDate,
 endDate: entity.endDate,
 flow: entity.flow,
 notes: entity.notes,
 createdAt: entity.createdAt,
 );
 }
}
