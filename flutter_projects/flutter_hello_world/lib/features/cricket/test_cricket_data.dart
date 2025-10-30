import 'package:flutter/material.dart';
import 'data/repositories/cricket_simple_repository.dart';
import 'domain/entities/match_entity.dart';

/// Simple test screen to verify cricket data layer works
class TestCricketDataScreen extends StatefulWidget {
  const TestCricketDataScreen({super.key});

  @override
  State<TestCricketDataScreen> createState() => _TestCricketDataScreenState();
}

class _TestCricketDataScreenState extends State<TestCricketDataScreen> {
  final CricketSimpleRepository _repository = CricketSimpleRepository();
  List<MatchEntity> _matches = [];
  bool _isLoading = false;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  Future<void> _loadMatches() async {
    setState(() {
      _isLoading = true;
      _message = 'Loading matches...';
    });

    final result = await _repository.getMatches();
    
    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
          _message = 'Error: ${failure.message}';
        });
      },
      (matches) {
        setState(() {
          _isLoading = false;
          _matches = matches;
          _message = 'Loaded ${matches.length} matches successfully!';
        });
      },
    );
  }

  Future<void> _loadTeams() async {
    setState(() {
      _isLoading = true;
      _message = 'Loading teams...';
    });

    final result = await _repository.getTeams();
    
    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
          _message = 'Error loading teams: ${failure.message}';
        });
      },
      (teams) {
        setState(() {
          _isLoading = false;
          _message = 'Loaded ${teams.length} teams successfully!';
        });
      },
    );
  }

  Future<void> _loadScores() async {
    if (_matches.isEmpty) {
      setState(() {
        _message = 'No matches available to load scores';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = 'Loading scores...';
    });

    final result = await _repository.getMatchScores(_matches.first.id);
    
    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
          _message = 'Error loading scores: ${failure.message}';
        });
      },
      (scores) {
        setState(() {
          _isLoading = false;
          _message = 'Loaded ${scores.length} scores successfully!';
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cricket Data Layer Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cricket Data Layer Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _message,
                      style: TextStyle(
                        color: _message.startsWith('Error') ? Colors.red : Colors.green,
                      ),
                    ),
                    if (_isLoading) ...[
                      const SizedBox(height: 8),
                      const LinearProgressIndicator(),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Test Operations:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading ? null : _loadMatches,
              child: const Text('Load Matches'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading ? null : _loadTeams,
              child: const Text('Load Teams'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading ? null : _loadScores,
              child: const Text('Load Scores'),
            ),
            const SizedBox(height: 16),
            if (_matches.isNotEmpty) ...[
              const Text(
                'Matches:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: _matches.length,
                  itemBuilder: (context, index) {
                    final match = _matches[index];
                    return Card(
                      child: ListTile(
                        title: Text(match.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${match.team1.name} vs ${match.team2.name}'),
                            Text('Venue: ${match.venue}'),
                            Text('Status: ${match.status.toString().split('.').last}'),
                            Text('Overs: ${match.overs}'),
                          ],
                        ),
                        trailing: Icon(
                          match.status == MatchStatus.completed
                              ? Icons.check_circle
                              : match.status == MatchStatus.inProgress
                                  ? Icons.play_circle
                                  : Icons.schedule,
                          color: match.status == MatchStatus.completed
                              ? Colors.green
                              : match.status == MatchStatus.inProgress
                                  ? Colors.orange
                                  : Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}