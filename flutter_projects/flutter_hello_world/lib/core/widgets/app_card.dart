import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import '../theme/text_theme.dart';

/// GullyCric App Card Widget
/// 
/// Consistent card implementation following Material 3 design
/// with cricket-themed styling and various card types
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Border? border;
  final VoidCallback? onTap;
  final bool isClickable;
  final double? width;
  final double? height;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.border,
    this.onTap,
    this.isClickable = false,
    this.width,
    this.height,
  });

  /// Clickable card constructor
  const AppCard.clickable({
    super.key,
    required this.child,
    required this.onTap,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.border,
    this.width,
    this.height,
  }) : isClickable = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget card = Card(
      color: backgroundColor ?? theme.colorScheme.surface,
      elevation: elevation ?? AppDimensions.cardElevation,
      margin: margin ?? const EdgeInsets.all(AppDimensions.spacingS),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(AppDimensions.cardRadius),
        side: BorderSide.none,
      ),
      child: Container(
        width: width,
        height: height,
        padding: padding ?? const EdgeInsets.all(AppDimensions.cardPadding),
        decoration: border != null ? BoxDecoration(
          border: border,
          borderRadius: borderRadius ?? BorderRadius.circular(AppDimensions.cardRadius),
        ) : null,
        child: child,
      ),
    );

    if (isClickable || onTap != null) {
      card = InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(AppDimensions.cardRadius),
        child: card,
      );
    }

    return card;
  }
}

/// Cricket Match Card
class MatchCard extends StatelessWidget {
  final String matchTitle;
  final String teamA;
  final String teamB;
  final String? scoreA;
  final String? scoreB;
  final String matchStatus;
  final String? matchTime;
  final VoidCallback? onTap;
  final bool isLive;
  final Widget? statusIcon;

