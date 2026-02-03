import 'package:equatable/equatable.dart';
import '../data/models/country_model.dart';
import '../data/models/game_mode.dart';
import '../data/models/question_model.dart';

/// Game state status
enum GameStatus { initial, playing, answered, gameOver }

/// Main game state
class GameState extends Equatable {
  final GameMode mode;
  final GameStatus status;
  final QuestionModel? currentQuestion;
  final int score;
  final int questionNumber;
  final int correctAnswers;
  final int incorrectAnswers;
  final int currentStreak;
  final int bestStreak;
  final int timeRemaining;
  final CountryModel? selectedAnswer;
  final bool isCorrect;

  const GameState({
    required this.mode,
    this.status = GameStatus.initial,
    this.currentQuestion,
    this.score = 0,
    this.questionNumber = 0,
    this.correctAnswers = 0,
    this.incorrectAnswers = 0,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.timeRemaining = 0,
    this.selectedAnswer,
    this.isCorrect = false,
  });

  GameState copyWith({
    GameMode? mode,
    GameStatus? status,
    QuestionModel? currentQuestion,
    int? score,
    int? questionNumber,
    int? correctAnswers,
    int? incorrectAnswers,
    int? currentStreak,
    int? bestStreak,
    int? timeRemaining,
    CountryModel? selectedAnswer,
    bool? isCorrect,
    bool clearSelectedAnswer = false,
  }) {
    return GameState(
      mode: mode ?? this.mode,
      status: status ?? this.status,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      score: score ?? this.score,
      questionNumber: questionNumber ?? this.questionNumber,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      incorrectAnswers: incorrectAnswers ?? this.incorrectAnswers,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      selectedAnswer:
          clearSelectedAnswer ? null : (selectedAnswer ?? this.selectedAnswer),
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  @override
  List<Object?> get props => [
    mode,
    status,
    currentQuestion,
    score,
    questionNumber,
    correctAnswers,
    incorrectAnswers,
    currentStreak,
    bestStreak,
    timeRemaining,
    selectedAnswer,
    isCorrect,
  ];
}
