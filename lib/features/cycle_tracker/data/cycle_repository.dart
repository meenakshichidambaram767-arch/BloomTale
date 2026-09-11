import '../domain/cycle_log.dart';

abstract class CycleRepository {
 Future<List<CycleLog>> getLogs();
 Future<void> saveLog(CycleLog log);
 Future<int> getCurrentCycleDay();
 Future<DateTime> getEstimatedNextPeriod();
}

class MockCycleRepository implements CycleRepository {
 final List<CycleLog> _logs = [
 CycleLog(
 id: 'log_1',
 date: DateTime.now().subtract(const Duration(days: 14)),
 flow: 'Medium',
 mood: 'Happy',
 symptoms: ['Cramps', 'Tiredness'],
 notes: 'Drank chamomile tea, felt better!',
 ),
 CycleLog(
 id: 'log_2',
 date: DateTime.now().subtract(const Duration(days: 13)),
 flow: 'Light',
 mood: 'Calm',
 symptoms: ['Mood Changes'],
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
 // Estimations are non-medical estimates based on standard 28-day cycle model
 if (_logs.isEmpty) {
 return DateTime.now().add(const Duration(days: 14));
 }
 final lastStart = _logs.first.date;
 return lastStart.add(const Duration(days: 28));
 }
}
