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
 return 'Menstrual phase ';
 case CyclePhase.follicular:
 return 'Follicular phase ';
 case CyclePhase.ovulation:
 return 'Ovulation phase ️';
 case CyclePhase.luteal:
 return 'Luteal phase ';
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
 final int cycleLength; // Average or actual length in days
 final int periodLength; // Duration of period in days
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
