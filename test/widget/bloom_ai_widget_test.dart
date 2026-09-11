import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bloomtale/features/bloom_ai/presentation/screens/bloom_ai_home_screen.dart';
import 'package:bloomtale/features/bloom_ai/presentation/screens/bloom_prepare_screen.dart';
import 'package:bloomtale/features/bloom_ai/presentation/screens/bloom_tell_someone_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('BloomAiHomeScreen renders avatar, tiles, and suggested chips', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: BloomAiHomeScreen(),
        ),
      ),
    );

    await tester.pump();

    expect(find.text("Hi, I'm Bloom 🌸"), findsOneWidget);
    expect(find.text('💬 Ask Bloom'), findsOneWidget);
    expect(find.text('🧠 Learn'), findsOneWidget);
    expect(find.text('📅 Prepare'), findsOneWidget);
    expect(find.text('💗 Reflect'), findsOneWidget);
    expect(find.text('Why do I get cramps?'), findsOneWidget);
  });

  testWidgets('BloomPrepareScreen renders period prep packing checklist', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: BloomPrepareScreen(),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Period Prep Assistant 🎒'), findsOneWidget);
    expect(find.text('Upcoming Event: Sports Day'), findsOneWidget);
    expect(find.text('My Period Kit Checklist'), findsOneWidget);
  });

  testWidgets('BloomTellSomeoneScreen renders starter script generator options', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: BloomTellSomeoneScreen(),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('How Do I Tell Someone? 💗'), findsOneWidget);
    expect(find.text('1. Who would you like to talk to?'), findsOneWidget);
    expect(find.text('Parent / Guardian'), findsOneWidget);
  });
}
