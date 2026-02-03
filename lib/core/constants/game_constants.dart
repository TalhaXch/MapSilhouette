// Core constants for the Mapsilhouette game
class GameConstants {
  // Timer
  static const int defaultTimerSeconds = 10;
  static const int practiceTimerSeconds = 0; // No timer in practice mode

  // Scoring
  static const int baseCorrectPoints = 100;
  static const int timeBonus = 10; // Points per second remaining

  // Game Settings
  static const int answersPerQuestion = 4;
  static const int timedChallengeQuestions = 10;

  // Difficulty thresholds
  static const int easyQuestionsCount = 5;
  static const int mediumQuestionsCount = 10;

  // Animation durations (milliseconds)
  static const int feedbackDuration = 1500;
  static const int transitionDuration = 300;
  static const int splashDuration = 2000;

  // Storage keys
  static const String highScoreKey = 'high_score';
  static const String bestStreakKey = 'best_streak';
  static const String lastModeKey = 'last_mode';
  static const String totalGamesKey = 'total_games';
  static const String totalCorrectKey = 'total_correct';
}
