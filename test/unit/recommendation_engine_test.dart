import 'package:flutter_test/flutter_test.dart';
import 'package:bloomtale/features/cycle_tracker/domain/entities/calendar_event.dart';
import 'package:bloomtale/features/cycle_tracker/domain/entities/daily_check_in.dart';
import 'package:bloomtale/features/cycle_tracker/domain/entities/period_log.dart';
import 'package:bloomtale/features/cycle_tracker/domain/entities/recommendation.dart';
import 'package:bloomtale/features/cycle_tracker/domain/usecases/get_recommendations.dart';

void main() {
  group('Recommendation Engine Unit Tests', () {
    final engine = GetRecommendations();

    test('should trigger Period Preparation recommendation when period window is near', () {
      final now = DateTime.now();
      // Period logged 25 days ago => estimated next period in ~3 days
      final logs = [
        PeriodLog(
          id: 'log_near',
          userId: 'user_1',
          startDate: now.subtract(const Duration(days: 25)),
          endDate: now.subtract(const Duration(days: 20)),
          flow: 'Medium',
          createdAt: now,
        ),
      ];

      final recs = engine.execute(
        periodLogs: logs,
        checkIns: [],
        upcomingEvents: [],
      );

      expect(recs.any((r) => r.category == RecommendationCategory.periodPreparation), isTrue);
      final prepRec = recs.firstWhere((r) => r.category == RecommendationCategory.periodPreparation);
      expect(prepRec.title, contains('preparation can help'));
      expect(prepRec.route, equals('/tracker/prep'));
    });

    test('should trigger Calendar Planning recommendation when upcoming event overlaps with estimated period', () {
      final now = DateTime.now();
      // Period logged 26 days ago => estimated period window in ~2 days (Days 27-31)
      final logs = [
        PeriodLog(
          id: 'log_prep',
          userId: 'user_1',
          startDate: now.subtract(const Duration(days: 26)),
          endDate: now.subtract(const Duration(days: 21)),
          flow: 'Medium',
          createdAt: now,
        ),
      ];

      final upcomingEvents = [
        CalendarEvent(
          id: 'evt_1',
          userId: 'user_1',
          title: '🏃 Sports Day',
          startDate: now.add(const Duration(days: 3)),
          endDate: now.add(const Duration(days: 3)),
          category: EventCategory.sports,
          source: 'in_app',
          createdAt: now,
        ),
      ];

      final recs = engine.execute(
        periodLogs: logs,
        checkIns: [],
        upcomingEvents: upcomingEvents,
      );

      expect(recs.any((r) => r.category == RecommendationCategory.calendarPlanning), isTrue);
      final calRec = recs.firstWhere((r) => r.category == RecommendationCategory.calendarPlanning);
      expect(calRec.description, contains('Sports Day'));
      expect(calRec.description, contains('take part'));
    });

    test('should trigger Education & Bloom AI recommendations when Cramps are logged', () {
      final now = DateTime.now();
      final checkIns = [
        DailyCheckIn(
          id: 'checkin_1',
          userId: 'user_1',
          date: now,
          mood: 'Okay',
          symptoms: ['Cramps'],
          createdAt: now,
        ),
      ];

      final recs = engine.execute(
        periodLogs: [],
        checkIns: checkIns,
        upcomingEvents: [],
      );

      expect(recs.any((r) => r.category == RecommendationCategory.education), isTrue);
      final eduRec = recs.firstWhere((r) => r.category == RecommendationCategory.education);
      expect(eduRec.title, contains('Cramps'));

      expect(recs.any((r) => r.category == RecommendationCategory.bloomAi), isTrue);
      final aiRec = recs.firstWhere((r) => r.category == RecommendationCategory.bloomAi);
      expect(aiRec.route, equals('/bloom-ai'));
    });

    test('should trigger Wellness recommendation when Fatigue/Tiredness is logged', () {
      final now = DateTime.now();
      final checkIns = [
        DailyCheckIn(
          id: 'checkin_tired',
          userId: 'user_1',
          date: now,
          mood: 'Tired',
          symptoms: ['Fatigue'],
          createdAt: now,
        ),
      ];

      final recs = engine.execute(
        periodLogs: [],
        checkIns: checkIns,
        upcomingEvents: [],
      );

      expect(recs.any((r) => r.category == RecommendationCategory.wellness), isTrue);
    });
  });
}
