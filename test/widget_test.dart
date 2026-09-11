import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bloomtale/app/app.dart';

void main() {
  testWidgets('App renders splash screen and navigates cleanly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: BloomTaleApp(),
      ),
    );

    expect(find.text('BloomTale 🌸'), findsOneWidget);

    // Advance timer so SplashScreen delayed navigation completes
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });
}
