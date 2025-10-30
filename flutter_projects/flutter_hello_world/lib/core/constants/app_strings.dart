/// GullyCric App String Constants
/// 
/// Centralized string constants for the cricket app.
/// These will be replaced with localized strings in the future.
class AppStrings {
  AppStrings._(); // Private constructor to prevent instantiation

  // App Information
  static const String appName = 'GullyCric';
  static const String appTagline = 'Your Cricket Universe';
  static const String appDescription = 'Local matches, global cricket, endless passion';

  // Authentication
  static const String login = 'Login';
  static const String signup = 'Sign Up';
  static const String logout = 'Logout';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String forgotPassword = 'Forgot Password?';
  static const String dontHaveAccount = "Don't have an account?";
  static const String alreadyHaveAccount = 'Already have an account?';
  static const String createAccount = 'Create Account';
  static const String welcomeBack = 'Welcome Back!';
  static const String getStarted = 'Get Started';
  static const String continueAsGuest = 'Continue as Guest';

  // Navigation
  static const String home = 'Home';
  static const String matches = 'Matches';
  static const String profile = 'Profile';
  static const String settings = 'Settings';
  static const String localCricket = 'Local Cricket';
  static const String liveMatches = 'Live Matches';
  static const String news = 'News';
  static const String leaderboard = 'Leaderboard';

  // Match Management
  static const String createMatch = 'Create Match';
  static const String joinMatch = 'Join Match';
  static const String startMatch = 'Start Match';
  static const String endMatch = 'End Match';
  static const String updateScore = 'Update Score';
  static const String matchDetails = 'Match Details';
  static const String scoreBoard = 'Score Board';
  static const String teamA = 'Team A';
  static const String teamB = 'Team B';
  static const String overs = 'Overs';
  static const String runs = 'Runs';
  static const String wickets = 'Wickets';
  static const String balls = 'Balls';
  static const String extras = 'Extras';
  static const String target = 'Target';
  static const String required = 'Required';
  static const String runRate = 'Run Rate';
  static const String currentRunRate = 'CRR';
  static const String requiredRunRate = 'RRR';

  // Player Management
  static const String players = 'Players';
  static const String addPlayer = 'Add Player';
  static const String playerName = 'Player Name';
  static const String playerRole = 'Player Role';
  static const String batsman = 'Batsman';
  static const String bowler = 'Bowler';
  static const String allRounder = 'All Rounder';
  static const String wicketKeeper = 'Wicket Keeper';
  static const String captain = 'Captain';
  static const String viceCaptain = 'Vice Captain';

  // Statistics
  static const String stats = 'Statistics';
  static const String matchesPlayed = 'Matches Played';
  static const String matchesWon = 'Matches Won';
  static const String matchesLost = 'Matches Lost';
  static const String totalRuns = 'Total Runs';
  static const String totalWickets = 'Total Wickets';
  static const String bestScore = 'Best Score';
  static const String average = 'Average';
  static const String strikeRate = 'Strike Rate';
  static const String economy = 'Economy';

  // Common Actions
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String add = 'Add';
  static const String remove = 'Remove';
  static const String confirm = 'Confirm';
  static const String yes = 'Yes';
  static const String no = 'No';
  static const String ok = 'OK';
  static const String done = 'Done';
  static const String next = 'Next';
  static const String previous = 'Previous';
  static const String skip = 'Skip';
  static const String retry = 'Retry';
  static const String refresh = 'Refresh';
  static const String loading = 'Loading...';
  static const String search = 'Search';
  static const String filter = 'Filter';
  static const String sort = 'Sort';

  // Error Messages
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork = 'Network error. Please check your connection.';
  static const String errorAuth = 'Authentication failed. Please login again.';
  static const String errorValidation = 'Please check your input and try again.';
  static const String errorNotFound = 'Requested data not found.';
  static const String errorPermission = 'Permission denied.';
  static const String errorTimeout = 'Request timeout. Please try again.';

  // Success Messages
  static const String successLogin = 'Login successful!';
  static const String successSignup = 'Account created successfully!';
  static const String successMatchCreated = 'Match created successfully!';
  static const String successScoreUpdated = 'Score updated successfully!';
  static const String successPlayerAdded = 'Player added successfully!';
  static const String successDataSaved = 'Data saved successfully!';

  // Validation Messages
  static const String validationEmailRequired = 'Email is required';
  static const String validationEmailInvalid = 'Please enter a valid email';
  static const String validationPasswordRequired = 'Password is required';
  static const String validationPasswordTooShort = 'Password must be at least 6 characters';
  static const String validationPasswordMismatch = 'Passwords do not match';
  static const String validationNameRequired = 'Name is required';
  static const String validationNameTooShort = 'Name must be at least 2 characters';

  // Settings
  static const String darkMode = 'Dark Mode';
  static const String lightMode = 'Light Mode';
  static const String systemMode = 'System Mode';
  static const String language = 'Language';
  static const String notifications = 'Notifications';
  static const String privacy = 'Privacy';
  static const String termsOfService = 'Terms of Service';
  static const String aboutApp = 'About App';
  static const String version = 'Version';
  static const String contactUs = 'Contact Us';
  static const String rateApp = 'Rate App';
  static const String shareApp = 'Share App';

  // Cricket Terms
  static const String innings = 'Innings';
  static const String firstInnings = '1st Innings';
  static const String secondInnings = '2nd Innings';
  static const String toss = 'Toss';
  static const String batting = 'Batting';
  static const String bowling = 'Bowling';
  static const String fielding = 'Fielding';
  static const String boundary = 'Boundary';
  static const String six = 'Six';
  static const String four = 'Four';
  static const String wide = 'Wide';
  static const String noBall = 'No Ball';
  static const String bye = 'Bye';
  static const String legBye = 'Leg Bye';
  static const String stumped = 'Stumped';
  static const String caught = 'Caught';
  static const String bowled = 'Bowled';
  static const String lbw = 'LBW';
  static const String runOut = 'Run Out';
  static const String hitWicket = 'Hit Wicket';

  // Time and Date
  static const String today = 'Today';
  static const String yesterday = 'Yesterday';
  static const String tomorrow = 'Tomorrow';
  static const String thisWeek = 'This Week';
  static const String thisMonth = 'This Month';
  static const String live = 'LIVE';
  static const String upcoming = 'Upcoming';
  static const String completed = 'Completed';
  static const String cancelled = 'Cancelled';
}