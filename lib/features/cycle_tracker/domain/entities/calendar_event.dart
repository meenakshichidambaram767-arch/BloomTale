import 'package:equatable/equatable.dart';

enum EventCategory {
 exam,
 sports,
 travel,
 competition,
 school,
 family,
 vacation,
 other,
}

class CalendarEvent extends Equatable {
 final String id;
 final String userId;
 final String? externalId;
 final String title;
 final DateTime startDate;
 final DateTime endDate;
 final EventCategory category;
 final String source; // 'device' or 'in_app'
 final DateTime createdAt;

 const CalendarEvent({
 required this.id,
 required this.userId,
 this.externalId,
 required this.title,
 required this.startDate,
 required this.endDate,
 this.category = EventCategory.other,
 required this.source,
 required this.createdAt,
 });

 @override
 List<Object?> get props => [
 id,
 userId,
 externalId,
 title,
 startDate,
 endDate,
 category,
 source,
 createdAt,
 ];
}
