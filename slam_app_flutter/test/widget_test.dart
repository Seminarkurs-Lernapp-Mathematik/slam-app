import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:slam_app_flutter/app/app.dart';

void main() {
  setUpAll(() async {
    // Initialize Hive for tests
    await Hive.initFlutter();
  });

  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: SLAMApp(),
      ),
    );

    // Let the app initialize
    await tester.pumpAndSettle();

    // Verify that the app is loaded (should show login screen initially)
    expect(find.text('Login Screen - Coming Soon'), findsOneWidget);
  });
}
