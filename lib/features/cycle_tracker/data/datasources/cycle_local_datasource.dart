import '../models/period_log_model.dart';
import '../models/daily_check_in_model.dart';
import '../models/calendar_event_model.dart';
import '../../domain/entities/calendar_event.dart';

class CycleLocalDataSource {
 final List<PeriodLogModel> _periodLogs = [
 PeriodLogModel(
 id: 'log_seed_1',
 userId: 'default_user',
 startDate: DateTime.now().subtract(const Duration(days: 14)),
 endDate: DateTime.now().subtract(const Duration(days: 9)),
 flow: 'Medium',
 notes: 'Logged initial cycle entry',
 createdAt: DateTime.now().subtract(const Duration(days: 14)),
 ),
 PeriodLogModel(
 id: 'log_seed_2',
 userId: 'default_user',
 startDate: DateTime.now().subtract(const Duration(days: 42)),
 endDate: DateTime.now().subtract(const Duration(days: 37)),
 flow: 'Medium',
 notes: 'Previous month cycle',
 createdAt: DateTime.now().subtract(const Duration(days: 42)),
 ),
 ];

 final List<DailyCheckInModel> _dailyCheckIns = [
 DailyCheckInModel(
 id: 'checkin_seed_1',
 userId: 'default_user',
 date: DateTime.now(),
 mood: 'Calm',
 symptoms: ['Cramps'],
 notes: 'Felt a bit tired in the morning',
 createdAt: DateTime.now(),
 ),
 ];

 final List<CalendarEventModel> _calendarEvents = [
 CalendarEventModel(
 id: 'event_seed_1',
 userId: 'default_user',
 title: ' Math Midterm Exam',
 startDate: DateTime.now().add(const Duration(days: 9)),
 endDate: DateTime.now().add(const Duration(days: 9)),
 category: EventCategory.exam,
 source: 'in_app',
 createdAt: DateTime.now(),
 ),
 CalendarEventModel(
 id: 'event_seed_2',
 userId: 'default_user',
 title: ' School Sports Day',
 startDate: DateTime.now().add(const Duration(days: 13)),
 endDate: DateTime.now().add(const Duration(days: 13)),
 category: EventCategory.sports,
 source: 'in_app',
 createdAt: DateTime.now(),
 ),
 ];

 Future<List<PeriodLogModel>> getPeriodLogs() async {
 return List.unmodifiable(_periodLogs);
 }

 Future<void> savePeriodLog(PeriodLogModel log) async {
 _periodLogs.removeWhere((l) => l.id == log.id);
 _periodLogs.add(log);
 _periodLogs.sort((a, b) => b.startDate.compareTo(a.startDate));
 }

 Future<void> deletePeriodLog(String id) async {
 _periodLogs.removeWhere((l) => l.id == id);
 }

 Future<List<DailyCheckInModel>> getDailyCheckIns() async {
 return List.unmodifiable(_dailyCheckIns);
 }

 Future<void> saveDailyCheckIn(DailyCheckInModel checkIn) async {
 _dailyCheckIns.removeWhere((c) => c.id == checkIn.id);
 _dailyCheckIns.add(checkIn);
 _dailyCheckIns.sort((a, b) => b.date.compareTo(a.date));
 }

 Future<List<CalendarEventModel>> getCalendarEvents() async {
 return List.unmodifiable(_calendarEvents);
 }

 Future<void> saveCalendarEvent(CalendarEventModel event) async {
 _calendarEvents.removeWhere((e) => e.id == event.id);
 _calendarEvents.add(event);
 _calendarEvents.sort((a, b) => a.startDate.compareTo(b.startDate));
 }
}
