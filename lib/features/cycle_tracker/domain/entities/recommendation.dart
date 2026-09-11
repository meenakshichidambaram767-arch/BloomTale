import 'package:equatable/equatable.dart';

enum RecommendationCategory {
 periodPreparation,
 calendarPlanning,
 wellness,
 education,
 bloomAi,
 reminder,
}

class Recommendation extends Equatable {
 final String id;
 final String title;
 final String description;
 final RecommendationCategory category;
 final String? actionButtonText;
 final String? route; // e.g. '/prep', '/stories/cramps', '/bloom-ai'
 final Map<String, dynamic>? metadata;
 final DateTime createdAt;

 const Recommendation({
 required this.id,
 required this.title,
 required this.description,
 required this.category,
 this.actionButtonText,
 this.route,
 this.metadata,
 required this.createdAt,
 });

 @override
 List<Object?> get props => [
 id,
 title,
 description,
 category,
 actionButtonText,
 route,
 metadata,
 createdAt,
 ];
}
