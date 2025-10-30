import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_hello_world/features/cricket/presentation/screens/matches_screen.dart';

void main() {
  setUp(() {
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      child: MaterialApp(
        home: MatchesScreen(),
      ),
    );
  }

  group('MatchesScreen Widget Tests', () {
    testWidgets('should display app bar with correct title', (WidgetTester tester) async {
      // act
      await tester.pumpWidget(createWidgetUnderTest());

      // assert
      expect(find.text('Matches'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should display matches screen', (WidgetTester tester) async {
      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // assert
      expect(find.byType(MatchesScreen), findsOneWidget);
    });
  });
}