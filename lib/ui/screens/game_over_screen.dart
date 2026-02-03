import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/game_mode.dart';
import '../../data/services/persistence_service.dart';
import '../../logic/game_state.dart';
import 'home_screen.dart';
import 'game_screen.dart';

/// Game over summary screen
class GameOverScreen extends ConsumerStatefulWidget {
  final GameState finalState;
  final GameMode mode;

  const GameOverScreen({
    super.key,
    required this.finalState,
    required this.mode,
  });

  @override
  ConsumerState<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends ConsumerState<GameOverScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isNewHighScore = false;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();

    // Save game stats
    _saveGameStats();
  }

  void _saveGameStats() async {
    final persistenceService = ref.read(persistenceServiceProvider);

    // Check if new high score
    final oldHighScore = persistenceService.getHighScore();
    if (widget.finalState.score > oldHighScore) {
      _isNewHighScore = true;
      await persistenceService.saveHighScore(widget.finalState.score);
    }

    // Save other stats
    await persistenceService.saveBestStreak(widget.finalState.bestStreak);
    await persistenceService.incrementTotalGames();
    await persistenceService.incrementTotalCorrect(
      widget.finalState.correctAnswers,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accuracy =
        widget.finalState.questionNumber > 0
            ? (widget.finalState.correctAnswers /
                widget.finalState.questionNumber *
                100)
            : 0.0;

    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Trophy icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isNewHighScore ? Icons.emoji_events : Icons.flag,
                      size: 60,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    _isNewHighScore ? 'New High Score!' : 'Game Over',
                    style: Theme.of(context).textTheme.displayLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.mode.title,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Stats cards
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          _StatRow(
                            label: 'Final Score',
                            value: widget.finalState.score.toString(),
                            icon: Icons.stars,
                            color: AppColors.primary,
                            isLarge: true,
                          ),
                          const Divider(height: 32),
                          _StatRow(
                            label: 'Questions Answered',
                            value: widget.finalState.questionNumber.toString(),
                            icon: Icons.quiz,
                          ),
                          const SizedBox(height: 16),
                          _StatRow(
                            label: 'Correct Answers',
                            value: widget.finalState.correctAnswers.toString(),
                            icon: Icons.check_circle,
                            color: AppColors.correct,
                          ),
                          const SizedBox(height: 16),
                          _StatRow(
                            label: 'Accuracy',
                            value: '${accuracy.toStringAsFixed(1)}%',
                            icon: Icons.percent,
                          ),
                          const SizedBox(height: 16),
                          _StatRow(
                            label: 'Best Streak',
                            value: widget.finalState.bestStreak.toString(),
                            icon: Icons.local_fire_department,
                            color: AppColors.timerWarning,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed:
                              _isNavigating
                                  ? null
                                  : () {
                                    if (_isNavigating) return;
                                    setState(() => _isNavigating = true);
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (_) => const HomeScreen(),
                                      ),
                                      (route) => false,
                                    );
                                  },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          child: const Text('Home'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              _isNavigating
                                  ? null
                                  : () {
                                    if (_isNavigating) return;
                                    setState(() => _isNavigating = true);
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder:
                                            (_) =>
                                                GameScreen(mode: widget.mode),
                                      ),
                                    );
                                  },
                          child: const Text('Play Again'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isLarge;

  const _StatRow({
    required this.label,
    required this.value,
    required this.icon,
    this.color = AppColors.textPrimary,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: isLarge ? 28 : 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: isLarge ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        Text(
          value,
          style:
              isLarge
                  ? Theme.of(
                    context,
                  ).textTheme.displayMedium?.copyWith(color: color)
                  : Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: color),
        ),
      ],
    );
  }
}
