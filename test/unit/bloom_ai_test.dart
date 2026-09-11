import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bloomtale/features/bloom_ai/domain/bloom_ai_safety.dart';
import 'package:bloomtale/features/bloom_ai/domain/entities/bloom_enums.dart';
import 'package:bloomtale/features/bloom_ai/domain/entities/bloom_context.dart';
import 'package:bloomtale/features/bloom_ai/data/bloom_ai_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockBloomAiRepository repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = MockBloomAiRepository();
  });

  group('Bloom AI Safety Tests', () {
    test('checkSafetyCategory classifies safe educational questions', () {
      final category = BloomAiSafety.checkSafetyCategory('Why do I get period cramps?');
      expect(category, equals(SafetyCategory.safe));
    });

    test('checkSafetyCategory detects medical disclaimer triggers', () {
      final category = BloomAiSafety.checkSafetyCategory('I have severe pain and fever');
      expect(category, equals(SafetyCategory.medicalDisclaimer));
    });

    test('checkSafetyCategory detects crisis triggers and returns escalation response', () {
      final category = BloomAiSafety.checkSafetyCategory('I feel like dying');
      expect(category, equals(SafetyCategory.crisis));

      final response = BloomAiSafety.getCrisisEscalationResponse();
      expect(response, contains('trusted adult'));
      expect(response, contains('emergency services'));
    });
  });

  group('Bloom AI Context Engine & Repository Tests', () {
    test('sendMessage handles contextual period cramp questions', () async {
      const context = BloomContext(
        source: 'tracker',
        symptomContext: 'cramps',
        preferredExplanationLevel: ExplanationLevel.simple,
      );

      final reply = await repository.sendMessage('Why do I get cramps?', context: context);

      expect(reply.isUser, isFalse);
      expect(reply.text, contains('uterus muscles contract'));
      expect(reply.expression, equals(BloomExpression.reassuring));
      expect(reply.suggestedFollowUps, isNotEmpty);
      expect(reply.relatedStoryId, equals('first_period'));
    });

    test('getTopics returns 6 structured educational topics', () async {
      final topics = await repository.getTopics();
      expect(topics.length, equals(6));
      expect(topics.first.title, contains('Puberty'));
    });

    test('Period prep checklist items can be retrieved', () async {
      final items = await repository.getPrepItems();
      expect(items, isNotEmpty);
      expect(items.any((item) => item.title.contains('Period products')), isTrue);
    });

    test('Journal entry creation generates gentle feedback', () async {
      final entry = await repository.saveJournalEntry('Worried', 'I have a test tomorrow');
      expect(entry.mood, equals('Worried'));
      expect(entry.bloomFeedback, contains('completely okay to feel worried'));
    });

    test('generateTellSomeoneStarter builds starter script', () async {
      final script = await repository.generateTellSomeoneStarter('Mom', 'periods', style: 'standard');
      expect(script, contains('Mom'));
      expect(script, contains('period'));
    });
  });
}
