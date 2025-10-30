import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../domain/entities/match_entity.dart';
import '../../domain/entities/player_entity.dart';
import '../../domain/entities/score_entity.dart';
import '../providers/cricket_provider.dart';

class ScoreUpdateScreen extends ConsumerStatefulWidget {
  final MatchEntity match;

  const ScoreUpdateScreen({
    super.key,
    required this.match,
  });

  @override
  ConsumerState<ScoreUpdateScreen> createState() => _ScoreUpdateScreenState();
}

class _ScoreUpdateScreenState extends ConsumerState<ScoreUpdateScreen> {
  PlayerEntity? _selectedPlayer;
  String? _selectedTeamId;
  
  int _runs = 0;
  int _ballsFaced = 0;
  int _fours = 0;
  int _sixes = 0;
  bool _isOut = false;
  
  final _runsController = TextEditingController();
  final _ballsController = TextEditingController();
  final _foursController = TextEditingController();
  final _sixesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedTeamId = widget.match.team1.id;
    _runsController.addListener(_updateRuns);
    _ballsController.addListener(_updateBalls);
    _foursController.addListener(_updateFours);
    _sixesController.addListener(_updateSixes);
  }

  @override
  void dispose() {
    _runsController.dispose();
    _ballsController.dispose();
    _foursController.dispose();
    _sixesController.dispose();
    super.dispose();
  }

  void _updateRuns() {
    setState(() {
      _runs = int.tryParse(_runsController.text) ?? 0;
    });
  }

  void _updateBalls() {
    setState(() {
      _ballsFaced = int.tryParse(_ballsController.text) ?? 0;
    });
  }

  void _updateFours() {
    setState(() {
      _fours = int.tryParse(_foursController.text) ?? 0;
    });
  }

  void _updateSixes() {
    setState(() {
      _sixes = int.tryParse(_sixesController.text) ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scoreUpdateAsync = ref.watch(scoreUpdateProvider);

    // Listen to score update state
    ref.listen<AsyncValue<ScoreEntity?>>(scoreUpdateProvider, (previous, next) {
      next.whenOrNull(
        data: (score) {
          if (score != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Score updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
        },
        error: (error, stack) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $error'),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'Update Score',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMatchHeader(),
            const SizedBox(height: 16),
            _buildTeamSelection(),
            const SizedBox(height: 16),
            _buildPlayerSelection(),
            const SizedBox(height: 16),
            _buildScoreInputs(),
            const SizedBox(height: 16),
            _buildDismissalSection(),
            const SizedBox(height: 24),
            scoreUpdateAsync.when(
              data: (_) => AppButton(
                text: 'Update Score',
                onPressed: _canUpdateScore() ? _updateScore : null,
              ),
              loading: () => const AppButton(
                text: 'Updating...',
                onPressed: null,
                text: 'Loading...',
                isLoading: true,
              ),
              error: (_, __) => AppButton(
                text: 'Update Score',
                onPressed: _canUpdateScore() ? _updateScore : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchHeader() {
    return AppCard(
      child: Column(
        children: [
          Text(
            widget.match.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.match.team1.name} vs ${widget.match.team2.name}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTeamSelection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Team',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTeamOption(widget.match.team1, widget.match.team1.id),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTeamOption(widget.match.team2, widget.match.team2.id),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeamOption(team, String teamId) {
    final isSelected = _selectedTeamId == teamId;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTeamId = teamId;
          _selectedPlayer = null; // Reset player selection
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.textSecondary.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.sports_cricket,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              team.name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerSelection() {
    if (_selectedTeamId == null) {
      return const SizedBox.shrink();
    }

    final selectedTeam = _selectedTeamId == widget.match.team1.id 
        ? widget.match.team1 
        : widget.match.team2;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Player',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<PlayerEntity>(
            value: _selectedPlayer,
            decoration: const InputDecoration(
              labelText: 'Player',
              border: OutlineInputBorder(),
            ),
            items: selectedTeam.players.map((player) {
              return DropdownMenuItem(
                value: player,
                child: Text('${player.name}'),
              );
            }).toList(),
            onChanged: (player) {
              setState(() {
                _selectedPlayer = player;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please select a player';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildScoreInputs() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Score Details',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _runsController,
                  decoration: const InputDecoration(
                    labelText: 'Runs',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _ballsController,
                  decoration: const InputDecoration(
                    labelText: 'Balls Faced',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _foursController,
                  decoration: const InputDecoration(
                    labelText: 'Fours',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _sixesController,
                  decoration: const InputDecoration(
                    labelText: 'Sixes',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_ballsFaced > 0)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Strike Rate:',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  Text(
                    '${(_runs / _ballsFaced * 100).toStringAsFixed(1)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDismissalSection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dismissal',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Player is out'),
            value: _isOut,
            onChanged: (value) {
              setState(() {
                _isOut = value;
              });
            },
            activeColor: AppColors.primary,
          ),
          if (_isOut) ...[
            const SizedBox(height: 16),
            const Text(
              'Dismissal details will be added in future updates',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool _canUpdateScore() {
    return _selectedPlayer != null && _selectedTeamId != null;
  }

  void _updateScore() {
    if (_canUpdateScore()) {
      ref.read(scoreUpdateProvider.notifier).updateScore(
        matchId: widget.match.id,
        teamId: _selectedTeamId!,
        playerId: _selectedPlayer!.id,
        runs: _runs,
        ballsFaced: _ballsFaced,
        fours: _fours,
        sixes: _sixes,
        isOut: _isOut,
      );
    }
  }
}