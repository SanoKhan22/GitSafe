import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/error_view.dart';
import '../../domain/entities/match_entity.dart';
import '../../domain/entities/score_entity.dart';
import '../providers/cricket_provider.dart';
import 'score_update_screen.dart';

class MatchDetailsScreen extends ConsumerWidget {
  final String matchId;

  const MatchDetailsScreen({
    super.key,
    required this.matchId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchAsync = ref.watch(matchProvider(matchId));
    final scoresAsync = ref.watch(matchScoresProvider(matchId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'Match Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              ref.refresh(matchProvider(matchId));
              ref.refresh(matchScoresProvider(matchId));
            },
          ),
        ],
      ),
      body: matchAsync.when(
        data: (match) => _buildMatchDetails(context, ref, match, scoresAsync),
        loading: () => const Center(child: AppLoader()),
        error: (error, stack) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.refresh(matchProvider(matchId)),
        ),
      ),
    );
  }

  Widget _buildMatchDetails(
    BuildContext context,
    WidgetRef ref,
    MatchEntity match,
    AsyncValue<List<ScoreEntity>> scoresAsync,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildMatchHeader(context, match),
          const SizedBox(height: 16),
          _buildMatchInfo(context, match),
          const SizedBox(height: 16),
          _buildTeamsSection(context, match),
          const SizedBox(height: 16),
          _buildScoresSection(context, scoresAsync),
          const SizedBox(height: 16),
          _buildActionButtons(context, match),
        ],
      ),
    );
  }

  Widget _buildMatchHeader(BuildContext context, MatchEntity match) {
    return AppCard(
      child: Column(
        children: [
          Text(
            match.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '${match.team1.name} vs ${match.team2.name}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _buildStatusChip(match.status),
        ],
      ),
    );
  }

  Widget _buildMatchInfo(BuildContext context, MatchEntity match) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Match Information',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(context, 'Venue', match.venue, Icons.location_on),
          _buildInfoRow(context, 'Date & Time', _formatDateTime(match.startTime), Icons.access_time),
          _buildInfoRow(context, 'Match Type', match.matchType.toString().split('.').last.toUpperCase(), Icons.sports_cricket),
          _buildInfoRow(context, 'Overs', '${match.overs} overs', Icons.timer),
          _buildInfoRow(context, 'Players per Team', '${match.playersPerTeam} players', Icons.group),
          if (match.description.isNotEmpty)
            _buildInfoRow(context, 'Description', match.description, Icons.description),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamsSection(BuildContext context, MatchEntity match) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Teams',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          _buildTeamCard(context, match.team1, 'Team 1'),
          const SizedBox(height: 12),
          _buildTeamCard(context, match.team2, 'Team 2'),
        ],
      ),
    );
  }

  Widget _buildTeamCard(BuildContext context, team, String teamLabel) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                teamLabel,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const Spacer(),
              Text(
                '${team.players.length} players',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            team.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          if (team.captain != null) ...[
            const SizedBox(height: 4),
            Text(
              'Captain: ${_getPlayerName(team, team.captain)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildScoresSection(BuildContext context, AsyncValue<List<ScoreEntity>> scoresAsync) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Scores',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          scoresAsync.when(
            data: (scores) => _buildScoresList(context, scores),
            loading: () => const Center(child: AppLoader()),
            error: (error, stack) => Text(
              'Error loading scores: $error',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoresList(BuildContext context, List<ScoreEntity> scores) {
    if (scores.isEmpty) {
      return Center(
        child: Column(
          children: [
            Icon(
              Icons.sports_cricket,
              size: 48,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              'No scores yet',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: scores.map((score) => _buildScoreCard(context, score)).toList(),
    );
  }

  Widget _buildScoreCard(BuildContext context, ScoreEntity score) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Player ${score.playerId}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Team ${score.teamId}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${score.runs} runs',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                '${score.ballsFaced} balls • SR: ${score.strikeRate.toStringAsFixed(1)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              if (score.fours > 0 || score.sixes > 0)
                Text(
                  '4s: ${score.fours} • 6s: ${score.sixes}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, MatchEntity match) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (match.status == MatchStatus.scheduled)
          AppButton(
            text: 'Start Match',
            onPressed: () => _showStartMatchDialog(context, match),
          ),
        if (match.status == MatchStatus.inProgress) ...[
          AppButton(
            text: 'Update Score',
            onPressed: () => _navigateToScoreUpdate(context, match),
          ),
          const SizedBox(height: 8),
          AppButton(
            text: 'End Match',
            onPressed: () => _showEndMatchDialog(context, match),
            backgroundColor: AppColors.warning,
          ),
        ],
        if (match.status == MatchStatus.completed)
          AppButton(
            text: 'View Full Scorecard',
            onPressed: () => _showFullScorecard(context, match),
          ),
      ],
    );
  }

  Widget _buildStatusChip(MatchStatus status) {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (status) {
      case MatchStatus.scheduled:
        backgroundColor = AppColors.warning.withOpacity(0.1);
        textColor = AppColors.warning;
        text = 'Scheduled';
        break;
      case MatchStatus.inProgress:
        backgroundColor = AppColors.success.withOpacity(0.1);
        textColor = AppColors.success;
        text = 'Live';
        break;
      case MatchStatus.completed:
        backgroundColor = AppColors.primary.withOpacity(0.1);
        textColor = AppColors.primary;
        text = 'Completed';
        break;
      case MatchStatus.cancelled:
        backgroundColor = AppColors.error.withOpacity(0.1);
        textColor = AppColors.error;
        text = 'Cancelled';
        break;
      case MatchStatus.postponed:
        backgroundColor = AppColors.warning.withOpacity(0.1);
        textColor = AppColors.warning;
        text = 'Postponed';
        break;
      case MatchStatus.abandoned:
        backgroundColor = AppColors.error.withOpacity(0.1);
        textColor = AppColors.error;
        text = 'Abandoned';
        break;
        textColor = AppColors.error;
        text = 'Abandoned';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final time = TimeOfDay.fromDateTime(dateTime);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _getPlayerName(team, String? playerId) {
    if (playerId == null) return 'Unknown';
    try {
      final player = team.players.firstWhere((p) => p.id == playerId);
      return player.name;
    } catch (e) {
      return 'Unknown';
    }
  }

  void _navigateToScoreUpdate(BuildContext context, MatchEntity match) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScoreUpdateScreen(match: match),
      ),
    );
  }

  void _showStartMatchDialog(BuildContext context, MatchEntity match) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Match'),
        content: Text('Are you sure you want to start "${match.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          AppButton(
            text: 'Start',
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement start match functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Start match functionality coming soon!')),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showEndMatchDialog(BuildContext context, MatchEntity match) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Match'),
        content: Text('Are you sure you want to end "${match.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          AppButton(
            text: 'End Match',
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement end match functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('End match functionality coming soon!')),
              );
            },
            backgroundColor: AppColors.warning,
          ),
        ],
      ),
    );
  }

  void _showFullScorecard(BuildContext context, MatchEntity match) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Full scorecard view coming soon!')),
    );
  }
}