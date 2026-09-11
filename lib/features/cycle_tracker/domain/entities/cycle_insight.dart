import 'package:equatable/equatable.dart';

class CycleInsight extends Equatable {
 final String id;
 final String title;
 final String description;
 final String type; // 'pattern', 'summary', 'education'
 final Map<String, dynamic>? dataPoints;
 final DateTime createdAt;

 const CycleInsight({
 required this.id,
 required this.title,
 required this.description,
 required this.type,
 this.dataPoints,
 required this.createdAt,
 });

 @override
 List<Object?> get props => [id, title, description, type, dataPoints, createdAt];
}
