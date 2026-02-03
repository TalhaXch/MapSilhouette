import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/game_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/country_model.dart';
import '../../data/models/game_mode.dart';
import '../../logic/game_controller.dart';
import '../../logic/game_state.dart';
import '../widgets/country_silhouette.dart';
import '../widgets/answer_button.dart';
import '../widgets/timer_widget.dart';
import '../widgets/score_widget.dart';
import 'game_over_screen.dart';

/// Main game screen
class GameScreen extends ConsumerStatefulWidget {
  final GameMode mode;

  const GameScreen({super.key, required this.mode});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  bool _navigatedToGameOver = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // Start the game when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gameControllerProvider(widget.mode).notifier).startGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameControllerProvider(widget.mode));
    final controller = ref.read(gameControllerProvider(widget.mode).notifier);

    // Navigate to game over screen when game ends
    if (gameState.status == GameStatus.gameOver && !_navigatedToGameOver) {
      _navigatedToGameOver = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder:
                (_) => GameOverScreen(finalState: gameState, mode: widget.mode),
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showExitDialog(context, controller),
        ),
        title: Text(
          widget.mode.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          // Score display
          ScoreWidget(score: gameState.score),
          const SizedBox(width: 16),
        ],
      ),
      body:
          gameState.currentQuestion == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  // Progress bar (only for Timed Challenge)
                  if (widget.mode == GameMode.timedChallenge)
                    LinearProgressIndicator(
                      value:
                          gameState.questionNumber /
                          GameConstants.timedChallengeQuestions,
                      backgroundColor: AppColors.silhouetteBackground,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Question number and timer
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Question ${gameState.questionNumber}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (widget.mode != GameMode.practice)
                          TimerWidget(timeRemaining: gameState.timeRemaining),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Country silhouette
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: CountrySilhouette(
                        country: gameState.currentQuestion!.correctAnswer,
                        isRevealed: gameState.status == GameStatus.answered,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Answer buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildAnswerButtons(gameState, controller),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
    );
  }

  Widget _buildAnswerButtons(GameState gameState, GameController controller) {
    final options = gameState.currentQuestion!.options;
    final isAnswered = gameState.status == GameStatus.answered;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: AnswerButton(
                country: options[0],
                onPressed:
                    isAnswered || _isProcessing
                        ? null
                        : () => _handleAnswer(options[0], controller),
                isSelected: gameState.selectedAnswer?.code == options[0].code,
                isCorrect:
                    options[0].code ==
                    gameState.currentQuestion!.correctAnswer.code,
                showFeedback: isAnswered,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AnswerButton(
                country: options[1],
                onPressed:
                    isAnswered || _isProcessing
                        ? null
                        : () => _handleAnswer(options[1], controller),
                isSelected: gameState.selectedAnswer?.code == options[1].code,
                isCorrect:
                    options[1].code ==
                    gameState.currentQuestion!.correctAnswer.code,
                showFeedback: isAnswered,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AnswerButton(
                country: options[2],
                onPressed:
                    isAnswered || _isProcessing
                        ? null
                        : () => _handleAnswer(options[2], controller),
                isSelected: gameState.selectedAnswer?.code == options[2].code,
                isCorrect:
                    options[2].code ==
                    gameState.currentQuestion!.correctAnswer.code,
                showFeedback: isAnswered,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AnswerButton(
                country: options[3],
                onPressed:
                    isAnswered || _isProcessing
                        ? null
                        : () => _handleAnswer(options[3], controller),
                isSelected: gameState.selectedAnswer?.code == options[3].code,
                isCorrect:
                    options[3].code ==
                    gameState.currentQuestion!.correctAnswer.code,
                showFeedback: isAnswered,
              ),
            ),
          ],
        ),
        if (isAnswered) ...[
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed:
                _isProcessing
                    ? null
                    : () {
                      if (_isProcessing) return;
                      setState(() => _isProcessing = true);
                      controller.nextQuestion();
                      Future.delayed(const Duration(milliseconds: 300), () {
                        if (mounted) setState(() => _isProcessing = false);
                      });
                    },
            child: const Text('Next Question'),
          ),
        ],
      ],
    );
  }

  void _handleAnswer(CountryModel answer, GameController controller) {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    // Haptic feedback
    HapticFeedback.mediumImpact();

    // Submit answer
    controller.submitAnswer(answer);

    // Reset processing flag after delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _isProcessing = false);
    });
  }

  void _showExitDialog(BuildContext context, GameController controller) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Exit Game?'),
            content: const Text('Your progress will be lost.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  controller.endGame();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('Exit'),
              ),
            ],
          ),
    );
  }
}
