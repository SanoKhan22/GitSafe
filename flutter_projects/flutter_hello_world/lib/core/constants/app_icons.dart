import 'package:flutter/material.dart';

/// GullyCric App Icon Constants
/// 
/// Centralized icon definitions using Material Symbols Outlined
/// and cricket-themed icons for consistent UI/UX
class AppIcons {
  AppIcons._(); // Private constructor to prevent instantiation

  // Navigation Icons
  static const IconData home = Icons.home_outlined;
  static const IconData homeFilled = Icons.home;
  static const IconData matches = Icons.sports_cricket_outlined;
  static const IconData matchesFilled = Icons.sports_cricket;
  static const IconData profile = Icons.person_outline;
  static const IconData profileFilled = Icons.person;
  static const IconData settings = Icons.settings_outlined;
  static const IconData settingsFilled = Icons.settings;

  // Cricket-specific Icons
  static const IconData cricketBat = Icons.sports_cricket;
  static const IconData cricketBall = Icons.sports_baseball_outlined;
  static const IconData trophy = Icons.emoji_events_outlined;
  static const IconData trophyFilled = Icons.emoji_events;
  static const IconData leaderboard = Icons.leaderboard_outlined;
  static const IconData team = Icons.groups_outlined;
  static const IconData teamFilled = Icons.groups;
  static const IconData stadium = Icons.stadium_outlined;
  static const IconData timer = Icons.timer_outlined;
  static const IconData scoreboard = Icons.scoreboard_outlined;

  // Match Actions
  static const IconData play = Icons.play_arrow_outlined;
  static const IconData pause = Icons.pause_outlined;
  static const IconData stop = Icons.stop_outlined;
  static const IconData add = Icons.add_outlined;
  static const IconData edit = Icons.edit_outlined;
  static const IconData delete = Icons.delete_outline;
  static const IconData save = Icons.save_outlined;
  static const IconData cancel = Icons.cancel_outlined;
  static const IconData check = Icons.check_circle_outline;
  static const IconData close = Icons.close_outlined;

  // Player Actions
  static const IconData addPlayer = Icons.person_add_outlined;
  static const IconData removePlayer = Icons.person_remove_outlined;
  static const IconData captain = Icons.star_outline;
  static const IconData captainFilled = Icons.star;
  static const IconData wicketKeeper = Icons.sports_handball_outlined;
  static const IconData batsman = Icons.sports_cricket;
  static const IconData bowler = Icons.sports_baseball;
  static const IconData allRounder = Icons.all_inclusive_outlined;

  // Statistics Icons
  static const IconData stats = Icons.analytics_outlined;
  static const IconData chart = Icons.bar_chart_outlined;
  static const IconData trending = Icons.trending_up_outlined;
  static const IconData medal = Icons.military_tech_outlined;
  static const IconData award = Icons.workspace_premium_outlined;
  static const IconData target = Icons.gps_fixed_outlined;

  // UI/UX Icons
  static const IconData search = Icons.search_outlined;
  static const IconData filter = Icons.filter_list_outlined;
  static const IconData sort = Icons.sort_outlined;
  static const IconData refresh = Icons.refresh_outlined;
  static const IconData share = Icons.share_outlined;
  static const IconData favorite = Icons.favorite_outline;
  static const IconData favoriteFilled = Icons.favorite;
  static const IconData bookmark = Icons.bookmark_outline;
  static const IconData bookmarkFilled = Icons.bookmark;

  // Authentication Icons
  static const IconData login = Icons.login_outlined;
  static const IconData logout = Icons.logout_outlined;
  static const IconData signup = Icons.person_add_outlined;
  static const IconData email = Icons.email_outlined;
  static const IconData password = Icons.lock_outline;
  static const IconData visibility = Icons.visibility_outlined;
  static const IconData visibilityOff = Icons.visibility_off_outlined;

  // Settings Icons
  static const IconData darkMode = Icons.dark_mode_outlined;
  static const IconData lightMode = Icons.light_mode_outlined;
  static const IconData language = Icons.language_outlined;
  static const IconData notifications = Icons.notifications_outlined;
  static const IconData notificationsFilled = Icons.notifications;
  static const IconData privacy = Icons.privacy_tip_outlined;
  static const IconData info = Icons.info_outline;
  static const IconData help = Icons.help_outline;

  // Status Icons
  static const IconData live = Icons.circle;
  static const IconData upcoming = Icons.schedule_outlined;
  static const IconData completed = Icons.check_circle_outline;
  static const IconData cancelled = Icons.cancel_outlined;
  static const IconData warning = Icons.warning_outlined;
  static const IconData error = Icons.error_outline;
  static const IconData success = Icons.check_circle_outline;

  // Navigation Actions
  static const IconData back = Icons.arrow_back_outlined;
  static const IconData forward = Icons.arrow_forward_outlined;
  static const IconData up = Icons.keyboard_arrow_up_outlined;
  static const IconData down = Icons.keyboard_arrow_down_outlined;
  static const IconData left = Icons.keyboard_arrow_left_outlined;
  static const IconData right = Icons.keyboard_arrow_right_outlined;
  static const IconData menu = Icons.menu_outlined;
  static const IconData more = Icons.more_vert_outlined;

  // Media Icons
  static const IconData camera = Icons.camera_alt_outlined;
  static const IconData gallery = Icons.photo_library_outlined;
  static const IconData video = Icons.videocam_outlined;
  static const IconData mic = Icons.mic_outlined;
  static const IconData micOff = Icons.mic_off_outlined;

  // Connectivity Icons
  static const IconData wifi = Icons.wifi_outlined;
  static const IconData wifiOff = Icons.wifi_off_outlined;
  static const IconData bluetooth = Icons.bluetooth_outlined;
  static const IconData location = Icons.location_on_outlined;
  static const IconData locationOff = Icons.location_off_outlined;

  // Cricket Score Icons
  static const IconData runs = Icons.directions_run_outlined;
  static const IconData wicket = Icons.sports_cricket;
  static const IconData over = Icons.timer_outlined;
  static const IconData boundary = Icons.crop_square_outlined;
  static const IconData six = Icons.looks_6_outlined;
  static const IconData four = Icons.looks_4_outlined;
  static const IconData wide = Icons.open_in_full_outlined;
  static const IconData noBall = Icons.not_interested_outlined;

  // Weather Icons (for match conditions)
  static const IconData sunny = Icons.wb_sunny_outlined;
  static const IconData cloudy = Icons.cloud_outlined;
  static const IconData rainy = Icons.grain_outlined;
  static const IconData windy = Icons.air_outlined;

  // Social Icons
  static const IconData like = Icons.thumb_up_outlined;
  static const IconData dislike = Icons.thumb_down_outlined;
  static const IconData comment = Icons.comment_outlined;
  static const IconData reply = Icons.reply_outlined;
  static const IconData repost = Icons.repeat_outlined;

  // File and Data Icons
  static const IconData download = Icons.download_outlined;
  static const IconData upload = Icons.upload_outlined;
  static const IconData file = Icons.description_outlined;
  static const IconData folder = Icons.folder_outlined;
  static const IconData cloud = Icons.cloud_outlined;
  static const IconData sync = Icons.sync_outlined;
}