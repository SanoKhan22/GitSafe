import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/error_view.dart';
import '../../domain/entities/match_entity.dart';
import '../providers/cricket_provider.dart';
import 'create_match_screen.dart';
import 'match_details_screen.dart';

class MatchesScreen extends ConsumerWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchesAsync = ref.watch(matchesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'Cricket Matches',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => ref.refresh(matchesProvider),
          ),
        ],
      ),
      body: matchesAsync.when(
        data: (matches) => _buildMatchesList(context, matches),
        loading: () => const Center(child: AppLoader()),
        error: (error, stack) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.refresh(matchesProvider),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _navigateToCreateMatch(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildMatchesList(BuildContext context, List<MatchEntity> matches) {
    if (matches.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Refresh matches
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: matches.length,
        itemBuilder: (context, index) {
          final match = matches[index];
          return _buildMatchCard(context, match);
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sports_cricket,
            size: 80,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'No matches yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first cricket match to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          AppButton(
            text: 'Create Match',
            onPressed: () => _navigateToCreateMatch(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchCard(BuildContext context, MatchEntity match) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToMatchDetails(context, match),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      match.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  _buildStatusChip(match.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${match.team1.name} vs ${match.team2.name}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    match.venue,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDateTime(match.startTime),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.sports_cricket,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${match.overs} overs • ${match.playersPerTeam} players',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
              if (match.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  match.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
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
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.inDays > 0) {
      return '${difference.inDays} days from now';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours from now';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes from now';
    } else if (difference.inMinutes < 0) {
      return 'Started ${(-difference.inMinutes)} minutes ago';
    } else {
      return 'Starting now';
    }
  }

  void _navigateToCreateMatch(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateMatchScreen(),
      ),
    );
  }

  void _navigateToMatchDetails(BuildContext context, MatchEntity match) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MatchDetailsScreen(matchId: match.id),
      ),
    );
  }
}