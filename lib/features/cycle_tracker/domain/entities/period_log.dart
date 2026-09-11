import 'package:equatable/equatable.dart';

class PeriodLog extends Equatable {
 final String id;
 final String userId;
 final DateTime startDate;
 final DateTime? endDate;
 final String flow; // Light, Medium, Heavy, Spotting
 final String? notes;
 final DateTime createdAt;

 const PeriodLog({
 required this.id,
 required this.userId,
 required this.startDate,
 this.endDate,
 required this.flow,
 this.notes,
 required this.createdAt,
 });

 bool get isActive => endDate == null;

 @override
 List<Object?> get props => [id, userId, startDate, endDate, flow, notes, createdAt];
}
