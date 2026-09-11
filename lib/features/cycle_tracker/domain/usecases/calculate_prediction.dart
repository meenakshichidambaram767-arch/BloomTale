import 'package:flutter/material.dart';
import '../entities/cycle.dart';
import '../entities/period_log.dart';
import '../repositories/cycle_repository.dart';

class CyclePrediction {
 final int currentCycleDay;
 final int averageCycleLength;
 final int averagePeriodLength;
 final DateTimeRange estimatedNextPeriodWindow;
 final CyclePhase currentPhase;
 final bool hasSufficientData;
 final String predictionMessage;

 const CyclePrediction({
 required this.currentCycleDay,
 required this.averageCycleLength,
 required this.averagePeriodLength,
 required this.estimatedNextPeriodWindow,
 required this.currentPhase,
 required this.hasSufficientData,
 required this.predictionMessage,
 });
}

class CalculatePrediction {
 CyclePrediction execute(List<PeriodLog> logs) {
 if (logs.isEmpty) {
 final now = DateTime.now();
 final estStart = now.add(const Duration(days: 14));
 return CyclePrediction(
 currentCycleDay: 14,
 averageCycleLength: 28,
 averagePeriodLength: 5,
 estimatedNextPeriodWindow: DateTimeRange(
 start: estStart.subtract(const Duration(days: 1)),
 end: estStart.add(const Duration(days: 2)),
 ),
 currentPhase: CyclePhase.follicular,
 hasSufficientData: false,
 predictionMessage: "We're still learning your pattern. Keep logging your periods for more custom estimates!",
 );
 }

 // Sort logs descending by start date
 final sortedLogs = List<PeriodLog>.from(logs)
 ..sort((a, b) => b.startDate.compareTo(a.startDate));

 final latestLog = sortedLogs.first;

 // Calculate average period duration
 int totalPeriodDays = 0;
 int periodCount = 0;
 for (final log in sortedLogs) {
 if (log.endDate != null) {
 final days = log.endDate!.difference(log.startDate).inDays + 1;
 if (days > 0 && days <= 10) {
 totalPeriodDays += days;
 periodCount++;
 }
 }
 }
 final avgPeriodLength = periodCount > 0 ? (totalPeriodDays / periodCount).round() : 5;

 // Calculate average cycle length
 int avgCycleLength = 28;
 bool sufficientData = false;

 if (sortedLogs.length >= 2) {
 int totalCycleDays = 0;
 int cycleCount = 0;
 for (int i = 0; i < sortedLogs.length - 1; i++) {
 final diff = sortedLogs[i].startDate.difference(sortedLogs[i + 1].startDate).inDays;
 if (diff >= 18 && diff <= 45) {
 totalCycleDays += diff;
 cycleCount++;
 }
 }
 if (cycleCount > 0) {
 avgCycleLength = (totalCycleDays / cycleCount).round();
 sufficientData = true;
 }
 }

 final now = DateTime.now();
 final today = DateTime(now.year, now.month, now.day);
 final lastStart = DateTime(latestLog.startDate.year, latestLog.startDate.month, latestLog.startDate.day);

 final rawCycleDay = today.difference(lastStart).inDays + 1;
 final currentCycleDay = rawCycleDay < 1 ? 1 : rawCycleDay;

 // Estimated next period start date
 final nextPeriodStart = lastStart.add(Duration(days: avgCycleLength));
 final windowStart = nextPeriodStart.subtract(const Duration(days: 1));
 final windowEnd = nextPeriodStart.add(Duration(days: avgPeriodLength - 1));

 final window = DateTimeRange(start: windowStart, end: windowEnd);

 // Calculate phase based on current cycle day & avg length
 CyclePhase phase;
 if (currentCycleDay <= avgPeriodLength) {
 phase = CyclePhase.menstrual;
 } else if (currentCycleDay < (avgCycleLength / 2 - 1).round()) {
 phase = CyclePhase.follicular;
 } else if (currentCycleDay <= (avgCycleLength / 2 + 2).round()) {
 phase = CyclePhase.ovulation;
 } else {
 phase = CyclePhase.luteal;
 }

 String message;
 if (sufficientData) {
 message = "Based on your recent cycle history, your next period is estimated around this window.";
 } else {
 message = "Estimated next window. As you log more cycles, estimates adjust to your unique rhythm.";
 }

 return CyclePrediction(
 currentCycleDay: currentCycleDay,
 averageCycleLength: avgCycleLength,
 averagePeriodLength: avgPeriodLength,
 estimatedNextPeriodWindow: window,
 currentPhase: phase,
 hasSufficientData: sufficientData,
 predictionMessage: message,
 );
 }
}
