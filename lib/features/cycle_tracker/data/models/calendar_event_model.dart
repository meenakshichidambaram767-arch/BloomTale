import '../../domain/entities/calendar_event.dart';

class CalendarEventModel extends CalendarEvent {
 const CalendarEventModel({
 required super.id,
 required super.userId,
 super.externalId,
 required super.title,
 required super.startDate,
 required super.endDate,
 super.category = EventCategory.other,
 required super.source,
 required super.createdAt,
 });

 factory CalendarEventModel.fromJson(Map<String, dynamic> json) {
 return CalendarEventModel(
 id: json['id'] as String,
 userId: json['userId'] as String? ?? 'default_user',
 externalId: json['externalId'] as String?,
 title: json['title'] as String,
 startDate: DateTime.parse(json['startDate'] as String),
 endDate: DateTime.parse(json['endDate'] as String),
 category: EventCategory.values.firstWhere(
 (e) => e.name == json['category'],
 orElse: () => EventCategory.other,
 ),
 source: json['source'] as String? ?? 'in_app',
 createdAt: DateTime.parse(json['createdAt'] as String),
 );
 }

 Map<String, dynamic> toJson() {
 return {
 'id': id,
 'userId': userId,
 'externalId': externalId,
 'title': title,
 'startDate': startDate.toIso8601String(),
 'endDate': endDate.toIso8601String(),
 'category': category.name,
 'source': source,
 'createdAt': createdAt.toIso8601String(),
 };
 }

 factory CalendarEventModel.fromEntity(CalendarEvent entity) {
 return CalendarEventModel(
 id: entity.id,
 userId: entity.userId,
 externalId: entity.externalId,
 title: entity.title,
 startDate: entity.startDate,
 endDate: entity.endDate,
 category: entity.category,
 source: entity.source,
 createdAt: entity.createdAt,
 );
 }
}
