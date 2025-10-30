import 'package:flutter/material.dart';
import 'features/cricket/test_cricket_data.dart';

/// Simple main for testing cricket data layer without auth dependencies
void main() {
  runApp(const CricketTestApp());
}

class CricketTestApp extends StatelessWidget {
  const CricketTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GullyCric - Cricket Data Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TestCricketDataScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}