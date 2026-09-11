import 'package:flutter/material.dart';
import '../../domain/entities/calendar_event.dart';
import '../../domain/entities/cycle.dart';
import '../../domain/entities/cycle_insight.dart';
import '../../domain/entities/daily_check_in.dart';
import '../../domain/entities/period_log.dart';
import '../../domain/entities/recommendation.dart';
import '../../domain/repositories/cycle_repository.dart';
import '../../domain/usecases/calculate_prediction.dart';
import '../../domain/usecases/get_recommendations.dart';
import '../datasources/calendar_datasource.dart';
import '../datasources/cycle_local_datasource.dart';
import '../models/calendar_event_model.dart';
import '../models/daily_check_in_model.dart';
import '../models/period_log_model.dart';

class CycleRepositoryImpl implements CycleRepository {
 final CycleLocalDataSource localDataSource;
 final CalendarDataSource calendarDataSource;
 final CalculatePrediction calculatePrediction;
 final GetRecommendations getRecommendationsEngine;

 CycleRepositoryImpl({
 required this.localDataSource,
 required this.calendarDataSource,
 CalculatePrediction? calculatePrediction,
 GetRecommendations? getRecommendationsEngine,
 }) : calculatePrediction = calculatePrediction ?? CalculatePrediction(),
 getRecommendationsEngine = getRecommendationsEngine ?? GetRecommendations();

 @override
 Future<List<PeriodLog>> getPeriodLogs() async {
 return await localDataSource.getPeriodLogs();
 }

 @override
 Future<void> savePeriodLog(PeriodLog log) async {
 await localDataSource.savePeriodLog(PeriodLogModel.fromEntity(log));
 }

 @override
 Future<void> deletePeriodLog(String id) async {
 await localDataSource.deletePeriodLog(id);
 }

 @override
 Future<List<DailyCheckIn>> getDailyCheckIns() async {
 return await localDataSource.getDailyCheckIns();
 }

 @override
 Future<DailyCheckIn?> getTodayCheckIn() async {
 final checkIns = await localDataSource.getDailyCheckIns();
 final now = DateTime.now();
 for (final c in checkIns) {
 if (c.date.year == now.year && c.date.month == now.month && c.date.day == now.day) {
 return c;
 }
 }
 return null;
 }

 @override
 Future<void> saveDailyCheckIn(DailyCheckIn checkIn) async {
 await localDataSource.saveDailyCheckIn(DailyCheckInModel.fromEntity(checkIn));
 }

 @override
 Future<List<CalendarEvent>> getCalendarEvents() async {
 final localEvents = await localDataSource.getCalendarEvents();
 final deviceEvents = await calendarDataSource.getDeviceCalendarEvents();
 final allEvents = [...localEvents, ...deviceEvents];
 allEvents.sort((a, b) => a.startDate.compareTo(b.startDate));
 return allEvents;
 }

 @override
 Future<void> saveCalendarEvent(CalendarEvent event) async {
 await localDataSource.saveCalendarEvent(CalendarEventModel.fromEntity(event));
 }

 @override
 Future<int> getCurrentCycleDay() async {
 final logs = await getPeriodLogs();
 final prediction = calculatePrediction.execute(logs);
 return prediction.currentCycleDay;
 }

 @override
 Future<DateTimeRange?> getEstimatedNextPeriodWindow() async {
 final logs = await getPeriodLogs();
 final prediction = calculatePrediction.execute(logs);
 return prediction.estimatedNextPeriodWindow;
 }

 @override
 Future<CyclePhase> getCurrentPhase() async {
 final logs = await getPeriodLogs();
 final prediction = calculatePrediction.execute(logs);
 return prediction.currentPhase;
 }

 @override
 Future<List<Recommendation>> getRecommendations() async {
 final logs = await getPeriodLogs();
 final checkIns = await getDailyCheckIns();
 final events = await getCalendarEvents();
 return getRecommendationsEngine.execute(
 periodLogs: logs,
 checkIns: checkIns,
 upcomingEvents: events,
 );
 }

 @override
 Future<List<CycleInsight>> getInsights() async {
 final logs = await getPeriodLogs();
 final checkIns = await getDailyCheckIns();
 final prediction = calculatePrediction.execute(logs);

 final List<CycleInsight> insights = [];

 insights.add(
 CycleInsight(
 id: 'ins_cycle_length',
 title: 'Average Cycle Length',
 description: 'Your estimated cycle length is about ${prediction.averageCycleLength} days.',
 type: 'summary',
 createdAt: DateTime.now(),
 ),
 );

 if (checkIns.isNotEmpty) {
 final crampsCount = checkIns.where((c) => c.symptoms.contains('Cramps')).length;
 if (crampsCount > 0) {
 insights.add(
 CycleInsight(
 id: 'ins_symptoms_cramps',
 title: 'Symptom Notice',
 description: 'You\'ve logged cramps $crampsCount time${crampsCount > 1 ? 's' : ''} recently.',
 type: 'pattern',
 createdAt: DateTime.now(),
 ),
 );
 }
 }

 return insights;
 }
}
