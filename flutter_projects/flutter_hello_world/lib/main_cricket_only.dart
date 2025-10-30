import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/cricket/presentation/screens/matches_screen.dart';

/// Simple main for testing cricket functionality only
void main() {
  runApp(const ProviderScope(child: CricketOnlyApp()));
}

class CricketOnlyApp extends StatelessWidget {
  const CricketOnlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GullyCric - Cricket Only',
      theme: AppTheme.lightTheme,
      home: const MatchesScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}