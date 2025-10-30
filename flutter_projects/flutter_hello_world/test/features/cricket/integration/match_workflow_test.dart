import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_hello_world/main.dart' as app;
import 'package:flutter_hello_world/features/cricket/presentation/screens/matches_screen.dart';
import 'package:flutter_hello_world/features/cricket/presentation/screens/create_match_screen.dart';
import 'package:flutter_hello_world/features/cricket/presentation/screens/match_details_screen.dart';
import 'package:flutter_hello_world/core/widgets/app_button.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Cricket Match Workflow Integration Tests', () {
    testWidgets('Complete match creation and viewing workflow', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Navigate to matches screen (assuming it's accessible from home)
      await tester.tap(find.text('Matches'));
      await tester.pumpAndSettle();

      // Verify we're on the matches screen
      expect(find.byType(MatchesScreen), findsOneWidget);

      // Tap the floating action button to create a new match
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify we're on the create match screen
      expect(find.byType(CreateMatchScreen), findsOneWidget);
      expect(find.text('Create Match'), findsOneWidget);

      // Fill in the match creation form
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Match Title'),
        'Integration Test Match',
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Description'),
        'This is an integration test match',
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Venue'),
        'Test Cricket Ground',
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Overs'),
        '20',
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Players per Team'),
        '11',
      );
      await tester.pumpAndSettle();

      // Select teams (assuming there are team selection dropdowns)
      // This would depend on the actual implementation
      
      // Submit the form
      await tester.tap(find.byType(AppButton));
      await tester.pumpAndSettle();

      // Verify we're back on the matches screen and the new match is visible
      expect(find.byType(MatchesScreen), findsOneWidget);
      expect(find.text('Integration Test Match'), findsOneWidget);

      // Tap on the newly created match to view details
      await tester.tap(find.text('Integration Test Match'));
      await tester.pumpAndSettle();

      // Verify we're on the match details screen
      expect(find.byType(MatchDetailsScreen), findsOneWidget);
      expect(find.text('Integration Test Match'), findsOneWidget);
      expect(find.text('Test Cricket Ground'), findsOneWidget);

      // Test starting the match (if start button is available)
      final startButton = find.text('Start Match');
      if (tester.any(startButton)) {
        await tester.tap(startButton);
        await tester.pumpAndSettle();

        // Verify match status changed
        expect(find.text('In Progress'), findsOneWidget);
      }

      // Navigate back to matches screen
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify we're back on matches screen
      expect(find.byType(MatchesScreen), findsOneWidget);
    });

    testWidgets('Match creation validation workflow', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Navigate to create match screen
      await tester.tap(find.text('Matches'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Try to submit empty form
      await tester.tap(find.byType(AppButton));
      await tester.pumpAndSettle();

      // Verify validation errors are shown
      expect(find.text('Match title is required'), findsOneWidget);
      expect(find.text('Venue is required'), findsOneWidget);
      expect(find.text('Overs is required'), findsOneWidget);

      // Fill in invalid data
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Overs'),
        '0',
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Players per Team'),
        '15',
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(AppButton));
      await tester.pumpAndSettle();

      // Verify specific validation errors
      expect(find.text('Overs must be at least 1'), findsOneWidget);
      expect(find.text('Cannot have more than 11 players per team'), findsOneWidget);

      // Fix the validation errors
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Match Title'),
        'Valid Match',
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Venue'),
        'Valid Venue',
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Overs'),
        '20',
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Players per Team'),
        '11',
      );
      await tester.pumpAndSettle();

      // Submit valid form
      await tester.tap(find.byType(AppButton));
      await tester.pumpAndSettle();

      // Verify successful creation (should navigate back to matches screen)
      expect(find.byType(MatchesScreen), findsOneWidget);
      expect(find.text('Valid Match'), findsOneWidget);
    });

    testWidgets('Match list and filtering workflow', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Navigate to matches screen
      await tester.tap(find.text('Matches'));
      await tester.pumpAndSettle();

      // Verify matches are displayed
      expect(find.byType(MatchesScreen), findsOneWidget);

      // Test pull to refresh
      await tester.fling(find.byType(ListView), const Offset(0, 300), 1000);
      await tester.pumpAndSettle();

      // Verify refresh completed (matches still visible)
      expect(find.byType(ListView), findsOneWidget);

      // Test filtering (if filter options are available)
      final filterButton = find.byIcon(Icons.filter_list);
      if (tester.any(filterButton)) {
        await tester.tap(filterButton);
        await tester.pumpAndSettle();

        // Select a filter option
        final scheduledFilter = find.text('Scheduled');
        if (tester.any(scheduledFilter)) {
          await tester.tap(scheduledFilter);
          await tester.pumpAndSettle();

          // Verify filtered results
          expect(find.text('Scheduled'), findsWidgets);
        }
      }

      // Test search (if search is available)
      final searchButton = find.byIcon(Icons.search);
      if (tester.any(searchButton)) {
        await tester.tap(searchButton);
        await tester.pumpAndSettle();

        // Enter search query
        await tester.enterText(find.byType(TextField), 'Test');
        await tester.pumpAndSettle();

        // Verify search results
        expect(find.textContaining('Test'), findsWidgets);
      }
    });

    testWidgets('Error handling workflow', (WidgetTester tester) async {
      // This test would simulate network errors or other failures
      // and verify that appropriate error messages are shown
      
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Navigate to matches screen
      await tester.tap(find.text('Matches'));
      await tester.pumpAndSettle();

      // If error state is shown, verify retry functionality
      final retryButton = find.text('Retry');
      if (tester.any(retryButton)) {
        await tester.tap(retryButton);
        await tester.pumpAndSettle();

        // Verify loading state or successful retry
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      }
    });
  });
}