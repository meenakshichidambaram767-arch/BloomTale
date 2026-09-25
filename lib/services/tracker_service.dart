import 'package:flutter/material.dart';
import '../models/cycle.dart';

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

    final sortedLogs = List<PeriodLog>.from(logs)
      ..sort((a, b) => b.startDate.compareTo(a.startDate));

    final latestLog = sortedLogs.first;

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

    final nextPeriodStart = lastStart.add(Duration(days: avgCycleLength));
    final windowStart = nextPeriodStart.subtract(const Duration(days: 1));
    final windowEnd = nextPeriodStart.add(Duration(days: avgPeriodLength - 1));

    final window = DateTimeRange(start: windowStart, end: windowEnd);

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

class GetRecommendations {
  List<Recommendation> execute({
    required List<PeriodLog> periodLogs,
    required List<DailyCheckIn> checkIns,
    required List<CalendarEvent> upcomingEvents,
  }) {
    final List<Recommendation> recommendations = [];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final prediction = CalculatePrediction().execute(periodLogs);
    final estWindow = prediction.estimatedNextPeriodWindow;

    final daysUntilPeriod = estWindow.start.difference(today).inDays;

    if (daysUntilPeriod >= 0 && daysUntilPeriod <= 5) {
      recommendations.add(
        Recommendation(
          id: 'rec_prep_window',
          title: 'A little preparation can help',
          description: 'Your estimated period window is approaching in about $daysUntilPeriod day${daysUntilPeriod == 1 ? '' : 's'}. Keeping a small kit in your bag helps you feel ready.',
          category: RecommendationCategory.periodPreparation,
          actionButtonText: 'Prepare My Kit',
          route: '/tracker/prep',
          createdAt: now,
        ),
      );
    }

    for (final event in upcomingEvents) {
      final isOverlapping = (event.startDate.isBefore(estWindow.end.add(const Duration(days: 1))) &&
          event.endDate.isAfter(estWindow.start.subtract(const Duration(days: 1))));

      if (isOverlapping) {
        String categoryName = event.title;
        recommendations.add(
          Recommendation(
            id: 'rec_event_${event.id}',
            title: 'Upcoming: $categoryName',
            description: 'Your estimated period window overlaps with $categoryName on ${event.startDate.month}/${event.startDate.day}. You can still fully take part! Preparing beforehand keeps you comfortable.',
            category: RecommendationCategory.calendarPlanning,
            actionButtonText: 'View Prep Checklist',
            route: '/tracker/prep',
            createdAt: now,
          ),
        );
        break;
      }
    }

    final recentCheckIns = checkIns.take(3).toList();
    final recentSymptoms = recentCheckIns.expand((c) => c.symptoms).toSet();

    if (recentSymptoms.contains('Cramps')) {
      recommendations.add(
        Recommendation(
          id: 'rec_edu_cramps',
          title: 'Understanding Period Cramps',
          description: 'Cramps happen when your body naturally contracts during your cycle. Want to learn gentle ways to soothe them?',
          category: RecommendationCategory.education,
          actionButtonText: 'Learn More',
          route: '/stories/bursting_myths',
          createdAt: now,
        ),
      );
    } else if (recentSymptoms.contains('Acne') || recentSymptoms.contains('Bloating')) {
      recommendations.add(
        Recommendation(
          id: 'rec_edu_skin_body',
          title: 'Why bodies change during puberty',
          description: 'Skin changes and mild bloating are normal shifts as hormones fluctuate in growing bodies.',
          category: RecommendationCategory.education,
          actionButtonText: 'Read Story',
          route: '/stories/bursting_myths',
          createdAt: now,
        ),
      );
    }

    final recentMoods = recentCheckIns.map((c) => c.mood).toList();
    if (recentMoods.contains('Tired') || recentMoods.contains('Anxious')) {
      recommendations.add(
        Recommendation(
          id: 'rec_wellness_rest',
          title: 'Gentle Care for Low Energy',
          description: 'You\'ve logged feeling tired or anxious recently. Warm tea, light stretching, and early sleep can feel wonderful.',
          category: RecommendationCategory.wellness,
          actionButtonText: 'Check-in Insights',
          route: '/tracker/insights',
          createdAt: now,
        ),
      );
    }

    if (recentSymptoms.isNotEmpty || recentMoods.isNotEmpty) {
      recommendations.add(
        Recommendation(
          id: 'rec_ask_bloom',
          title: 'Curious about how you\'re feeling?',
          description: 'Ask Bloom AI any question about your cycle, moods, or prep in a safe, non-judgmental space.',
          category: RecommendationCategory.bloomAi,
          actionButtonText: 'Ask Bloom',
          route: '/bloom-ai',
          createdAt: now,
        ),
      );
    }

    if (recommendations.isEmpty) {
      recommendations.add(
        Recommendation(
          id: 'rec_default_welcome',
          title: 'Welcome to your Bloom Tracker',
          description: 'Check in daily with how you feel or log your periods to build personalized predictions and prep tips.',
          category: RecommendationCategory.wellness,
          actionButtonText: 'Daily Check-in',
          route: '/tracker',
          createdAt: now,
        ),
      );
    }

    return recommendations;
  }
}

abstract class TrackerService {
  Future<List<CycleLog>> getLogs();
  Future<void> saveLog(CycleLog log);
  Future<int> getCurrentCycleDay();
  Future<DateTime> getEstimatedNextPeriod();
  Future<void> saveDailyCheckIn(DailyCheckIn checkIn);
}

class MockTrackerService implements TrackerService {
  final List<CycleLog> _logs = [
    CycleLog(
      id: 'log_1',
      date: DateTime.now().subtract(const Duration(days: 14)),
      flow: 'Medium',
      mood: 'Happy',
      symptoms: const ['Cramps', 'Tiredness'],
      notes: 'Drank chamomile tea, felt better!',
    ),
    CycleLog(
      id: 'log_2',
      date: DateTime.now().subtract(const Duration(days: 13)),
      flow: 'Light',
      mood: 'Calm',
      symptoms: const ['Mood Changes'],
      notes: 'Light day.',
    ),
  ];

  @override
  Future<List<CycleLog>> getLogs() async {
    return List.from(_logs);
  }

  @override
  Future<void> saveLog(CycleLog log) async {
    _logs.removeWhere((l) =>
        l.date.year == log.date.year &&
        l.date.month == log.date.month &&
        l.date.day == log.date.day);
    _logs.add(log);
    _logs.sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<int> getCurrentCycleDay() async {
    if (_logs.isEmpty) return 14;
    final lastLogDate = _logs.first.date;
    final diff = DateTime.now().difference(lastLogDate).inDays;
    return (diff + 1).clamp(1, 45);
  }

  @override
  Future<DateTime> getEstimatedNextPeriod() async {
    if (_logs.isEmpty) {
      return DateTime.now().add(const Duration(days: 14));
    }
    final lastStart = _logs.first.date;
    return lastStart.add(const Duration(days: 28));
  }

  @override
  Future<void> saveDailyCheckIn(DailyCheckIn checkIn) async {
    final log = CycleLog(
      id: checkIn.id,
      date: checkIn.date,
      flow: 'Medium',
      mood: checkIn.mood,
      symptoms: checkIn.symptoms,
      notes: checkIn.notes ?? '',
    );
    await saveLog(log);
  }
}
