import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_hello_world/features/cricket/presentation/screens/create_match_screen.dart';

void main() {
  setUp(() {
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      child: MaterialApp(
        home: CreateMatchScreen(),
      ),
    );
  }

  group('CreateMatchScreen Widget Tests', () {
    testWidgets('should display create match screen', (WidgetTester tester) async {
      // act
      await tester.pumpWidget(createWidgetUnderTest());

      // assert
      expect(find.byType(CreateMatchScreen), findsOneWidget);
    });
  });
}