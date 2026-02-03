import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/game_constants.dart';
import '../data/models/country_model.dart';
import '../data/models/game_mode.dart';
import '../data/models/question_model.dart';
import '../data/repositories/country_repository.dart';
import '../data/services/persistence_service.dart';
import 'game_state.dart';

/// Game controller provider (family - creates separate instances per mode)
final gameControllerProvider =
    StateNotifierProvider.family<GameController, GameState, GameMode>((
      ref,
      mode,
    ) {
      final countryRepo = ref.watch(countryRepositoryProvider);
      final persistenceService = ref.watch(persistenceServiceProvider);
      return GameController(
        mode: mode,
        countryRepository: countryRepo,
        persistenceService: persistenceService,
      );
    });

/// Main game logic controller
class GameController extends StateNotifier<GameState> {
  final GameMode mode;
  final CountryRepository countryRepository;
  final PersistenceService persistenceService;

  Timer? _timer;
  var _availableCountries = <CountryModel>[];
  final _usedCountries = <CountryModel>[];
  final _random = Random();

  GameController({
    required this.mode,
    required this.countryRepository,
    required this.persistenceService,
  }) : super(GameState(mode: mode));

  /// Start a new game
  void startGame() {
    // Reset state
    _availableCountries = List.from(countryRepository.getAllCountries());
    _usedCountries.clear();
    _timer?.cancel();

    // Load best streak from persistence
    final bestStreak = persistenceService.getBestStreak();

    state = GameState(
      mode: mode,
      status: GameStatus.playing,
      bestStreak: bestStreak,
    );

    // Generate first question
    _generateQuestion();
  }

  /// Generate a new question based on difficulty progression
  void _generateQuestion() {
    // Check if game should end (Timed Challenge mode)
    if (mode == GameMode.timedChallenge &&
        state.questionNumber >= GameConstants.timedChallengeQuestions) {
      _endGame();
      return;
    }

    // Determine difficulty based on question number
    final difficulty = _getDifficultyForQuestion(state.questionNumber + 1);

    // Get countries for this difficulty
    var countriesForDifficulty =
        _availableCountries.where((c) => c.difficulty == difficulty).toList();

    // If no countries available for this difficulty, use all available
    if (countriesForDifficulty.isEmpty) {
      countriesForDifficulty = _availableCountries;
    }

    // If we've used all countries, reset the pool
    if (countriesForDifficulty.isEmpty) {
      _availableCountries.addAll(_usedCountries);
      _usedCountries.clear();
      countriesForDifficulty =
          _availableCountries.where((c) => c.difficulty == difficulty).toList();
    }

    // Select random correct country
    final correctCountry =
        countriesForDifficulty[_random.nextInt(countriesForDifficulty.length)];

    // Move to used countries
    _availableCountries.remove(correctCountry);
    _usedCountries.add(correctCountry);

    // Generate wrong answers
    final wrongAnswers = _generateWrongAnswers(correctCountry, 3);

    // Create question with shuffled answers
    final allAnswers = [correctCountry, ...wrongAnswers]..shuffle(_random);

    final question = QuestionModel(
      correctAnswer: correctCountry,
      options: allAnswers,
      questionNumber: state.questionNumber + 1,
    );

    // Update state with new question
    state = state.copyWith(
      currentQuestion: question,
      questionNumber: state.questionNumber + 1,
      timeRemaining:
          mode == GameMode.practice ? 0 : GameConstants.defaultTimerSeconds,
      clearSelectedAnswer: true,
      status: GameStatus.playing,
    );

    // Start timer if not practice mode
    if (mode != GameMode.practice) {
      _startTimer();
    }
  }

  /// Get difficulty level for a given question number
  DifficultyLevel _getDifficultyForQuestion(int questionNumber) {
    if (questionNumber <= 5) {
      return DifficultyLevel.easy;
    } else if (questionNumber <= 10) {
      return DifficultyLevel.medium;
    } else {
      return DifficultyLevel.hard;
    }
  }

  /// Generate wrong answer options
  List<CountryModel> _generateWrongAnswers(
    CountryModel correctCountry,
    int count,
  ) {
    final allCountries = countryRepository.getAllCountries();
    final wrongOptions =
        allCountries.where((c) => c.code != correctCountry.code).toList()
          ..shuffle(_random);

    return wrongOptions.take(count).toList();
  }

  /// Start countdown timer
  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeRemaining > 0) {
        state = state.copyWith(timeRemaining: state.timeRemaining - 1);
      } else {
        // Time's up - auto submit wrong answer
        _timer?.cancel();
        _handleTimeout();
      }
    });
  }

  /// Handle timer timeout
  void _handleTimeout() {
    if (state.status != GameStatus.playing) return;

    // Mark as incorrect
    state = state.copyWith(
      status: GameStatus.answered,
      isCorrect: false,
      incorrectAnswers: state.incorrectAnswers + 1,
      currentStreak: 0,
    );

    // In Classic mode, timeout ends the game
    if (mode == GameMode.classic) {
      Future.delayed(const Duration(seconds: 2), _endGame);
    }
    // For other modes, user must click "Next Question" button
  }

  /// Handle answer submission
  void submitAnswer(CountryModel answer) {
    if (state.status != GameStatus.playing) return;

    _timer?.cancel();

    final isCorrect = answer.code == state.currentQuestion!.correctAnswer.code;

    // Calculate score
    int scoreToAdd = 0;
    int newStreak = state.currentStreak;
    int bestStreak = state.bestStreak;

    if (isCorrect) {
      scoreToAdd =
          GameConstants.baseCorrectPoints +
          (state.timeRemaining * GameConstants.timeBonus);
      newStreak = state.currentStreak + 1;

      // Update best streak
      if (newStreak > bestStreak) {
        bestStreak = newStreak;
        persistenceService.saveBestStreak(bestStreak);
      }
    } else {
      newStreak = 0;
    }

    state = state.copyWith(
      status: GameStatus.answered,
      selectedAnswer: answer,
      isCorrect: isCorrect,
      score: state.score + scoreToAdd,
      correctAnswers:
          isCorrect ? state.correctAnswers + 1 : state.correctAnswers,
      incorrectAnswers:
          isCorrect ? state.incorrectAnswers : state.incorrectAnswers + 1,
      currentStreak: newStreak,
      bestStreak: bestStreak,
    );

    // Classic mode: incorrect answer ends game after delay
    if (mode == GameMode.classic && !isCorrect) {
      Future.delayed(const Duration(seconds: 2), _endGame);
    }
    // For other modes and correct answers, user must click "Next Question" button
  }

  /// End the game
  void _endGame() {
    _timer?.cancel();

    state = state.copyWith(status: GameStatus.gameOver);

    // Save statistics
    final highScore = persistenceService.getHighScore();
    if (state.score > highScore) {
      persistenceService.saveHighScore(state.score);
    }

    persistenceService.incrementTotalGames();
    persistenceService.incrementTotalCorrect(state.correctAnswers);
    persistenceService.saveLastMode(mode);
  }

  /// Public method to end game (called from exit dialog)
  void endGame() {
    _endGame();
  }

  /// Public method to move to next question (called from Next button)
  void nextQuestion() {
    if (state.status == GameStatus.answered) {
      _timer?.cancel();
      state = state.copyWith(status: GameStatus.playing);
      _generateQuestion();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
