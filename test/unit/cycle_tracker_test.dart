import 'package:flutter_test/flutter_test.dart';
import 'package:bloomtale/features/cycle_tracker/data/cycle_repository.dart';
import 'package:bloomtale/features/cycle_tracker/domain/cycle_log.dart';

void main() {
  group('Cycle Tracker Unit Tests', () {
    final cycleRepo = MockCycleRepository();

    test('should calculate current cycle day and estimated next period date', () async {
      final currentDay = await cycleRepo.getCurrentCycleDay();
      expect(currentDay, greaterThanOrEqualTo(1));

      final estNext = await cycleRepo.getEstimatedNextPeriod();
      expect(estNext.isAfter(DateTime.now()), isTrue);
    });

    test('should save new cycle log entry successfully', () async {
      final newLog = CycleLog(
        id: 'test_log_1',
        date: DateTime.now(),
        flow: 'Light',
        mood: 'Calm',
        symptoms: ['Cramps'],
        notes: 'Test note',
      );

      await cycleRepo.saveLog(newLog);
      final logs = await cycleRepo.getLogs();
      expect(logs.any((l) => l.id == 'test_log_1'), isTrue);
    });
  });
}
