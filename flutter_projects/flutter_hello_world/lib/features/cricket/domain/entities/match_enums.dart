/// Cricket Match Enumerations
/// 
/// Contains all enums related to cricket matches

/// Match Type Enumeration
enum MatchType {
  local,
  friendly,
  tournament,
  league,
  practice,
}

/// Match Format Enumeration
enum MatchFormat {
  t20,
  odi,
  test,
  t10,
  custom,
}

/// Match Status Enumeration
enum MatchStatus {
  scheduled,
  inProgress,
  completed,
  cancelled,
  postponed,
  abandoned,
}

/// Match Result Enumeration
enum MatchResult {
  team1Won,
  team2Won,
  draw,
  tie,
  noResult,
  abandoned,
}

/// Toss Decision Enumeration
enum TossDecision {
  bat,
  bowl,
}

/// Result Type Enumeration
enum ResultType {
  win,
  tie,
  draw,
  noResult,
  abandoned,
}

/// Dismissal Type Enumeration
enum DismissalType {
  bowled,
  caught,
  lbw,
  runOut,
  stumped,
  hitWicket,
  handledBall,
  obstructingField,
  timedOut,
  retired,
}