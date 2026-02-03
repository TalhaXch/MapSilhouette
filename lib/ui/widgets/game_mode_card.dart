import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/game_mode.dart';

/// Card for selecting a game mode
class GameModeCard extends StatelessWidget {
  final GameMode mode;
  final VoidCallback onTap;

  const GameModeCard({super.key, required this.mode, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIconForMode(mode),
                  size: 28,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mode.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mode.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              // Arrow
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForMode(GameMode mode) {
    switch (mode) {
      case GameMode.classic:
        return Icons.sports_esports;
      case GameMode.timedChallenge:
        return Icons.timer;
      case GameMode.practice:
        return Icons.school;
    }
  }
}
