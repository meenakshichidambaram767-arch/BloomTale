import 'package:flutter/material.dart';
import '../entities/cycle.dart';
import '../entities/period_log.dart';
import '../entities/daily_check_in.dart';
import '../entities/calendar_event.dart';
import '../entities/recommendation.dart';
import '../entities/cycle_insight.dart';

abstract class CycleRepository {
 Future<List<PeriodLog>> getPeriodLogs();
 Future<void> savePeriodLog(PeriodLog log);
 Future<void> deletePeriodLog(String id);

 Future<List<DailyCheckIn>> getDailyCheckIns();
 Future<DailyCheckIn?> getTodayCheckIn();
 Future<void> saveDailyCheckIn(DailyCheckIn checkIn);

 Future<List<CalendarEvent>> getCalendarEvents();
 Future<void> saveCalendarEvent(CalendarEvent event);

 Future<int> getCurrentCycleDay();
 Future<DateTimeRange?> getEstimatedNextPeriodWindow();
 Future<CyclePhase> getCurrentPhase();
 Future<List<CycleInsight>> getInsights();
 Future<List<Recommendation>> getRecommendations();
}
