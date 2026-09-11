import 'package:flutter_test/flutter_test.dart';
import 'package:bloomtale/features/cycle_tracker/domain/entities/cycle.dart';
import 'package:bloomtale/features/cycle_tracker/domain/entities/period_log.dart';
import 'package:bloomtale/features/cycle_tracker/domain/usecases/calculate_prediction.dart';

void main() {
  group('Cycle Calculation Engine Tests', () {
    final calculator = CalculatePrediction();

    test('should provide safe default prediction when no logs exist', () {
      final prediction = calculator.execute([]);

      expect(prediction.currentCycleDay, equals(14));
      expect(prediction.averageCycleLength, equals(28));
      expect(prediction.averagePeriodLength, equals(5));
      expect(prediction.currentPhase, equals(CyclePhase.follicular));
      expect(prediction.hasSufficientData, isFalse);
      expect(prediction.predictionMessage, contains("learning your pattern"));
    });

    test('should calculate current cycle day and next period window from single log', () {
      final now = DateTime.now();
      final logs = [
        PeriodLog(
          id: 'log_1',
          userId: 'user_1',
          startDate: now.subtract(const Duration(days: 10)),
          endDate: now.subtract(const Duration(days: 5)),
          flow: 'Medium',
          createdAt: now,
        ),
      ];

      final prediction = calculator.execute(logs);

      expect(prediction.currentCycleDay, equals(11));
      expect(prediction.averageCycleLength, equals(28));
      expect(prediction.averagePeriodLength, equals(6));
      expect(prediction.currentPhase, equals(CyclePhase.follicular));
      expect(prediction.hasSufficientData, isFalse);
    });

    test('should calculate accurate average cycle length across multiple historical logs', () {
      final now = DateTime.now();
      final logs = [
        PeriodLog(
          id: 'log_recent',
          userId: 'user_1',
          startDate: now.subtract(const Duration(days: 5)),
          endDate: now.subtract(const Duration(days: 2)),
          flow: 'Medium',
          createdAt: now,
        ),
        PeriodLog(
          id: 'log_prev_1',
          userId: 'user_1',
          startDate: now.subtract(const Duration(days: 33)), // 28-day gap
          endDate: now.subtract(const Duration(days: 30)),
          flow: 'Medium',
          createdAt: now,
        ),
        PeriodLog(
          id: 'log_prev_2',
          userId: 'user_1',
          startDate: now.subtract(const Duration(days: 61)), // 28-day gap
          endDate: now.subtract(const Duration(days: 58)),
          flow: 'Heavy',
          createdAt: now,
        ),
      ];

      final prediction = calculator.execute(logs);

      expect(prediction.currentCycleDay, equals(6));
      expect(prediction.averageCycleLength, equals(28));
      expect(prediction.hasSufficientData, isTrue);
      expect(prediction.currentPhase, equals(CyclePhase.follicular));
    });

    test('should determine Menstrual phase during period days', () {
      final now = DateTime.now();
      final logs = [
        PeriodLog(
          id: 'log_active',
          userId: 'user_1',
          startDate: now.subtract(const Duration(days: 1)),
          flow: 'Medium',
          createdAt: now,
        ),
      ];

      final prediction = calculator.execute(logs);

      expect(prediction.currentCycleDay, equals(2));
      expect(prediction.currentPhase, equals(CyclePhase.menstrual));
    });
  });
}
