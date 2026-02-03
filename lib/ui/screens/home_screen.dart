import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/game_mode.dart';
import '../../data/services/persistence_service.dart';
import '../widgets/game_mode_card.dart';
import '../widgets/stats_card.dart';
import 'game_screen.dart';

/// Home screen with mode selection and stats
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final persistenceService = ref.watch(persistenceServiceProvider);
    final highScore = persistenceService.getHighScore();
    final bestStreak = persistenceService.getBestStreak();
    final totalGames = persistenceService.getTotalGames();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // Title
              Text(
                'MapSilhouette',
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Can you guess the country?',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Stats Section
              Row(
                children: [
                  Expanded(
                    child: StatsCard(
                      title: 'High Score',
                      value: highScore.toString(),
                      icon: Icons.emoji_events,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatsCard(
                      title: 'Best Streak',
                      value: bestStreak.toString(),
                      icon: Icons.local_fire_department,
                      color: AppColors.timerWarning,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              StatsCard(
                title: 'Total Games',
                value: totalGames.toString(),
                icon: Icons.gamepad,
                color: AppColors.correct,
              ),
              const SizedBox(height: 40),

              // Game Mode Selection
              Text(
                'Select Game Mode',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              // Classic Mode
              GameModeCard(
                mode: GameMode.classic,
                onTap: () => _startGame(context, ref, GameMode.classic),
              ),
              const SizedBox(height: 12),

              // Timed Challenge
              GameModeCard(
                mode: GameMode.timedChallenge,
                onTap: () => _startGame(context, ref, GameMode.timedChallenge),
              ),
              const SizedBox(height: 12),

              // Practice Mode
              GameModeCard(
                mode: GameMode.practice,
                onTap: () => _startGame(context, ref, GameMode.practice),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _startGame(BuildContext context, WidgetRef ref, GameMode mode) {
    // Save last mode
    ref.read(persistenceServiceProvider).saveLastMode(mode);

    // Navigate to game screen
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => GameScreen(mode: mode)));
  }
}
