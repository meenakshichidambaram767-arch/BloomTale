import 'package:equatable/equatable.dart';

enum CyclePhase {
  menstrual,
  follicular,
  ovulation,
  luteal,
}

extension CyclePhaseExtension on CyclePhase {
  String get displayName {
    switch (this) {
      case CyclePhase.menstrual:
        return 'Menstrual phase';
      case CyclePhase.follicular:
        return 'Follicular phase';
      case CyclePhase.ovulation:
        return 'Ovulation phase';
      case CyclePhase.luteal:
        return 'Luteal phase';
    }
  }

  String get supportiveDescription {
    switch (this) {
      case CyclePhase.menstrual:
        return 'Your body is resting and renewing. Extra cozy self-care is great today.';
      case CyclePhase.follicular:
        return 'Some girls notice feeling fresh and energized during this phase. Everyone\'s body is unique!';
      case CyclePhase.ovulation:
        return 'Mid-cycle phase. You might feel social, active, or balanced.';
      case CyclePhase.luteal:
        return 'Approaching your next cycle. Gentle activities and listening to your body can feel helpful.';
    }
  }
}

class Cycle extends Equatable {
  final String id;
  final String userId;
  final DateTime startDate;
  final DateTime? endDate;
  final int cycleLength;
  final int periodLength;
  final CyclePhase currentPhase;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Cycle({
    required this.id,
    required this.userId,
    required this.startDate,
    this.endDate,
    required this.cycleLength,
    required this.periodLength,
    required this.currentPhase,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        startDate,
        endDate,
        cycleLength,
        periodLength,
        currentPhase,
        createdAt,
        updatedAt,
      ];
}

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

class PeriodLog extends Equatable {
  final String id;
  final String userId;
  final DateTime startDate;
  final DateTime? endDate;
  final String flow;
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
  final String source;
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
  final String? route;
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

class MoodEntry extends Equatable {
  final String id;
  final String userId;
  final DateTime date;
  final String mood;
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

class SymptomEntry extends Equatable {
  final String id;
  final String userId;
  final DateTime date;
  final List<String> symptoms;
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

class CycleInsight extends Equatable {
  final String id;
  final String title;
  final String description;
  final String type;
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

class CycleLog {
  final String id;
  final DateTime date;
  final String flow;
  final String mood;
  final List<String> symptoms;
  final String notes;

  const CycleLog({
    required this.id,
    required this.date,
    required this.flow,
    required this.mood,
    required this.symptoms,
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'flow': flow,
      'mood': mood,
      'symptoms': symptoms,
      'notes': notes,
    };
  }

  factory CycleLog.fromJson(Map<String, dynamic> json) {
    return CycleLog(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      flow: json['flow'] as String,
      mood: json['mood'] as String,
      symptoms: List<String>.from(json['symptoms'] as List),
      notes: (json['notes'] as String?) ?? '',
    );
  }
}
