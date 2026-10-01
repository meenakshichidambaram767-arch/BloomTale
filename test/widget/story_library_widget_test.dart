import 'package:bloomtale/app/providers.dart';
import 'package:bloomtale/screens/story_library_screen.dart';
import 'package:bloomtale/services/story_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget libraryApp() {
    final router = GoRouter(
      initialLocation: '/stories',
      routes: [
        GoRoute(
          path: '/stories',
          builder: (_, _) => const StoryLibraryScreen(),
        ),
        GoRoute(
          path: '/stories/:id',
          builder: (_, state) =>
              Scaffold(body: Text('Story ${state.pathParameters['id']}')),
        ),
        GoRoute(
          path: '/progress',
          builder: (_, _) => const Scaffold(body: Text('Progress')),
        ),
        GoRoute(
          path: '/bloom-ai',
          builder: (_, _) => const Scaffold(body: Text('Bloom AI')),
        ),
      ],
    );

    return ProviderScope(
      overrides: [storyServiceProvider.overrideWithValue(MockStoryService())],
      child: MaterialApp.router(routerConfig: router),
    );
  }

  Future<void> setViewport(WidgetTester tester, Size size) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(libraryApp());
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('library fits a small phone and exposes every shelf', (
    tester,
  ) async {
    await setViewport(tester, const Size(320, 640));

    expect(find.text('First Period'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Food & Energy'),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Food & Energy'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Period Products'),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Period Products'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('library actions navigate through existing routes', (
    tester,
  ) async {
    await setViewport(tester, const Size(430, 900));

    await tester.scrollUntilVisible(
      find.text('Ask Bloom'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Ask Bloom'));
    await tester.pumpAndSettle();

    expect(find.text('Bloom AI'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
