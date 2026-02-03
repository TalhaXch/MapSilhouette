import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/game_constants.dart';
import '../models/game_mode.dart';

/// Service for persisting game data
class PersistenceService {
  final SharedPreferences _prefs;

  PersistenceService(this._prefs);

  /// Save high score
  Future<void> saveHighScore(int score) async {
    final currentHighScore = getHighScore();
    if (score > currentHighScore) {
      await _prefs.setInt(GameConstants.highScoreKey, score);
    }
  }

  /// Get high score
  int getHighScore() {
    return _prefs.getInt(GameConstants.highScoreKey) ?? 0;
  }

  /// Save best streak
  Future<void> saveBestStreak(int streak) async {
    final currentBestStreak = getBestStreak();
    if (streak > currentBestStreak) {
      await _prefs.setInt(GameConstants.bestStreakKey, streak);
    }
  }

  /// Get best streak
  int getBestStreak() {
    return _prefs.getInt(GameConstants.bestStreakKey) ?? 0;
  }

  /// Save last game mode
  Future<void> saveLastMode(GameMode mode) async {
    await _prefs.setString(GameConstants.lastModeKey, mode.name);
  }

  /// Get last game mode
  GameMode getLastMode() {
    final modeName = _prefs.getString(GameConstants.lastModeKey);
    if (modeName == null) return GameMode.classic;

    try {
      return GameMode.values.firstWhere((m) => m.name == modeName);
    } catch (e) {
      return GameMode.classic;
    }
  }

  /// Increment total games played
  Future<void> incrementTotalGames() async {
    final current = getTotalGames();
    await _prefs.setInt(GameConstants.totalGamesKey, current + 1);
  }

  /// Get total games played
  int getTotalGames() {
    return _prefs.getInt(GameConstants.totalGamesKey) ?? 0;
  }

  /// Increment total correct answers
  Future<void> incrementTotalCorrect(int count) async {
    final current = getTotalCorrect();
    await _prefs.setInt(GameConstants.totalCorrectKey, current + count);
  }

  /// Get total correct answers
  int getTotalCorrect() {
    return _prefs.getInt(GameConstants.totalCorrectKey) ?? 0;
  }

  /// Clear all data
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}

/// Provider for SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized in main()');
});

/// Provider for PersistenceService
final persistenceServiceProvider = Provider<PersistenceService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PersistenceService(prefs);
});