  const MatchCard({
    super.key,
    required this.matchTitle,
    required this.teamA,
    required this.teamB,
    this.scoreA,
    this.scoreB,
    required this.matchStatus,
    this.matchTime,
    this.onTap,
    this.isLive = false,
    this.statusIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AppCard.clickable(
      onTap: onTap,
      height: AppDimensions.matchCardHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Match header
          Row(
            children: [
              Expanded(
                child: Text(
                  matchTitle,
                  style: AppTextTheme.cricket.matchTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isLive) _buildLiveIndicator(),
              if (statusIcon != null) statusIcon!,
            ],
          ),
          
          const SizedBox(height: AppDimensions.spacingM),
          
          // Teams and scores
          Expanded(
            child: Row(
              children: [
                // Team A
                Expanded(
                  child: _buildTeamSection(
                    context,
                    teamA,
                    scoreA,
                    TextAlign.left,
                  ),
                ),
                
                // VS separator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingM,
                  ),
                  child: Text(
                    'VS',
                    style: AppTextTheme.cricket.matchDetails.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                
                // Team B
                Expanded(
                  child: _buildTeamSection(
                    context,
                    teamB,
                    scoreB,
                    TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacingS),
          
          // Match status and time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                matchStatus,
                style: AppTextTheme.cricket.matchDetails.copyWith(
                  color: _getStatusColor(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (matchTime != null)
                Text(
                  matchTime!,
                  style: AppTextTheme.cricket.matchTime,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeamSection(
    BuildContext context,
    String teamName,
    String? score,
    TextAlign alignment,
  ) {
    return Column(
      crossAxisAlignment: alignment == TextAlign.left 
          ? CrossAxisAlignment.start 
          : CrossAxisAlignment.end,
      children: [
        Text(
          teamName,
          style: AppTextTheme.cricket.teamNameSmall,
          textAlign: alignment,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppDimensions.spacingXS),
        if (score != null)
          Text(
            score,
            style: AppTextTheme.cricket.scoreSmall,
            textAlign: alignment,
          ),
      ],
    );
  }

  Widget _buildLiveIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingS,
        vertical: AppDimensions.spacingXS,
      ),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppDimensions.liveIndicatorSize,
            height: AppDimensions.liveIndicatorSize,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppDimensions.spacingXS),
          Text(
            'LIVE',
            style: AppTextTheme.cricket.liveIndicator,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(BuildContext context) {
    final theme = Theme.of(context);
    
    if (isLive) {
      return AppColors.error;
    }
    
    switch (matchStatus.toLowerCase()) {
      case 'completed':
        return AppColors.success;
      case 'upcoming':
        return AppColors.warning;
      case 'cancelled':
        return theme.colorScheme.error;
      default:
        return theme.colorScheme.onSurfaceVariant;
    }
  }
}

/// Player Card
class PlayerCard extends StatelessWidget {
  final String playerName;
  final String playerRole;
  final String? playerImage;
  final Map<String, String>? stats;
  final VoidCallback? onTap;
  final bool isCaptain;
  final bool isSelected;

  const PlayerCard({
    super.key,
    required this.playerName,
    required this.playerRole,
    this.playerImage,
    this.stats,
    this.onTap,
    this.isCaptain = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AppCard.clickable(
      onTap: onTap,
      height: AppDimensions.playerCardHeight,
      backgroundColor: isSelected 
          ? theme.colorScheme.primaryContainer 
          : null,
      border: isSelected 
          ? Border.all(color: theme.colorScheme.primary, width: 2)
          : null,
      child: Row(
        children: [
          // Player avatar
          CircleAvatar(
            radius: AppDimensions.avatarM / 2,
            backgroundImage: playerImage != null 
                ? NetworkImage(playerImage!) 
                : null,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: playerImage == null 
                ? Icon(
                    Icons.person,
                    color: theme.colorScheme.onPrimaryContainer,
                    size: AppDimensions.iconM,
                  )
                : null,
          ),
          
          const SizedBox(width: AppDimensions.spacingM),
          
          // Player info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        playerName,
                        style: AppTextTheme.cricket.playerNameSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isCaptain)
                      Icon(
                        Icons.star,
                        color: AppColors.accent,
                        size: AppDimensions.iconS,
                      ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingXS),
                Text(
                  playerRole,
                  style: AppTextTheme.cricket.playerRole,
                ),
              ],
            ),
          ),
          
          // Player stats
          if (stats != null && stats!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: stats!.entries.take(2).map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.spacingXS),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        entry.value,
                        style: AppTextTheme.cricket.playerStats.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        entry.key,
                        style: AppTextTheme.cricket.playerStats.copyWith(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

/// News Card
class NewsCard extends StatelessWidget {
  final String title;
  final String? content;
  final String? imageUrl;
  final String? author;
  final DateTime? publishedAt;
  final VoidCallback? onTap;
  final bool isCompact;

  const NewsCard({
    super.key,
    required this.title,
    this.content,
    this.imageUrl,
    this.author,
    this.publishedAt,
    this.onTap,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard.clickable(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          if (imageUrl != null && !isCompact)
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              child: Image.network(
                imageUrl!,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120,
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: Icon(
                      Icons.image_not_supported,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  );
                },
              ),
            ),
          
          if (imageUrl != null && !isCompact)
            const SizedBox(height: AppDimensions.spacingM),
          
          // Title
          Text(
            title,
            style: AppTextTheme.cricket.newsTitle,
            maxLines: isCompact ? 2 : 3,
            overflow: TextOverflow.ellipsis,
          ),
          
          // Content
          if (content != null && !isCompact) ...[
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              content!,
              style: AppTextTheme.cricket.newsContent,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          
          // Metadata
          if (author != null || publishedAt != null) ...[
            const SizedBox(height: AppDimensions.spacingM),
            Row(
              children: [
                if (author != null) ...[
                  Icon(
                    Icons.person_outline,
                    size: AppDimensions.iconXS,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppDimensions.spacingXS),
                  Text(
                    author!,
                    style: AppTextTheme.cricket.newsMetadata,
                  ),
                ],
                if (author != null && publishedAt != null)
                  const SizedBox(width: AppDimensions.spacingM),
                if (publishedAt != null) ...[
                  Icon(
                    Icons.access_time,
                    size: AppDimensions.iconXS,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppDimensions.spacingXS),
                  Text(
                    _formatDate(publishedAt!),
                    style: AppTextTheme.cricket.newsMetadata,
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

/// Score Card
class ScoreCard extends StatelessWidget {
  final String teamName;
  final String runs;
  final String wickets;
  final String overs;
  final String? runRate;
  final bool isCurrentInnings;
  final VoidCallback? onTap;

  const ScoreCard({
    super.key,
    required this.teamName,
    required this.runs,
    required this.wickets,
    required this.overs,
    this.runRate,
    this.isCurrentInnings = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AppCard.clickable(
      onTap: onTap,
      backgroundColor: isCurrentInnings 
          ? theme.colorScheme.primaryContainer.withOpacity(0.3)
          : null,
      border: isCurrentInnings 
          ? Border.all(color: theme.colorScheme.primary, width: 1)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Team name
          Row(
            children: [
              Expanded(
                child: Text(
                  teamName,
                  style: AppTextTheme.cricket.teamName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isCurrentInnings)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingS,
                    vertical: AppDimensions.spacingXS,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                  ),
                  child: Text(
                    'BATTING',
                    style: AppTextTheme.cricket.liveIndicator,
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: AppDimensions.spacingM),
          
          // Score
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                runs,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Text(
                '/$wickets',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingM),
              Text(
                '($overs)',
                style: AppTextTheme.cricket.scoreText.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          
          // Run rate
          if (runRate != null) ...[
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              'Run Rate: $runRate',
              style: AppTextTheme.cricket.runRate,
            ),
          ],
        ],
      ),
    );
  }
}

/// Statistics Card
class StatsCard extends StatelessWidget {
  final String title;
  final Map<String, String> stats;
  final Color? accentColor;
  final VoidCallback? onTap;

  const StatsCard({
    super.key,
    required this.title,
    required this.stats,
    this.accentColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AppCard.clickable(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: AppTextTheme.cricket.cardTitle.copyWith(
              color: accentColor ?? theme.colorScheme.primary,
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacingM),
          
          // Stats
          ...stats.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spacingS),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.key,
                    style: AppTextTheme.cricket.cardSubtitle,
                  ),
                  Text(
                    entry.value,
                    style: AppTextTheme.cricket.statistics.copyWith(
                      fontWeight: FontWeight.w600,
                      color: accentColor ?? theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}